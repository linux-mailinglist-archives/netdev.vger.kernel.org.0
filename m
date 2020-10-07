Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03A285D29
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgJGKsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgJGKs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:48:29 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C1D2080A;
        Wed,  7 Oct 2020 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602067709;
        bh=/JxyUEVBJzA3+FxMJZ4y1gG+BmvG9BzPEsF83nMnaOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYf6kyCMvF9/fxucswIu2u32tL/gPARDNySHfkNL03qB738G6ZzOwmxIgP1dX5had
         aBvsuukIjZ6v8QA8a7LD71LiI176j0hElDWqtsCj7Gy9hJsgj/L0i2KCU7N9FWWe4s
         h5vT9Hh09/ArK0CjMAHYqCoiyi6JKtiiTe72dA88=
Date:   Wed, 7 Oct 2020 13:48:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
Message-ID: <20201007104824.GB3678159@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
 <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
 <20201006.062618.628708952352439429.davem@davemloft.net>
 <20201007062754.GU1874917@unreal>
 <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
 <20201007082437.GV1874917@unreal>
 <20201007085247.g4vb5kate74s45eo@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007085247.g4vb5kate74s45eo@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 10:52:47AM +0200, Michal Kubecek wrote:
> On Wed, Oct 07, 2020 at 11:24:37AM +0300, Leon Romanovsky wrote:
> > Yes, it fixed KASAN, but it we got new failure after that.
> >
> > 11:07:51 player_id: 1 shell.py:62 [LinuxEthtoolAgent] DEBUG : running command(/opt/mellanox/ethtool/sbin/ethtool --set-channels eth2 combined 3) with pid: 13409
> > 11:07:51 player_id: 1 protocol.py:605 [OpSetChannels] ERROR : RC:1, STDERR:
> > netlink error: Unknown attribute type (offset 36)
> > netlink error: Invalid argument
>
> For the record, when reporting issues like this, it's useful to enable
> pretty printing and showing the messages with "--debug 0x12", e.g.
>
>   ethtool --debug 0x12 --setchannels eth2 combined 3
>
> That will show both requests and replies and will also highlight the
> offending attribute.

Thanks

>
> Michal
