<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../utilities/pagination.xsl"/>

<xsl:template name="forum-list">
    <xsl:param name="filter"/>
    <table class="forum-list m-24">
        <thead>
            <tr>
                <td class="topic"><p>Topic</p></td>
                <td class="replies"><p>Replies</p></td>
                <td class="activity-date"><p>Last active</p></td>
                <td class="activity-user"><p>Last post</p></td>
            </tr>
        </thead>
        <tbody>
            <xsl:apply-templates select="/data/forum-discussions/entry">
                <xsl:with-param name="filter" select="$filter"/>
            </xsl:apply-templates>
        </tbody>
    </table>
    <div class="pager-holder">
        <xsl:call-template name="pagination">
            <xsl:with-param name="pagination" select="/data/forum-discussions/pagination"/>
            <xsl:with-param name="pagination-url" select="'?page=$'"/>
            <xsl:with-param name="show-navigation" select="false"/>
            <xsl:with-param name="class-pagination" select="'pager'"/>
            <xsl:with-param name="class-selected" select="'active'"/>
        </xsl:call-template>
    </div>
</xsl:template>

<xsl:template match="/data/forum-discussions/entry">
    <!-- TODO  find a way to filter entries smarter-->
    <xsl:param name="filter"/>
    <xsl:variable name="id" select="@id"/>
    
    <xsl:choose>
        <xsl:when test="$filter = 'read'">
            <xsl:if test="/data/forum-discussion-member/entry/discussion/item/@id = $id">
                <xsl:call-template name="forum-list-entry"/>
            </xsl:if>
        </xsl:when>
        <xsl:when test="$filter = 'involved'">
            <xsl:if test="/data/forum-discussion-member/entry[discussion/item/@id = $id and involved='Yes']">
                <xsl:call-template name="forum-list-entry"/>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="forum-list-entry"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="forum-list-entry">
    <tr>
        <td class="topic">
            <p>
                <a href="/forum-discussion/{@id}"><xsl:value-of select="topic"/></a>
            </p>
            <xsl:choose>
                <xsl:when test="$forum-category = ''">
                    <p class="sub"><xsl:value-of select="category"/></p>
                </xsl:when>
            </xsl:choose>
        </td>
        <td class="replies"><p><xsl:value-of select="number-of-replies"/></p></td>
        <td class="activity-date"><p><xsl:value-of select="last-active"/></p></td>
        <td class="activity-user"><p><xsl:value-of select="last-poster"/></p></td>
    </tr>
</xsl:template>

</xsl:stylesheet>