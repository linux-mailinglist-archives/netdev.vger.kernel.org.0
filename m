Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19C194FA1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgC0DVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:21:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:21:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7B2315CE761E;
        Thu, 26 Mar 2020 20:21:10 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:21:08 -0700 (PDT)
Message-Id: <20200326.202108.1067673336802728242.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH] net: ks8851-ml: Fix IO operations, again
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325142547.45393-1-marex@denx.de>
References: <20200325142547.45393-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:21:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 25 Mar 2020 15:25:47 +0100

> This patch reverts 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
> and edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access"), because it
> turns out these were only necessary due to buggy hardware. This patch adds
> a check for such a buggy hardware to prevent any such mistakes again.
> 
> While working further on the KS8851 driver, it came to light that the
> KS8851-16MLL is capable of switching bus endianness by a hardware strap,
> EESK pin. If this strap is incorrect, the IO accesses require such endian
> swapping as is being reverted by this patch. Such swapping also impacts
> the performance significantly.
> 
> Hence, in addition to removing it, detect that the hardware is broken,
> report to user, and fail to bind with such hardware.
> 
> Fixes: 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
> Fixes: edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access")
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied, thanks.
