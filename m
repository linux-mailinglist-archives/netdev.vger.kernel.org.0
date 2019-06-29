Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1A5AD0F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfF2TaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:30:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfF2TaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:30:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62ABB14C7E611;
        Sat, 29 Jun 2019 12:30:02 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:30:01 -0700 (PDT)
Message-Id: <20190629.123001.296081057661926646.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: consider that 32 Bit DMA is the default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eabad258-68de-49b9-91d7-7c853ea4f150@gmail.com>
References: <eabad258-68de-49b9-91d7-7c853ea4f150@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:30:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 27 Jun 2019 23:12:39 +0200

> Documentation/DMA-API-HOWTO.txt states:
> By default, the kernel assumes that your device can address 32-bits of
> DMA addressing. For a 64-bit capable device, this needs to be increased,
> and for a device with limitations, it needs to be decreased.
> 
> Therefore we don't need the 32 Bit DMA fallback configuration and can
> remove it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
