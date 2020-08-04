Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05FB23B207
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgHDBAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:00:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35DDC06174A;
        Mon,  3 Aug 2020 18:00:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91BBD12787B36;
        Mon,  3 Aug 2020 17:43:14 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:59:59 -0700 (PDT)
Message-Id: <20200803.175959.2039460326230906074.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: fix failed to suspend if phy
 based WOL is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803165647.296e6f21@xhacker.debian>
References: <20200803165647.296e6f21@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:43:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 3 Aug 2020 16:56:47 +0800

> With the latest net-next tree, if test suspend/resume after enabling
> WOL, we get error as below:
> 
> [  487.086365] dpm_run_callback(): mdio_bus_suspend+0x0/0x30 returns -16
> [  487.086375] PM: Device stmmac-0:00 failed to suspend: error -16
> 
> -16 means -EBUSY, this is because I didn't enable wakeup of the correct
> device when implementing phy based WOL feature. To be honest, I caught
> the issue when implementing phy based WOL and then fix it locally, but
> forgot to amend the phy based wol patch. Today, I found the issue by
> testing net-next tree.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied.
