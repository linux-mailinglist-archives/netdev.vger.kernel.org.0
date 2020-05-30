Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB311E91BB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 15:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgE3Nek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 09:34:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60777 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728769AbgE3Nek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 09:34:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 61C6B5C0059;
        Sat, 30 May 2020 09:34:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 30 May 2020 09:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KTRAHO
        NSz4RVAd42U2AdoVpBLshZpZ82UPUnuhRoou4=; b=yUMBErmSQXWtrQ5ewNpdP1
        EDmwMBE9EfkJgZ5cXwEN2afsQvnveDcTfQaGY+O6DeQcT3ZnN+MI64L87Sp8o+OQ
        eEtKIKHPWZ/daFLhVVvP2c+9yvBGHGvTT4hRbN6NO2c7uv0nURl20QE/Rk83UQ9H
        vOMkkWBHMbU7S+fJQFK+Srw1r6/92K0AGwwafFKW7svEQCKd8juk5Y3e519ETUxl
        FbilRbK2pAwW28IsdkwnU6JAjHk/MFOLfBVZNa2oP9W0+59lgSEj8xR3a23yRaEY
        PkZ81+b37Gls0RsCVRBSuPoW+Aeoed1hwWVvYrZsy5PfFYhsJI0YWJ4xSlzHlwYw
        ==
X-ME-Sender: <xms:7mDSXrGthOHtc0zN9oZjNvF8G8QrjeLvxI3hpq1WZRVAB5JdMY_KGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeftddgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7mDSXoUWrR6hjaa9QfAEhZ7NvGW6inZboLlJb0hWzIRGz_azf4lgtg>
    <xmx:7mDSXtJs6qEeuI3-QS7SLkYlF4ITP_BOw3ztfFK3PYtPClp7t0q7NQ>
    <xmx:7mDSXpFtEEH94g_Je70cMV8kIAJh0lu5f9QzXDrRr3y2ONgPW6hXOg>
    <xmx:72DSXnzjOwyk-PCbQ2_J9TCGf8UtD_MODWO1WyFFR39aPbtHpSAlng>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3309A3280063;
        Sat, 30 May 2020 09:34:38 -0400 (EDT)
Date:   Sat, 30 May 2020 16:34:30 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@gmail.com, nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next 0/2] vxlan fdb nexthop misc fixes
Message-ID: <20200530133430.GA1623322@splinter>
References: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 10:12:34PM -0700, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>

Hi Roopa,

I noticed that sparse complains about the following problem in
the original submission (not handled by current set):

drivers/net/vxlan.c:884:41: warning: dereference of noderef expression

Seems to be fixed by:

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 39bc10a7fd2e..ea7af03e0957 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -881,13 +881,13 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
                        goto err_inval;
                }
 
-               if (!nh->is_group || !nh->nh_grp->mpath) {
+               nhg = rtnl_dereference(nh->nh_grp);
+               if (!nh->is_group || !nhg->mpath) {
                        NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
                        goto err_inval;
                }
 
                /* check nexthop group family */
-               nhg = rtnl_dereference(nh->nh_grp);
                switch (vxlan->default_dst.remote_ip.sa.sa_family) {
                case AF_INET:
                        if (!nhg->has_v4) {

Assuming it's correct, can you please fold it into v2?

> 
> Roopa Prabhu (2):
>   vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
>   vxlan: few locking fixes in nexthop event handler
> 
>  drivers/net/vxlan.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> -- 
> 2.1.4
> 
