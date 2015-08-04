<div class="panel preview-content">
    {* Content (pre)view in content window. *}
    {def $custom_actions = $node.object.content_action_list}
    {if $custom_actions}
        <form method="post" action={'content/action'|ezurl}>
            <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
            <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
            <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
    {/if}

    {node_view_gui content_node=$node view='admin_preview'}

    {if $custom_actions}
            <div class="button-right">
                {* Custom content action buttons. *}
                {foreach $custom_actions as $custom_action}
                    <input class="btn btn-default" type="submit" name="{$custom_action.action}" value="{$custom_action.name}" />
                {/foreach}
            </div>
        </form>
    {/if}
</div>
<div class="panel">
    <div class="block">
    {* Details window. *}

        <table class="list" cellspacing="0" summary="{'Node and object details like creator, when it was created, section it belongs to, number of versions and translations, Node ID and Object ID.'|i18n( 'design/admin/node/view/full' )}">
            <tr>
                <th>{'Creator'|i18n( 'design/admin/node/view/full' )}</th>
                <th>{'Created'|i18n( 'design/admin/node/view/full' )}</th>
                <th>{'Section'|i18n( 'design/admin/node/view/full' )}</th>
                <th class="tight">{'Versions'|i18n( 'design/admin/node/view/full' )}</th>
                <th class="tight">{'Translations'|i18n( 'design/admin/node/view/full' )}</th>
                <th class="tight">{'Node ID'|i18n( 'design/admin/node/view/full' )}</th>
                <th class="tight">{'Object ID'|i18n( 'design/admin/node/view/full' )}</th>
            </tr>
            <tr class="bglight">
                <td><a href={$node.object.owner.main_node.url_alias|ezurl}>{$node.object.owner.name|wash}</a></td>
                <td>{$node.object.published|l10n( shortdatetime )}</td>
                <td>
                <form name="changesection" id="changesection" method="post" action={concat( 'content/edit/', $node.object.id )|ezurl}>
                <input type="hidden" name="RedirectRelativeURI" value="{$node.url_alias|wash}" />
                <input type="hidden" name="ChangeSectionOnly" value="1" />

                <select id="selected-section-id" class="form-control inline input-sm" name="SelectedSectionId">
                {foreach $node.object.allowed_assign_section_list as $allowed_assign_section}
                    {if eq( $allowed_assign_section.id, $node.object.section_id )}
                    <option value="{$allowed_assign_section.id}" selected="selected">{$allowed_assign_section.name|wash}</option>
                    {else}
                    <option value="{$allowed_assign_section.id}">{$allowed_assign_section.name|wash}</option>
                    {/if}
                {/foreach}
                </select>
                <input id="tab-details-set-section" type="submit" value="{'Set'|i18n( 'design/admin/node/view/full' )}" name="SectionEditButton" class="btn btn-default btn-sm" />
                </form>

                </td>
                <td class="number" align="right">{$node.object.versions|count()}</td>
                <td class="number" align="right">{$node.contentobject_version_object.language_list|count}</td>
                <td class="number" align="right">{$node.node_id}</td>
                <td class="number" align="right">{$node.object.id}</td>
            </tr>
        </table>
    </div>
    <div class="block">
        <p>{'Last modified'|i18n( 'design/admin/node/view/full' )}: {$node.object.modified|l10n(shortdatetime)}, <a href={$node.object.current.creator.main_node.url_alias|ezurl}>{$node.object.current.creator.name|wash}</a> ({'Node ID'|i18n( 'design/admin/node/view/full' )}: {$node.node_id}, {'Object ID'|i18n( 'design/admin/node/view/full' )}: {$node.object.id})</p>
    </div>
    <br />
    <div class="block">
        <table class="list" cellspacing="0" summary="{'Node Remote ID and Object Remote ID'|i18n( 'design/admin/node/view/full' )}">
            <tr>
                <th>{'Node Remote ID'|i18n( 'design/admin/node/view/full' )}</th>
                <th>{'Object Remote ID'|i18n( 'design/admin/node/view/full' )}</th>
            </tr>
            <tr>
                 <td>{$node.remote_id|wash}</td>
                 <td>{$node.object.remote_id|wash}</td>
            </tr>
        </table>
    </div>

    <br />

    <div class="block">
        <h3>{'Content state'|i18n( 'design/admin/node/view/full' )}</h3>

        {* States window. *}
        <form name="statesform" method="post" action={'state/assign'|ezurl}>
            <input type="hidden" name="ObjectID" value="{$node.object.id}" />
            <input type="hidden" name="RedirectRelativeURI" value="{$node.url_alias|wash}" />

            <table id="tab-details-states-list" class="list" cellspacing="0" summary="{'States and their states groups for current object.'|i18n( 'design/admin/node/view/full' )}">
            {if $states_count}
                <tr>
                    <th class="tight">{'State group'|i18n( 'design/admin/node/view/full' )}</th>
                    <th class="wide">{'Available states'|i18n( 'design/admin/node/view/full' )}</th>
                </tr>

                {foreach $states as $allowed_assign_state_info sequence array( 'bglight', 'bgdark' ) as $sequence}
                <tr class="{$sequence}">
                    <td>{$allowed_assign_state_info.group.current_translation.name|wash}</td>
                    <td>
                        <select name="SelectedStateIDList[]" {if $allowed_assign_state_info.states|count|eq(1)}disabled="disabled"{/if}>
                        {foreach $allowed_assign_state_info.states as $state}
                            <option value="{$state.id}" {if $node.object.state_id_array|contains($state.id)}selected="selected"{/if}>{$state.current_translation.name|wash}</option>
                        {/foreach}
                        </select>
                    </td>
                </tr>
                {/foreach}
            {else}
                <tr class="bgdark">
                <td colspan="2">
                <em>{'No content object state is configured. This can be done %urlstart here%urlend.'|i18n( 'design/admin/node/view/full', '', hash( '%urlstart', concat( '<a href=', 'state/groups'|ezurl, '>' ), '%urlend', '</a>' ) )}</em>
                </td>
                </tr>
            {/if}
            </table>

            <div class="button-left">
                {if $states_count}
                <input class="btn btn-default btn-sm" type="submit" id="tab-details-set-states" value="{'Set states'|i18n( 'design/admin/node/view/full' )}" name="AssignButton" class="button" title="{'Apply states from the list above.'|i18n( 'design/admin/node/view/full' )}" />
                {else}
                <input class="btn btn-default btn-sm" type="submit" id="tab-details-set-states" value="{'Set states'|i18n( 'design/admin/node/view/full' )}" name="AssignButton" class="button-disabled" disabled="disabled" title="{'No state to be applied to this content object. You might need to be assigned a more permissive access policy.'|i18n( 'design/admin/node/view/full' )}"/>
                {/if}
            </div>
            <div class="break"></div>

        </form>
    </div>
</div>
<script type="text/javascript">
{literal}
(function( $ )
{
    $('#tab-details-states-list select').change(function()
    {
        var btn = $('#tab-details-set-states');
        if ( !btn.attr('disabled') )
        {
            btn.removeClass('button').addClass('defaultbutton');
        }
    });
    $('#selected-section-id').change(function()
    {
        var btn = $('#tab-details-set-section');
        if ( !btn.attr('disabled') )
        {
            btn.removeClass('button').addClass('defaultbutton');
        }
    });
})( jQuery );
{/literal}
</script>