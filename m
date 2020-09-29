Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEC327D9D9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgI2VWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgI2VWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:22:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BF2C061755;
        Tue, 29 Sep 2020 14:22:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14C3911E48E20;
        Tue, 29 Sep 2020 14:05:14 -0700 (PDT)
Date:   Tue, 29 Sep 2020 14:22:00 -0700 (PDT)
Message-Id: <20200929.142200.67101764735438804.davem@davemloft.net>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        paulmck@kernel.org, willy@infradead.org, benve@cisco.com,
        _govind@gmx.com, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, mchehab+huawei@kernel.org,
        linux-doc@vger.kernel.org, bigeasy@linutronix.de,
        luc.vanoostenryck@gmail.com, jcliburn@gmail.com,
        chris.snook@gmail.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        snelson@pensando.io, drivers@pensando.io, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        tsbogend@alpha.franken.de, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com, jdmason@kudzu.us,
        dsd@gentoo.org, kune@deine-taler.de, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, stas.yakovlev@gmail.com,
        stf_xl@wp.pl, johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com, j@w1.fi,
        amitkarwar@gmail.com
Subject: Re: [patch V2 00/36] net: in_interrupt() cleanup and fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929202509.673358734@linutronix.de>
References: <20200929202509.673358734@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 14:05:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 Sep 2020 22:25:09 +0200

> in the discussion about preempt count consistency accross kernel configurations:
> 
>   https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> Linus clearly requested that code in drivers and libraries which changes
> behaviour based on execution context should either be split up so that
> e.g. task context invocations and BH invocations have different interfaces
> or if that's not possible the context information has to be provided by the
> caller which knows in which context it is executing.
> 
> This includes conditional locking, allocation mode (GFP_*) decisions and
> avoidance of code paths which might sleep.
> 
> In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
> driver code completely.
> 
> This is the second version of the first batch of related changes. V1 can be
> found here:
> 
>      https://lore.kernel.org/r/20200927194846.045411263@linutronix.de
 ...

Series applied to net-next, thanks.
