Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56071B2F22
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfIOIGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 04:06:09 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54275 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfIOIGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 04:06:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id DBEDD143C;
        Sun, 15 Sep 2019 04:06:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 04:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9d8IE7
        UM9PCnbwzm2Zdo4FHb9xYRIPFbD0aIsOh/oSc=; b=FH1tEz3w0BU1cT/jJq4GNm
        5h+iFcj2exdMUHTrCroht6qJ9jxhdUetmUbrlITCYVqP6EFhq3TDRiI7Ar2Uy5/7
        WHHf76hvELvIbWYTNpZVpCMyYYYxT3a8Lm7OJV++5dnV+3CqaMuZ0AvHkJjfTVPb
        anoawUK3NSR/6gA9uGOB70CD+19IobR8RFx5mG47vXfZOpiLfh4AC4KQGxseb7Mm
        Gb8ZhBcRMZvY2jcR8T9ldDQg5rILCC9Rocwtm9oedYVwo5hZgb3dXUW51xnEOH+v
        KdAncywNzD+D/xdW/6dULM99lYxEQyp7FSn/QQmBhuZu+9y6c2FAY0B6bFx9EoWA
        ==
X-ME-Sender: <xms:7vB9XYunBsQiHX9B8B2cs2cjo6M9yy5RAQaa8LWuf482jN_bKElptg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrdegje
    drudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7vB9XRJxJuPG_727nokkeQRhR-s2SH0reEKo898CAfZUA7r2aorEoQ>
    <xmx:7vB9XQNSAUqX-Xl3ewfZ-IuQfVRWZiPi9GbRJoxZ73AwM7MEdSRZpQ>
    <xmx:7vB9XUV1IEMZZk2syAlVpwuAnlD9jtnCBPf4wN0UmPG3poxQ60sH1A>
    <xmx:7_B9XRlJLvTd6L7rUhqBECMYBP6KO82-pS5qjd4SsHTaETAQRkzFDQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16244D60067;
        Sun, 15 Sep 2019 04:06:05 -0400 (EDT)
Date:   Sun, 15 Sep 2019 11:06:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 02/15] net: fib_notifier: make FIB notifier
 per-netns
Message-ID: <20190915080602.GA11194@splinter>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914064608.26799-3-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:45:55AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently all users of FIB notifier only cares about events in init_net.

s/cares/care/

> Later in this patchset, users get interested in other namespaces too.
> However, for every registered block user is interested only about one
> namespace. Make the FIB notifier registration per-netns and avoid
> unnecessary calls of notifier block for other namespaces.

...

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> index 5d20d615663e..fe0cc969cf94 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> @@ -248,9 +248,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
>  	struct net_device *fib_dev;
>  	struct fib_info *fi;
>  
> -	if (!net_eq(info->net, &init_net))
> -		return NOTIFY_DONE;

I don't see anymore uses of 'info->net'. Can it be removed from 'struct
fib_notifier_info' ?
