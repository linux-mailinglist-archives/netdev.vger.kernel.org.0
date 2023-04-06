Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579276D8C08
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjDFAk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjDFAkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210BB6A41;
        Wed,  5 Apr 2023 17:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B49C562C3B;
        Thu,  6 Apr 2023 00:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29D99C4339B;
        Thu,  6 Apr 2023 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680741621;
        bh=pE6FGg408nNIvbYKPpOo+ehMAuEdbMRHafgacoD9EWI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q0jxM7cWNAZwJxgomPu2kMpbxi9D3RGzsAqXREhVgi7QJq3kfSgAzXXmq5fUEoPjw
         ialAobY5Hgwx3NVPjCiu9Cncpon4M6ym4BKxx3E9EL/Mp2C9vUHhK5B/4NRiW0JGHz
         Kl37tOHyFhBo2L91H7fxhxsDCIqxqiB3LrrG5egAKy/IKUW68CtENBXfQ6a/n7uTjI
         9ZAP/+ss/pzKrRbSjpSTPc/YLcFIRgdliulpnwIXXD5UNbBTc+WV2wVTfC+hNhtg+N
         x+yF2g44x/P7UjZIFwridYbi9NVPGi+TvderLltjlva0Sn0tSTwmiKFmDbO+4M6/Vd
         W8OCMqp8YterQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1722CC4167B;
        Thu,  6 Apr 2023 00:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-04-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074162109.7173.7606066704308184808.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 00:40:21 +0000
References: <20230405111037.4792BC43443@smtp.kernel.org>
In-Reply-To: <20230405111037.4792BC43443@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Apr 2023 11:10:37 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-04-05
    https://git.kernel.org/netdev/net-next/c/acd11255ca46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


