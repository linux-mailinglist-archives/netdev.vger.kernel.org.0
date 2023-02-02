Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21A6886DC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjBBSll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjBBSlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:41:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B81367FB;
        Thu,  2 Feb 2023 10:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5920B82790;
        Thu,  2 Feb 2023 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50F1FC4339B;
        Thu,  2 Feb 2023 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675363218;
        bh=ELgMXWg98RKcRAsg6NjJwIh7JYmfAPa26CQVEEj1Tos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cYI+8t6p9uPjnig6rixsO1zaokOd83pUxq5XVMl/4Yw6jkVcbrVkPpP3pZNphehDZ
         Hy3C9heMVu6RZGGgc2cvHIBMfRsU/I/kwZubZtqagn7gVbu0i+LK3KrZsOH+dUFT6s
         CM9o1vKybSE3Yl4dmOq+0nooP/cOfY67SyvCHTjmHEqKzsVqOGzTN0Blgk4utT79po
         vuc8o/bQeutD03OMiCFhJniAdSRP3q6FnoX0T0r/mbYZni0IWY76NMyhPIj3NmpYqK
         hAUTIs4Gm6td9pcqssg4DBNzQmTKfVrUTWdb1PE+oxkm4VRpnub4nl/1AdwLKK2XPI
         k8M4U2VgtW+ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30502E270CC;
        Thu,  2 Feb 2023 18:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] virtio-net: close() to follow mirror of open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536321819.25597.17702900987965730906.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 18:40:18 +0000
References: <20230202050038.3187-1-parav@nvidia.com>
In-Reply-To: <20230202050038.3187-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, virtualization@lists.linux-foundation.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 07:00:36 +0200 you wrote:
> Hi,
> 
> This two small patches improves ndo_close() callback to follow
> the mirror sequence of ndo_open() callback. This improves the code auditing
> and also ensure that xdp rxq info is not unregistered while NAPI on
> RXQ is ongoing.
> 
> [...]

Here is the summary with links:
  - [1/2] virtio-net: Keep stop() to follow mirror sequence of open()
    https://git.kernel.org/netdev/net/c/63b114042d8a
  - [2/2] virtio-net: Maintain reverse cleanup order
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


