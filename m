Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF8535E8D5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348605AbhDMWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345154AbhDMWKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E57C46135C;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351811;
        bh=u2WGsaI7HSrl3UlC9alGdJt7IjYDGWxPdZjzLmNm5lk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NCr/qfK46rxP2xuFHSaj4NgWyk4mheoqWqEX3BIw0mKGCED5oEBhjyRHerxxtIh+C
         ElAl6ch9qdOsp7Fm8UorbRDQUxwczLrkOZw4tns1cjr8RlNuI57JnHn1LdIDRfebdi
         naHSJMcmJnynKV1xz3yiFjXEtcB/9U8FlzKzR+KWEWkFqsm51dRVpq6K50evSGmob6
         6qlkNVFEXXI5VOa8Rrx3euyrNWS8EvguBA6PSXd/1dSev3b7vpgHnXqhcPombkpD1D
         Np7ByfHIE1whgaQLqTZK5dVAJEPfY1yRPYUQzNwFXwT0fl6ObgKuRaKoyWYTAapn0v
         HaVPP0uXKczeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8C0D60BD8;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: add support for the SM8350 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835181088.31494.2378952390871808403.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:10:10 +0000
References: <20210413163826.1770386-1-elder@linaro.org>
In-Reply-To: <20210413163826.1770386-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 11:38:24 -0500 you wrote:
> This small series adds IPA driver support for the Qualcomm SM8350
> SoC, which implements IPA v4.9.
> 
> The first patch updates the DT binding, and depends on a previous
> patch that has already been accepted into net-next.
> 
> The second just defines the IPA v4.9 configuration data file.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: qcom,ipa: add support for SM8350
    https://git.kernel.org/netdev/net-next/c/15c88e185eb9
  - [net-next,2/2] net: ipa: add IPA v4.9 configuration data
    https://git.kernel.org/netdev/net-next/c/e557dc82418d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


