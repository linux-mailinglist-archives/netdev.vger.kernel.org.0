Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3DA1894A7
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCRD5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:57:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCRD5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 23:57:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CFA713EC66AD;
        Tue, 17 Mar 2020 20:57:48 -0700 (PDT)
Date:   Tue, 17 Mar 2020 20:57:47 -0700 (PDT)
Message-Id: <20200317.205747.70318933080998478.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next 0/9] ethtool: consolidate irq coalescing -
 last part
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 20:57:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 16 Mar 2020 13:47:03 -0700

> Convert remaining drivers following the groundwork laid in a recent
> patch set [1] and continued in [2], [3], [4], [5]. The aim of
> the effort is to consolidate irq coalescing parameter validation
> in the core.
> 
> This set is the sixth and last installment. It converts the remaining
> 8 drivers in drivers/net/ethernet. The last patch makes declaring
> supported IRQ coalescing parameters a requirement.
> 
> [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
> [2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
> [3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/
> [4] https://lore.kernel.org/netdev/20200311223302.2171564-1-kuba@kernel.org/
> [5] https://lore.kernel.org/netdev/20200313040803.2367590-1-kuba@kernel.org/

Series applied and build testing, thanks Jakub.
