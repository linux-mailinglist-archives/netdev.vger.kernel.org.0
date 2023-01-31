Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EFF682F44
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjAaOaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaOaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1242D56;
        Tue, 31 Jan 2023 06:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1523C61536;
        Tue, 31 Jan 2023 14:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6686CC4339B;
        Tue, 31 Jan 2023 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675175419;
        bh=5DaGG6lT1lqPnAqPS4uf2XtQ8opsJH69tCDjxSQBmPo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aVThuKkFz5ls1VqepBYiAYjklUZUlZIsoSYxY17wTcOztBYvF7riwsEEcFsxrWRiH
         bvlpnZfhDcIor+Q7ZeI2eI25NXsOwIJYcfP7Z46+6spm3OKLDhaSNPjTzRt+0gkN98
         oL6YINj9aMkWbCaqG6usrW+vWdSOhmdjzaVHtVohbiOFdOvCDOmvRnN+GEJhzRHv7R
         puepP998pKqTn8OdHKi3s/61iNz6H/tuSz+2wQmeVmMgDQhH7ysfFSDcEQjJTV0oc3
         LfQS4LK+0GE06l1yOgXlUQh8EemNNf4s/iJ/pysMS3nRZ2q/4K5sDT+D8lfGBmsXno
         JuGgiWtEbr6gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A206C072E7;
        Tue, 31 Jan 2023 14:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: use dev PM wakeirq handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167517541923.29397.15760908384343459509.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 14:30:19 +0000
References: <20230127202758.2913612-1-caleb.connolly@linaro.org>
In-Reply-To: <20230127202758.2913612-1-caleb.connolly@linaro.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     elder@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        phone-devel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 27 Jan 2023 20:27:58 +0000 you wrote:
> Replace the enable_irq_wake() call with one to dev_pm_set_wake_irq()
> instead. This will let the dev PM framework automatically manage the
> the wakeup capability of the ipa IRQ and ensure that userspace requests
> to enable/disable wakeup for the IPA via sysfs are respected.
> 
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: use dev PM wakeirq handling
    https://git.kernel.org/netdev/net-next/c/df54fde451db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


