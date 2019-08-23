Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802989B872
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394058AbfHWWMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 18:12:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390281AbfHWWMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 18:12:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 537EE1543C8D3;
        Fri, 23 Aug 2019 15:12:35 -0700 (PDT)
Date:   Fri, 23 Aug 2019 15:12:34 -0700 (PDT)
Message-Id: <20190823.151234.60135927826509447.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, aaro.koskinen@iki.fi, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: fix DMA issue on MIPS platform
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c732685d-591c-3dca-95b8-1207bdf0d37f@gmail.com>
References: <c732685d-591c-3dca-95b8-1207bdf0d37f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 15:12:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 23 Aug 2019 20:07:26 +0200

> As reported by Aaro this patch causes network problems on
> MIPS Loongson platform. Therefore revert it.
> 
> Fixes: f072218cca5b ("r8169: remove not needed call to dma_sync_single_for_device")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Applied.
