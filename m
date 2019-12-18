Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD58B125302
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLRUR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:17:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfLRUR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:17:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8CFE153CC127;
        Wed, 18 Dec 2019 12:17:25 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:17:25 -0800 (PST)
Message-Id: <20191218.121725.838258577232002957.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        andre.guedes@linux.intel.com, Richard.Ong@synopsys.com,
        boon.leong.ong@intel.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] net: stmmac: TSN support using TAPRIO API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:17:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed, 18 Dec 2019 11:33:04 +0100

> This series adds TSN support (EST and Frame Preemption) for stmmac driver.
> 
> 1) Adds the HW specific support for EST in GMAC5+ cores.
> 
> 2) Adds the HW specific support for EST in XGMAC3+ cores.
> 
> 3) Integrates EST HW specific support with TAPRIO scheduler API.
> 
> 4) Adds the Frame Preemption suppor on stmmac TAPRIO implementation.
> 
> 5) Adds the HW specific support for Frame Preemption in GMAC5+ cores.
> 
> 6) Adds the HW specific support for Frame Preemption in XGMAC3+ cores.
> 
> 7) Adds support for HW debug counters for Frame Preemption available in
> GMAC5+ cores.

Series applied, thanks.
