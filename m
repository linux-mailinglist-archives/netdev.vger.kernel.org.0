Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635174AFD3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 04:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFSCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 22:03:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSCDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 22:03:16 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8661B14D8457B;
        Tue, 18 Jun 2019 19:02:58 -0700 (PDT)
Date:   Tue, 18 Jun 2019 22:02:51 -0400 (EDT)
Message-Id: <20190618.220251.295948387700018458.davem@davemloft.net>
To:     yash.shah@sifive.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, paul.walmsley@sifive.com, ynezz@true.cz,
        sachin.ghadi@sifive.com
Subject: Re: [PATCH v3 0/2] Add macb support for SiFive FU540-C000
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
References: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 19:03:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yash Shah <yash.shah@sifive.com>
Date: Tue, 18 Jun 2019 13:26:06 +0530

> On FU540, the management IP block is tightly coupled with the Cadence
> MACB IP block. It manages many of the boundary signals from the MACB IP
> This patchset controls the tx_clk input signal to the MACB IP. It
> switches between the local TX clock (125MHz) and PHY TX clocks. This
> is necessary to toggle between 1Gb and 100/10Mb speeds.
> 
> Future patches may add support for monitoring or controlling other IP
> boundary signals.
> 
> This patchset is mostly based on work done by
> Wesley Terpstra <wesley@sifive.com>
> 
> This patchset is based on Linux v5.2-rc1 and tested on HiFive Unleashed
> board with additional board related patches needed for testing can be
> found at dev/yashs/ethernet_v3 branch of:
> https://github.com/yashshah7/riscv-linux.git
> 
> Change History:
 ...

Series applied, thank you.
