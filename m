Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31D155591
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGKYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:24:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGKYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:24:36 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C454715A3284C;
        Fri,  7 Feb 2020 02:24:33 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:24:32 +0100 (CET)
Message-Id: <20200207.112432.420753747470150864.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     vkoul@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        niklas.cassel@linaro.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: stmmac: fix a possible endless loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206152917.25564-1-zhengdejin5@gmail.com>
References: <20200206152917.25564-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:24:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Thu,  6 Feb 2020 23:29:17 +0800

> It forgot to reduce the value of the variable retry in a while loop
> in the ethqos_configure() function. It may cause an endless loop and
> without timeout.
> 
> Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> Acked-by: Vinod Koul <vkoul@kernel.org>

Applied and queued up for -stable, thank you.
