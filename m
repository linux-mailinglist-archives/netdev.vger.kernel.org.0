Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398E96BC55A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCPElE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCPElB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:41:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822BF38B6D;
        Wed, 15 Mar 2023 21:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F61DB81FCB;
        Thu, 16 Mar 2023 04:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3DFEC4339E;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941620;
        bh=nnSFNLjrDwwOEyXqTsRCkmngIyJGrCr4WsatfYqKShc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jB/icfRKfNZ+JNJjGSFrowEOXEPXixldBjpSurPYk1eVRLLz2B+r6mOc7CXVbIwOm
         6IP6o73w8IycAVC42NOiGIs4t5YMDezt/lWOxdb6+qaLffOMkpmxC11ucFYtAeTryo
         8hHGaGMKYYar6ozXI4oWnoyhkjkD37WyP2l3pExGDUfEP6BN78Xe4sRPn/OUduvXou
         de454GIm2Gurhytknd3de+obmG0svGeIHP+ghm/Fi5wYKAW7IWDyqImc9lii/OcV3X
         HvtQs/uesTxhGdVGPTfDMiVmNe90Hn1C1LA66QT+80MikBNOv3mOV09SQsq7gbRKbi
         aRxpjLFl3HrxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5412E4D002;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: ines: drop of_match_ptr for ID table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894162067.2389.5818830005628479856.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 04:40:20 +0000
References: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 12 Mar 2023 14:26:37 +0100 you wrote:
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it might not be relevant here).  This
> also fixes !CONFIG_OF error:
> 
>   drivers/ptp/ptp_ines.c:783:34: error: ‘ines_ptp_ctrl_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> [...]

Here is the summary with links:
  - ptp: ines: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/543c143dac5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


