Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95745A0406
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiHXWaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiHXWaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342F0BC93;
        Wed, 24 Aug 2022 15:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C68606196E;
        Wed, 24 Aug 2022 22:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D730C43470;
        Wed, 24 Aug 2022 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661380217;
        bh=VfX9eQMZ1OK+AhjA11hr6pTWCMVNB6NuAsflTkH6aSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OPVPLFH+4dQw1k2RQhkfNg71nn205IxFzn4QLPLz/0rieu2Lnv4bpDui844XK5Ipy
         pBYS+jEzeDY7M8qpVJq5ReqQPeOyiwlevsRlp6aYI6lhlbqD3qVFhLVshylPtyH43u
         Fmzng4YvD9qdZpQclGeHNsUj9j8BeX8XBpAqzeb5/Tljp0LP7FX+PWZ4Cf+EEX5EzC
         Y3+/OJTtKRxG2ovA3HBn1iCkAFHbja56kA2qV3qXEcqzaK+1N5IIAD1LrvrZph7BQj
         8QWC+hkmUMOx4kOE1IXhdGDMWA7PkVq4LAVRLBjNfyG3+MOxRhct+8KI2iWbCgPFqK
         3V+uylZYtFP3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 029CDC0C3EC;
        Wed, 24 Aug 2022 22:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v3 0/1] Bluetooth: hci_sync: hold hdev->lock when
 cleanup hci_conn
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166138021700.13438.5071641895623832276.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 22:30:17 +0000
References: <20220823172808.3477638-1-jiangzp@google.com>
In-Reply-To: <20220823172808.3477638-1-jiangzp@google.com>
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue, 23 Aug 2022 10:28:07 -0700 you wrote:
> Hold hdev->lock for hci_conn_failed. There are possible race conditions
> which may cause kernel crash.
> 
> Changes in v3:
> - Remove an empty line in commit message between Fixes and SoB
> 
> Changes in v2:
> - Update commit message
> 
> [...]

Here is the summary with links:
  - [kernel,v3,1/1] Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn
    https://git.kernel.org/bluetooth/bluetooth-next/c/808765508e8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


