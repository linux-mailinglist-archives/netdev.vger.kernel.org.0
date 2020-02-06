Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FC4154675
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBFOuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:50:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgBFOub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:50:31 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82EB414E226FC;
        Thu,  6 Feb 2020 06:50:29 -0800 (PST)
Date:   Thu, 06 Feb 2020 15:50:25 +0100 (CET)
Message-Id: <20200206.155025.1955610977652855941.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     vkoul@kernel.org, peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, niklas.cassel@linaro.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: fix a possible endless loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206141811.24862-1-zhengdejin5@gmail.com>
References: <20200206141811.24862-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 06:50:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Thu,  6 Feb 2020 22:18:11 +0800

> It forgot to reduce the value of the variable retry in a while loop
> in the ethqos_configure() function. It may cause an endless loop and
> without timeout.
> 
> Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> Acked-by: Vinod Koul <vkoul@kernel.org>
> ---
> 
> Vinod Koul and David Miller, Thanks for your comments!
> 
> V2:
> add an appropriate Fixes tag.

Please do not put an empty line between Fixes and other tags.

I have no idea why people often do this.

Anyways, Fixes and other tags are all tags and thus belong together as
an uninterrupted group of text.

Thank you.
