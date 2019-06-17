Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19E47A35
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 08:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfFQGt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 02:49:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51203 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725778AbfFQGt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 02:49:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C5D0422305;
        Mon, 17 Jun 2019 02:49:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 Jun 2019 02:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Iw25qk
        eb0kmpnfALU4HyWOgG8OY5gVRa4ZQ8gjSGr6I=; b=hZ49yC5hgrLgHvODWkdvmg
        vJKQUNoLP97hroS5TnsYLtSAIhZF8KFHSNxtjAQOblzbesNNr449TLTNjDYh87oS
        NfAY19/10DX3B6LV+mzAr7QN6P10syBY4bcyVG6EG8mPG7mA5IIUDRjB1BxlKy+S
        +qWWZmQYGMWFEwCsTu3rOB+nNHG7h5npuhPaZE4l6aOyk9xlzabyo5/iqt0M7O+r
        YzJ+xmWC18FPkGp4zig/JCy86jWQeovH4gJdChp+OMZEPo0tdN1I7HBn1xX8nn1J
        7SbnXcA1eYUi/By3iN5Q3gh+0Qz1tZK4ZWqdbXZx4j7JQ1OID0O6mDlf16FkgF5Q
        ==
X-ME-Sender: <xms:EjgHXRgk20uHfCVxDxJSJpnxiKcWVeuWbrluBlosko5dyLkyvuzpgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeiiedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EzgHXcs-XPSgRGPCwFfaWjr-GboAbarggZTMsmXEDBNEXs044UbDKQ>
    <xmx:EzgHXbTsoFoqIBCebZg9ItF2F3mxFB_KJ1YOp5rTPHcpbbfGR2PbkQ>
    <xmx:EzgHXW6eI5Cyr5MpGrNykKSUIZCr-SnvZ_6e2-cKRpKp_vQoyyVmDQ>
    <xmx:EzgHXVsCkCM5rlTEsfliKbBv2V1TBf3hIIj8u1B5WpHCQsJFuyLZ3g>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A97A8005B;
        Mon, 17 Jun 2019 02:49:54 -0400 (EDT)
Date:   Mon, 17 Jun 2019 09:49:52 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 08/17] netdevsim: Adjust accounting for IPv6
 multipath notifications
Message-ID: <20190617064952.GC3810@splinter>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-9-idosch@idosch.org>
 <25bb06eb-bd2a-de85-9903-19215703363a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25bb06eb-bd2a-de85-9903-19215703363a@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 07:27:13PM -0600, David Ahern wrote:
> On 6/15/19 8:07 AM, Ido Schimmel wrote:
> > diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
> > index 83ba5113210d..6e5498ef3855 100644
> > --- a/drivers/net/netdevsim/fib.c
> > +++ b/drivers/net/netdevsim/fib.c
> > @@ -137,19 +137,20 @@ static int nsim_fib_rule_event(struct nsim_fib_data *data,
> >  }
> >  
> >  static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
> > +			    unsigned int num_rt,
> >  			    struct netlink_ext_ack *extack)
> >  {
> >  	int err = 0;
> >  
> >  	if (add) {
> > -		if (entry->num < entry->max) {
> > -			entry->num++;
> > +		if (entry->num + num_rt < entry->max) {
> > +			entry->num += num_rt;
> >  		} else {
> >  			err = -ENOSPC;
> >  			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
> >  		}
> >  	} else {
> > -		entry->num--;
> > +		entry->num -= num_rt;
> >  	}
> >  
> >  	return err;
> > @@ -159,14 +160,20 @@ static int nsim_fib_event(struct nsim_fib_data *data,
> >  			  struct fib_notifier_info *info, bool add)
> >  {
> >  	struct netlink_ext_ack *extack = info->extack;
> > +	struct fib6_entry_notifier_info *fen6_info;
> > +	unsigned int num_rt = 1;
> >  	int err = 0;
> >  
> >  	switch (info->family) {
> >  	case AF_INET:
> > -		err = nsim_fib_account(&data->ipv4.fib, add, extack);
> > +		err = nsim_fib_account(&data->ipv4.fib, add, num_rt, extack);
> >  		break;
> >  	case AF_INET6:
> > -		err = nsim_fib_account(&data->ipv6.fib, add, extack);
> > +		fen6_info = container_of(info, struct fib6_entry_notifier_info,
> > +					 info);
> > +		if (fen6_info->multipath_rt)
> > +			num_rt = fen6_info->nsiblings + 1;
> > +		err = nsim_fib_account(&data->ipv6.fib, add, num_rt, extack);
> 
> The intention of the original patch was to account for a multipath route
> as 1 entry, not N where N is the number of paths.

:)

Didn't want to change existing behavior in case you have tests that
would fail because of that. I guess that's not the case. Will treat it
as one entry.
