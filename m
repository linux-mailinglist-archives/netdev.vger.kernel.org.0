Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4C1859DB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCODvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:51:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCODvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:51:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A12E15B75266;
        Sat, 14 Mar 2020 20:51:30 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:51:30 -0700 (PDT)
Message-Id: <20200314.205130.37193727687899091.davem@davemloft.net>
To:     darell.tan@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: phy: Fix marvell_set_downshift() from clobbering
 MSCR register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAL20LWKM_yX4Dxjt6nxSosr5hTKmOi4eurGy1mCfw6hUUenprg@mail.gmail.com>
References: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
        <20200311.234530.105958086242766446.davem@davemloft.net>
        <CAL20LWKM_yX4Dxjt6nxSosr5hTKmOi4eurGy1mCfw6hUUenprg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:51:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Darell Tan <darell.tan@gmail.com>
Date: Thu, 12 Mar 2020 22:14:08 +0800

> On Thu, Mar 12, 2020 at 2:45 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Darell Tan <darell.tan@gmail.com>
>> Date: Wed, 11 Mar 2020 22:41:38 +0800
>>
>> > Fix marvell_set_downshift() from clobbering MSCR register.
>> >
>> > A typo in marvell_set_downshift() clobbers the MSCR register. This
>> > register also shares settings with the auto MDI-X detection, set by
>> > marvell_set_polarity(). In the 1116R init, downshift is set after
>> > polarity, causing the polarity settings to be clobbered.
>> >
>> > This bug is present on the 5.4 series and was introduced in commit
>> > 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
>> > helper"). This patch need not be forward-ported to 5.5 because the
>> > functions were rewritten.
>> >
>> > Signed-off-by: Darell Tan <darell.tan@gmail.com>
>>
>> I don't see marvell_set_downshift() in 'net' nor 'net-next'.
> 
> This patch applies to the 5.4.x long term series and earlier, but not
> to -stable or -next because the affected functions have already been
> refactored.
> 
> Sorry I'm new to this. Should I be incorporating Andrew's comments and
> sending a v2 to the linux-kernel list instead?

Submit it to stable@vger.kernel.org, include my:

Acked-by: David S. Miller <davem@davemloft.net>

And be sure to CC: me and make it clear that I directed you to do this.

Thank you.
