Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9465F375DC8
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhEGAEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhEGAEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB4B61164;
        Fri,  7 May 2021 00:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620345795;
        bh=klDMRqokTg+h/bqjn9imiAwra7tOjQNpWkNNe27VZH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WOIK2D1Evh+HsXabY8ZBK75sFOjnMbYqSllhxw5AYvC88v8jy1kGPnVyzoNCA8S/A
         R1p0+Za5dhO1x2wTEZnKXZqvbVGcYEGNQTr0u9uJ8K4+HbpfHahXnFS8Z2vnGj12M5
         0aWmC6+u/49nJ3SdFZtdq/esw4EQ1AC78c0Pk4afpA05WBR7nNs1KwqYy8FTll01Vr
         7xaqSbpPbH/i05iEevH1GKlwguEBuEdQ9qEzU6iheYrOyzYH1exqDUVPaRJTYtuhbT
         jDvhxmnugpSM/15bAikn0FGwXwRksAtmezCfDDcI0Jpdepy9gql2S0MEzM4mukfRfz
         q1pgIXhcb+DHw==
Date:   Thu, 6 May 2021 17:03:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: fix inter-EE IRQ register definitions
Message-ID: <20210506170314.64112387@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210505223636.232527-1-elder@linaro.org>
References: <20210505223636.232527-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 May 2021 17:36:36 -0500 Alex Elder wrote:
> In gsi_irq_setup(), two registers are written with the intention of
> disabling inter-EE channel and event IRQs.
> 
> But the wrong registers are used (and defined); the ones used are
> read-only registers that indicate whether the interrupt condition is
> present.
> 
> Define the mask registers instead of the status registers, and use
> them to disable the inter-EE interrupt types.
> 
> Fixes: 46f748ccaf01 ("net: ipa: explicitly disallow inter-EE interrupts")
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks!
