Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C582CCB94
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgLCBUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729117AbgLCBUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:20:07 -0500
Date:   Wed, 2 Dec 2020 17:19:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606958367;
        bh=g9UqTCKMAE+4Mth9TzYqV3MjWxvjincRfBqFd17xgdc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kXbDg6diCVj06eMpyZMG7FRPS7DX1Rsu449Woq4veS7CRC5oUGU/dzufF+96gzgbz
         eGhimf6tAK8yvZAEjUJNHbcuZVFOvIw/Fiecqei73IPokmYr+EggyXTGz4Qa/fthel
         4pqfIMsm8Aa8SsorTo1XeGXmWzZ580nylZdaxNN3OmfzK/8Fq/OwsXW32sa7re57wN
         evMCwDpcq4ZzhY+q3NBk6EEV4oCRIMQU3aLGwNODonehfXUR9gpVdIdqeiwSyGjBk5
         bZu9+lEMicl+d2o5vRrAQz5SWm0aewEyrByOs4b2/JISkGky0NyTNUUKrcBJNkTyoM
         BYNESHLbBNljQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, jonathanh@nvidia.com, evgreen@chromium.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: ipa: fix build-time bug in
 ipa_hardware_config_qsb()
Message-ID: <20201202171925.74e546f4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202141502.21265-1-elder@linaro.org>
References: <20201202141502.21265-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 08:15:02 -0600 Alex Elder wrote:
> Jon Hunter reported observing a build bug in the IPA driver:
>   https://lore.kernel.org/netdev/5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com
> 
> The problem is that the QMB0 max read value set for IPA v4.5 (16) is
> too large to fit in the 4-bit field.
> 
> The actual value we want is 0, which requests that the hardware use
> the maximum it is capable of.
> 
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks!
