Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB273451
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfGXQ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:57:32 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56411 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbfGXQ5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:57:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A5FC7125A;
        Wed, 24 Jul 2019 12:57:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 12:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FkEw4W
        7ehtTm+q7kCmR6lO4anhI7KE1/g4HEN4AWYnc=; b=12sBedEJCcRgz7uXZHiFWH
        pky2OG6XqUC9GBr9uZVA6IK7saZCWG+Zavk5qor5ZqfhXic8NaukkzYCfI8nz5/a
        qdjjqlm31cvQ820yeMBcMmsK1xEu86pTvxKTkrpxdf1NbpRh52DgG3JqHmu/UDHP
        wkL2ciXf/MXXysOP1uWwXi0Pmqd6W1IxK2xWAA1IxACGxoBAXUnl1Kw2uLvvgf0h
        zT1pYjODgtTRMc6yUSy2vBjiuY9ExgJxxFSDP+8Uakm1Aa0KUPGkw5C2UhOr3T6t
        9zBx3D7HiqRJrcRSxXsFFdAuiY+tk8WgPSBWiPxBe++Z2gIulSHv9yLlLfjk854Q
        ==
X-ME-Sender: <xms:-I04XZkIhTIceBBiLqnJCVYbUqD-gelBUKT2J9kLkpdj4hAJuD1QZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:-I04XYIN_Jm2tbBKDnjMyX_ZwIxZMdBKunDfDWc2AEpVCxFRRj6O9w>
    <xmx:-I04XTs2hEKKbw7pjY8zSVGg244iIpiYkJl2VDSh3jJW5b-qua4Bvw>
    <xmx:-I04Xf9iN3ibYlEWdCwnzvayBMeSsCbY6DpYg3OC6v9iKIWfig6lLg>
    <xmx:-404XS2bWdkiF0rge_tF3ZIQ7Dns4xbWvCOYeK-0OC1dRi32tvgD0w>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A17BA380074;
        Wed, 24 Jul 2019 12:57:27 -0400 (EDT)
Date:   Wed, 24 Jul 2019 19:57:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode
Message-ID: <20190724165725.GC20252@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-11-idosch@idosch.org>
 <20190724125341.GB2225@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724125341.GB2225@nanopsycho>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 02:53:41PM +0200, Jiri Pirko wrote:
> Mon, Jul 22, 2019 at 08:31:32PM CEST, idosch@idosch.org wrote:
> >+static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
> >+	[NET_DM_ALERT_MODE_SUMMARY]	= &net_dm_alert_summary_ops,
> >+	[NET_DM_ALERT_MODE_PACKET]	= &net_dm_alert_packet_ops,
> >+};
> 
> Please split this patch into 2:
> 1) introducing the ops and modes (only summary)
> 2) introducing the packet mode

Ack

...

> >+static int net_dm_alert_mode_set(struct genl_info *info)
> >+{
> >+	struct netlink_ext_ack *extack = info->extack;
> >+	enum net_dm_alert_mode alert_mode;
> >+	int rc;
> >+
> >+	if (!info->attrs[NET_DM_ATTR_ALERT_MODE])
> >+		return 0;
> >+
> >+	rc = net_dm_alert_mode_get_from_info(info, &alert_mode);
> >+	if (rc) {
> >+		NL_SET_ERR_MSG_MOD(extack, "Invalid alert mode");
> >+		return -EINVAL;
> >+	}
> >+
> >+	net_dm_alert_mode = alert_mode;
> 
> 2 things:
> 1) Shouldn't you check if the tracing is on and return -EBUSY in case it is?

I'm doing it below in net_dm_cmd_config() :)
But I'm returning '-EOPNOTSUPP'. I guess '-EBUSY' is more appropriate.
Will change.

> 2) You setup the mode globally. I guess it is fine and it does not make
>    sense to do it otherwise, right? Like per-net or something.

Yes, it's global. I didn't change that aspect of drop monitor and I
don't really see a use case for that.

> 
> 
> >+
> >+	return 0;
> >+}
> >+
> > static int net_dm_cmd_config(struct sk_buff *skb,
> > 			struct genl_info *info)
> > {
> >-	NL_SET_ERR_MSG_MOD(info->extack, "Command not supported");
> >+	struct netlink_ext_ack *extack = info->extack;
> >+	int rc;
> > 
> >-	return -EOPNOTSUPP;
> >+	if (trace_state == TRACE_ON) {
> >+		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor while tracing is on");
> >+		return -EOPNOTSUPP;
> >+	}
> >+
> >+	rc = net_dm_alert_mode_set(info);
> >+	if (rc)
> >+		return rc;
> >+
> >+	return 0;
> > }
