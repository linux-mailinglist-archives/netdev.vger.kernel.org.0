Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA03351D7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFDVZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:25:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:25:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F7F61500FF39;
        Tue,  4 Jun 2019 14:25:35 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:25:34 -0700 (PDT)
Message-Id: <20190604.142534.1883466423005092248.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: mscc: ocelot: Fix some struct initializations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603204953.44235-1-natechancellor@gmail.com>
References: <20190603204953.44235-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:25:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon,  3 Jun 2019 13:49:53 -0700

> Clang warns:
> 
> drivers/net/ethernet/mscc/ocelot_ace.c:335:37: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct ocelot_vcap_u64 payload = { 0 };
>                                            ^
>                                            {}
> drivers/net/ethernet/mscc/ocelot_ace.c:336:28: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct vcap_data data = { 0 };
>                                   ^
>                                   {}
> drivers/net/ethernet/mscc/ocelot_ace.c:683:37: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct ocelot_ace_rule del_ace = { 0 };
>                                            ^
>                                            {}
> drivers/net/ethernet/mscc/ocelot_ace.c:743:28: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct vcap_data data = { 0 };
>                                   ^
>                                   {}
> 4 warnings generated.
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
> Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
> Link: https://github.com/ClangBuiltLinux/linux/issues/505
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to net-next.
