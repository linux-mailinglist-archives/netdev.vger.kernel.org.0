Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5490060C7F7
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiJYJY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiJYJYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:24:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAAB13F84
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A1161846
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7964DC433B5;
        Tue, 25 Oct 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666689615;
        bh=hACZiTYZYDyzasP5wFsIpRZ9rdFhnDUQvmfvNfUMEEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cD5C2J3lTb3LBmMjAjzGWol9h9jbj4EgeNEDKgtWDAoxdYNKos0clvUCJZcTuTHgH
         DrWxir5YvrgdmkjmJ1/fF8EnlrygpahhqhwA5P4ZMmZ30gM1c1Bl4K6V9Q0h7sAFvZ
         OMHEUtJYqeMISxQOOylqWkXAjpwiSt3wgikl4D1fH9XhFwcK+g1eoW3Vz5ESj4gYqt
         e9BW+RO+eibNnHw1q8qbyFj3MiJF8V8OvFZIjFpnAcD9PmnPWOu03FwoDJvOO/irW7
         wbWrcUgJ8aez3llBHmf1rhGsxSv0qW2/iR+YbkdSMKmihWmteSFH0T2cT+QnmIKLGy
         eZAYRczEojtww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B841E270DE;
        Tue, 25 Oct 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: stmmac: rk3588: Allow multiple gmac controller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166668961537.26490.4040099605594651458.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 09:20:15 +0000
References: <20221021172422.88534-1-sebastian.reichel@collabora.com>
In-Reply-To: <20221021172422.88534-1-sebastian.reichel@collabora.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        benjamin.gaignard@collabora.com, kernel@collabora.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 21 Oct 2022 19:24:22 +0200 you wrote:
> From: Benjamin Gaignard <benjamin.gaignard@collabora.com>
> 
> RK3588(s) can have multiple gmac controllers.
> Re-use rk3568 logic to distinguish them.
> 
> Fixes: 2f2b60a0ec28 ("net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588")
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> 
> [...]

Here is the summary with links:
  - [1/1] net: stmmac: rk3588: Allow multiple gmac controller
    https://git.kernel.org/netdev/net/c/88619e77b33d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


