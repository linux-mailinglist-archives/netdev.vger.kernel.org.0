Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1966763B7BB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiK2CU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiK2CUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734002AC41;
        Mon, 28 Nov 2022 18:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CAF3ECE1101;
        Tue, 29 Nov 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E251AC433C1;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688416;
        bh=qU2HAdIBp1RNSg6k66TWPvOns5ZMd1BL2C32mV03S0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hFX2Qe6Q2emBV2dZxDng6Ev87QCmteAZjDJF3Gy9s1GUtyipfCshjauOS5MIFBhHS
         MAcL/jDuTjKYqKCGW/IF3phSBaf/XA1z4r9H3gbsI9nzMxgPZUs1UsF/15s0xX++NH
         +74VRaOW0tHBbwz93jtGXzYwFF8Ry/ekeqFNb4JVgSuD+2zhQSXrMJlPypsEbSP8EW
         SetHpdw1KuQ8Q7xHvC0BPBkWew8HWfJcPlj1bOIDKav1j8v4JuoZ3f4uBw9KwT045w
         34EPmNPI5UDcONTWu47GfbLQ/W3OT2flMvRYXulNYFvNSQT5nEDBvjP7FKznEAtWKz
         g9m7U8o9BS/yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3E76E270E5;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-11-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841679.21086.11845330339302265238.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <20221128113513.6F459C433C1@smtp.kernel.org>
In-Reply-To: <20221128113513.6F459C433C1@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Nov 2022 11:35:13 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-11-28
    https://git.kernel.org/netdev/net/c/02f248ead36a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


