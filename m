Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36D56E667C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDROAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDROAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F8112C95;
        Tue, 18 Apr 2023 07:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A05AC62D94;
        Tue, 18 Apr 2023 14:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F20BAC4339B;
        Tue, 18 Apr 2023 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681826420;
        bh=qbushEK5etw3/3kOKAVkU+W7ur9k+Xc4f2jer3lILyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQ2Wa8rTASB4qQiExKEZQsqyUF4r/rFmCYi3x3DxkqpGNhW90rWY6dpr4fHPk/BnA
         9dEcinwHHSutxeC2I2X0We99YETwM4TEy7vWpzQhu8Bf/q70vtm1yIikQksHFzLE2X
         o86Jt7Rq4uFi6gqRKsf0mrXjQVFrMiOSMyXqted9vyNEB5KFjXo6dERZ7Z+xUAvU7h
         X1e0KUQoyOd/rufTGr0Rtc/s9fQCRu/ZWBQI8ietBv5ykf7ka8nYUMDpCb3TZ3dH+p
         59mWSm5NHg4z8C/J1KV97vKl5zMyzdcdEF+lsaRMpDVvfXFKaUOZusi2d745JNDACk
         S72GPVYasaS4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE32DC4167B;
        Tue, 18 Apr 2023 14:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168182641983.28782.4983539968086574822.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 14:00:19 +0000
References: <20230417120718.52325-1-n.zhandarovich@fintech.ru>
In-Reply-To: <20230417120718.52325-1-n.zhandarovich@fintech.ru>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     mlxsw@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        n.petrova@fintech.ru
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 17 Apr 2023 05:07:18 -0700 you wrote:
> Function mlxfw_mfa2_tlv_multi_get() returns NULL if 'tlv' in
> question does not pass checks in mlxfw_mfa2_tlv_payload_get(). This
> behaviour may lead to NULL pointer dereference in 'multi->total_len'.
> Fix this issue by testing mlxfw_mfa2_tlv_multi_get()'s return value
> against NULL.
> 
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
> 
> [...]

Here is the summary with links:
  - [net] mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
    https://git.kernel.org/netdev/net/c/c0e73276f0fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


