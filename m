Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC14D5A9E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbiCKFbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiCKFbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE56556751;
        Thu, 10 Mar 2022 21:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FDF3B82AB3;
        Fri, 11 Mar 2022 05:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16FE2C340F3;
        Fri, 11 Mar 2022 05:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646976612;
        bh=RcqDtALLGxdmrbchksn1HFBbTllaw95cHQs1ts9zh/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qjks4RyQ+PcQrE2gI3SeiLZv3Ga/cNNCuOUOZtv/D1A4So+8fXoCvRM6QenxQZSGI
         /GR1zEPm4Py6C7V5PfHN6dHlN8lIGHxOHX1wenE+TDBssQ8x3jYi/+V//ZYj2/eVvD
         vC24fSxlWD5tu15qTOIWfZH9mNZY4/GzPAu0dPVgqgt7Xb3Tozae2n6gsldfaUOcKD
         bpbthOYqGkNGFafXGsONXeKkWLrGFR0hyrFce7sAtn7pCy2LIhgr7KlygdwGAeP67Y
         D03IP9dcjQ8NWRlpUJEuXzJs9DYZaCVz2C/rPuABWnMkQETt9OpKH8l/6FwfuJn2H+
         nKweuNh9FFMJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC75CF0383D;
        Fri, 11 Mar 2022 05:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: ipa: use bulk interconnect interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697661196.11433.11538477901718168814.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 05:30:11 +0000
References: <20220309192037.667879-1-elder@linaro.org>
In-Reply-To: <20220309192037.667879-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, djakov@kernel.org,
        bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 13:20:30 -0600 you wrote:
> The IPA code currently enables and disables interconnects by setting
> the bandwidth of each to a non-zero value, or to zero.  The
> interconnect API now supports enable/disable functions, so we can
> use those instead.  In addition, the interconnect API provides bulk
> interfaces that allow all interconnects to be operated on at once.
> 
> This series converts the IPA driver to use the bulk enable and
> disable interfaces.  In the process it uses some existing data
> structures rather than defining new ones.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: ipa: kill struct ipa_interconnect
    https://git.kernel.org/netdev/net-next/c/c7be12fa2fcc
  - [net-next,v2,2/7] net: ipa: use icc_enable() and icc_disable()
    https://git.kernel.org/netdev/net-next/c/9dd50068916c
  - [net-next,v2,3/7] net: ipa: use interconnect bulk enable/disable operations
    (no matching commit)
  - [net-next,v2,4/7] net: ipa: use bulk operations to set up interconnects
    (no matching commit)
  - [net-next,v2,5/7] net: ipa: use bulk interconnect initialization
    https://git.kernel.org/netdev/net-next/c/63ac8cce5063
  - [net-next,v2,6/7] net: ipa: embed interconnect array in the power structure
    https://git.kernel.org/netdev/net-next/c/8ee7ec4890e2
  - [net-next,v2,7/7] net: ipa: use IPA power device pointer
    https://git.kernel.org/netdev/net-next/c/37e0cf33f8a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


