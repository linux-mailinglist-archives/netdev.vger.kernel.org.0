Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F072B554B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgKPXkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:40:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgKPXka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:40:30 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605570030;
        bh=0XNrhPqo0+QJ61t3rRAohnzNAiGKU6rh847px8Ec6m0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eKLybMNXuQNHScH9x1ybGstN0Qb2T/GPf/a0bJYlbfkEhBH+DF8VXocusMoMYyyDh
         prbPzO2SpJtJDKH77sPfFkfuXc1AAUUhNn2uxQ8AmJWn44mw7KiLPTHVeZ5UAZfL4t
         lsf4HqcJm8AQhYzcCfUKwQDCA6slsUGZ1ClgwCyc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: dwmac-intel-plat: fix error return code in
 intel_eth_plat_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557002998.13670.13222131921544725216.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 23:40:29 +0000
References: <1605249243-17262-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605249243-17262-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vineetha.g.jaya.kumaran@intel.com,
        rusaimi.amira.rusaimi@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 14:34:03 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: dwmac-intel-plat: fix error return code in intel_eth_plat_probe()
    https://git.kernel.org/netdev/net/c/661710bfd503

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


