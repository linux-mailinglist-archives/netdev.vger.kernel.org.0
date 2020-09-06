Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6756325EEF4
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgIFP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:59:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43975 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbgIFP7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 11:59:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 481885C00E0;
        Sun,  6 Sep 2020 11:59:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 06 Sep 2020 11:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GrRz/e
        qbtlSmrGyXDaaMCTI6gWJzvvz6fXmQgN53lF8=; b=OVCEDwoZ78E5mfRCc4xRwU
        p17rmeNoYd5+EmZwxfREiFG1UjAcPxIVriBR8a1SQP8zera0GcpiHEc50c0khn0Z
        Qx3tb2y6mWmoEtBr2B7bR1TibZyyYd7uNANKpAIaN1thQPUpj6qRJ86oLxx9NuW7
        ZxzTLoV3eibDCh2CaoRMvkh39+p+vpByn8PhlPq1mp8dk+CCuUygrMpiTCtwrvvc
        w6TpnMdK6LqgK6MJIObgvJTEYrN4t4FSFo3nAglXPRqE7R5EPaJ45M0HBpBApXCY
        ZYgWg000pxC0FbALeTBRMjeQx9meLQaIy/BkAVWNiu85ZrPz2/s1DZpV2O6aQYWw
        ==
X-ME-Sender: <xms:RAdVX8hxfi6zidFCNMU0YPhLopyUWBHUHCDqvv-0CKkYFpqpLMJB4w>
    <xme:RAdVX1A-ZgKzKctDDovRnGlco_vOFVVDiowMjVhlG3_OP6ibQbuYdr6IDk7exhqj-
    oiJEgCT_L5RcPo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegjedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedruddvkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RAdVX0HApKojEA1pE1h0OOKCswkTQ_ctnUcKSsH0uQQ1oJ5khLiaAQ>
    <xmx:RAdVX9Str4vLVbHckiepFJ_rk-qQgHMuvDVeVTewW_ySgL-Ndzq8lw>
    <xmx:RAdVX5w_raOSfflJ5z-L7NRKnIdmQ8mLhjjr7tpEbrpr_5_XYqKpZg>
    <xmx:RQdVX8r209k1aRhd6UYrEauKkgXPYPvw1cl1kDAYpYa1wzxlpVddPg>
Received: from localhost (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74B6C328005D;
        Sun,  6 Sep 2020 11:59:00 -0400 (EDT)
Date:   Sun, 6 Sep 2020 18:58:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v1 3/4] devlink: Add hierarchy between traps
 in device level and port level
Message-ID: <20200906155858.GB2431016@shredder>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
 <1599060734-26617-4-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599060734-26617-4-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 06:32:13PM +0300, Aya Levin wrote:
> Managing large scale port's traps may be complicated. This patch
> introduces a shortcut: when setting a trap on a device and this trap is
> not registered on this device, the action will take place on all related
> ports that did register this trap.

I'm not really a fan of this and I'm not sure there is precedent for
something similar. Also, it's an optimization, so I wouldn't put it as
part of the first submission before you gather some operational
experience with the initial interface.

In addition, I find it very unintuitive for users. When I do 'devlink
trap show' I will not see anything. I will only see the traps when I
issue 'devlink port trap show', yet 'devlink trap set ...' is expected
to work.

Lets assume that this is a valid change, it would be better implemented
with my suggestion from the previous patch: When devlink sees that a
trap is registered on all the ports it can auto-register a new
per-device trap and user space gets the appropriate notification.

> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> ---
>  net/core/devlink.c | 43 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index b13e1b40bf1c..dea5482b2517 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6501,23 +6501,46 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
>  	struct devlink *devlink = info->user_ptr[0];
>  	struct devlink_trap_mngr *trap_mngr;
>  	struct devlink_trap_item *trap_item;
> +	struct devlink_port *devlink_port;
>  	int err;
>  
> -	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
> -	if (list_empty(&trap_mngr->trap_list))
> -		return -EOPNOTSUPP;
> +	devlink_port = devlink_port_get_from_attrs(devlink, info->attrs);
> +	if (IS_ERR(devlink_port)) {
> +		trap_mngr =  &devlink->trap_mngr;
> +		if (list_empty(&trap_mngr->trap_list))
> +			goto loop_over_ports;
>  
> -	trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
> -	if (!trap_item) {
> -		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
> -		return -ENOENT;
> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
> +		if (!trap_item)
> +			goto loop_over_ports;
> +	} else {
> +		trap_mngr = &devlink_port->trap_mngr;
> +		if (list_empty(&trap_mngr->trap_list))
> +			return -EOPNOTSUPP;
> +
> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
> +		if (!trap_item) {
> +			NL_SET_ERR_MSG_MOD(extack, "Port did not register this trap");
> +			return -ENOENT;
> +		}
>  	}
>  	return devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
>  
> -	err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
> -	if (err)
> -		return err;
> +loop_over_ports:
> +	if (list_empty(&devlink->port_list))
> +		return -EOPNOTSUPP;
> +	list_for_each_entry(devlink_port, &devlink->port_list, list) {
> +		trap_mngr = &devlink_port->trap_mngr;
> +		if (list_empty(&trap_mngr->trap_list))
> +			continue;
>  
> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
> +		if (!trap_item)
> +			continue;
> +		err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
> +		if (err)
> +			return err;
> +	}
>  	return 0;
>  }
>  
> -- 
> 2.14.1
> 
