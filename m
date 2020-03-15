Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838BF1859F2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgCOEAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:00:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgCOEAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:00:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A700E15AD855B;
        Sat, 14 Mar 2020 21:00:53 -0700 (PDT)
Date:   Sat, 14 Mar 2020 21:00:52 -0700 (PDT)
Message-Id: <20200314.210052.2035605917214699487.davem@davemloft.net>
To:     mklntf@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: platform: Fix misleading interrupt error
 msg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312194625.GA6684@DEFRL0001.localdomain>
References: <20200306163848.5910-1-mklntf@gmail.com>
        <20200311.230402.1496009558967017193.davem@davemloft.net>
        <20200312194625.GA6684@DEFRL0001.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 21:00:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Fuchs <mklntf@gmail.com>
Date: Thu, 12 Mar 2020 20:46:25 +0100

> On Wed, Mar 11, 2020 at 11:04:02PM -0700, David Miller wrote:
>> From: Markus Fuchs <mklntf@gmail.com>
>> Date: Fri,  6 Mar 2020 17:38:48 +0100
>> 
>> > Not every stmmac based platform makes use of the eth_wake_irq or eth_lpi
>> > interrupts. Use the platform_get_irq_byname_optional variant for these
>> > interrupts, so no error message is displayed, if they can't be found.
>> > Rather print an information to hint something might be wrong to assist
>> > debugging on platforms which use these interrupts.
>> > 
>> > Signed-off-by: Markus Fuchs <mklntf@gmail.com>
>> 
>> What do you mean the error message is misleading right now?
>> 
>> It isn't printing anything out at the moment in this situation.
> 
> Commit 7723f4c5ecdb driver core: platform: Add an error message to 
>     platform_get_irq*()
> 
> The above commit added a generic dev_err() output to the platform_get_irq_byname
> function.
> 
> My patch uses the platform_get_irq_byname_optional function, which
> doesn't print anything and adds the original dev_err output as dev_info output 
> to the driver.
> Otherwise there would be no output at all even for platforms in need of these 
> irqs.

Aha, now I get it, thanks for explaining.

Applied, thank you.
