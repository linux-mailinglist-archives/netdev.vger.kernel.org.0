Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E79E77C14
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfG0Vb1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 27 Jul 2019 17:31:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0Vb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:31:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F12A91534FD5D;
        Sat, 27 Jul 2019 14:31:24 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:31:24 -0700 (PDT)
Message-Id: <20190727.143124.554560279316200864.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        dragic.dusan@gmail.com
Subject: Re: [PATCH net] r8169: don't use MSI before RTL8168d
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c9f89cfc-ec16-62dc-a975-1b614941e723@gmail.com>
References: <c9f89cfc-ec16-62dc-a975-1b614941e723@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:31:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 27 Jul 2019 12:43:31 +0200

> It was reported that after resuming from suspend network fails with
> error "do_IRQ: 3.38 No irq handler for vector", see [0]. Enabling WoL
> can work around the issue, but the only actual fix is to disable MSI.
> So let's mimic the behavior of the vendor driver and disable MSI on
> all chip versions before RTL8168d.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204079
> 
> Fixes: 6c6aa15fdea5 ("r8169: improve interrupt handling")
> Reported-by: Du¹an Dragiæ <dragic.dusan@gmail.com>
> Tested-by: Du¹an Dragiæ <dragic.dusan@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> This version of the fix applies from 5.3 only. I'll submit a separate
> version for previous kernel versions.

Applied and queued up for -stable, thanks for the backport.
