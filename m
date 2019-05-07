Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CEE16B35
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEGTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:21:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfEGTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:21:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2840B14B76657;
        Tue,  7 May 2019 12:21:06 -0700 (PDT)
Date:   Tue, 07 May 2019 12:21:05 -0700 (PDT)
Message-Id: <20190507.122105.254019469250484569.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com
Subject: Re: [PATCH] net: dsa: sja1105: Fix status initialization in
 sja1105_get_ethtool_stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190506202447.30907-1-natechancellor@gmail.com>
References: <20190506202447.30907-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:21:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon,  6 May 2019 13:24:47 -0700

> Clang warns:
> 
> drivers/net/dsa/sja1105/sja1105_ethtool.c:316:39: warning: suggest
> braces around initialization of subobject [-Wmissing-braces]
>         struct sja1105_port_status status = {0};
>                                              ^
>                                              {}
> 1 warning generated.
> 
> One way to fix these warnings is to add additional braces like Clang
> suggests; however, there has been a bit of push back from some
> maintainers[1][2], who just prefer memset as it is unambiguous, doesn't
> depend on a particular compiler version[3], and properly initializes all
> subobjects. Do that here so there are no more warnings.
> 
> [1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
> [2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/
> [3]: https://lore.kernel.org/lkml/20181116150432.2408a075@redhat.com/
> 
> Fixes: 52c34e6e125c ("net: dsa: sja1105: Add support for ethtool port counters")
> Link: https://github.com/ClangBuiltLinux/linux/issues/471
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to net-next.
