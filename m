Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93379CA0EE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJCPKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:10:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56305 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfJCPKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:10:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DC35421FE5;
        Thu,  3 Oct 2019 11:10:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 11:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5FAGn8
        gQH6gqgQViDm3DmSm6o0eLqO/erkFaY7oUQnU=; b=nYEyMCVmFxTp1ZnJSZJZhr
        gQDn7Yj4gAZaZJ3oUZkfPE/XFBpGy4pNtfUpY5lbXI0ZLMXjP1ZPHms7P0z1hIbQ
        1WLMsnHf2JntJJD13FYROl9Q769B9dqh2ga7CBfAPLe1TIN6ptk4sJkuOG3iKitY
        KtBBfp6edygMMJJSxtm+cj/pc9/9pMDEX+AJ9QSchrYVuyBzdc4ZR7cbyzDWziiO
        oLGjkx5x+9zow/LIARuXPKr/btVNEPDo7f0TDUeZnMusMzG0zmqieJDWu5zUsL35
        GJe6bwVejkckFxdYjYLpcdioG9YSmaifD6Onp8r2sTbDb4OL/KjKdXvbCKPUshyQ
        ==
X-ME-Sender: <xms:bg-WXSX3tZ6my964LHqlcQoIyMMeRU9xTIUP8N57Y7IzWXK1uflc1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:bg-WXQ4dm5iX3rBGP1cGmB0oc4JsJqs-rymU-tE-3X98xGUisoRpdQ>
    <xmx:bg-WXVFQ4V9qLCRKZSagxhULW09UJaPhPUheui83mxKi7Fvu3JSdEg>
    <xmx:bg-WXWQO8QLPMHYGyjVG-PH6oFH2K9wRWMUmLArVVY0-z4wlWkhOLA>
    <xmx:bg-WXWvDaeUduKBuboFWuhz8c5TIMgBuJf3QC4afusTeQK-F6aGygw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAF38D60066;
        Thu,  3 Oct 2019 11:10:37 -0400 (EDT)
Date:   Thu, 3 Oct 2019 18:10:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 08/15] mlxsw: spectrum_router: Start using
 new IPv4 route notifications
Message-ID: <20191003151035.GA26217@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-9-idosch@idosch.org>
 <20191002175230.GC2279@nanopsycho>
 <20191002180144.GD2279@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002180144.GD2279@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:01:44PM +0200, Jiri Pirko wrote:
> Wed, Oct 02, 2019 at 07:52:30PM CEST, jiri@resnulli.us wrote:
> >Wed, Oct 02, 2019 at 10:40:56AM CEST, idosch@idosch.org wrote:
> >>From: Ido Schimmel <idosch@mellanox.com>
> >>
> >>With the new notifications mlxsw does not need to handle identical
> >>routes itself, as this is taken care of by the core IPv4 code.
> >>
> >>Instead, mlxsw only needs to take care of inserting and removing routes
> >>from the device.
> >>
> >>Convert mlxsw to use the new IPv4 route notifications and simplify the
> >>code.
> >>
> >
> >[...]
> >
> >
> >>@@ -6246,9 +6147,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
> >> 		err = mlxsw_sp_router_fib_rule_event(event, info,
> >> 						     router->mlxsw_sp);
> >> 		return notifier_from_errno(err);
> >>-	case FIB_EVENT_ENTRY_ADD:
> >>+	case FIB_EVENT_ENTRY_ADD: /* fall through */
> >> 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
> >> 	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
> >
> >Why don't you skip the three above with just return of NOTIFY_DONE?
> 
> if (info->family == AF_INET)
> 	return NOTIFY_DONE;

It's not really needed given ADD and APPEND are not sent for AF_INET
after this patchset. But I did find out that I forgot to remove them
from mlxsw_sp_router_fib4_event(), so I'll do that in v1.

Thanks!

> 
> >
> >
> >>+	case FIB_EVENT_ENTRY_REPLACE_TMP:
> >> 		if (router->aborted) {
> >> 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
> >> 			return notifier_from_errno(-EINVAL);
> >>-- 
> >>2.21.0
> >>
