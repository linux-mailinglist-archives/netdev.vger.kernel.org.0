Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBC6A4C05
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjB0UKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjB0UKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E688126DA
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D13560F27
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68468C433D2;
        Mon, 27 Feb 2023 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677528617;
        bh=YkoCJfE5v48fVHCNX+59FN6slTIBxcJELvSfpuyOV/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QpaJPcr5dgiZBq2XANITT5HnqGP7SND+Aryi1sq96/06LiOz/VPGa7JzWiyeyK4ry
         9YKW2Pk9ru3KuVr/rCSrsZn6WSgupxMGpiMHMDDdjjIolqYgJwWzCTcra/qSXsP5RZ
         riWMwt/dMHdrrUaEr1i4og/0evpF8jHspVNsuopT2d8y4lM2e++pCgWlNPZbepEHu7
         fvvtDmEuantJI+a8ZbApk2RDgFkm+w5oTchztNRTjSMKFAog6hPobNCs2rSS92jyQr
         4e7p6JXHyIkPXxTsbmpqvYNLfhR7rLHLoj9q7hZmW7Q0DV47iLl2AY3UxrzQwZiVxE
         85m46kOuG4L4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5636CE1CF31;
        Mon, 27 Feb 2023 20:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: tcp_check_req() can be called from process context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167752861734.30060.6506071234849210691.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Feb 2023 20:10:17 +0000
References: <20230227083336.4153089-1-edumazet@google.com>
In-Reply-To: <20230227083336.4153089-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, fred@cloudflare.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Feb 2023 08:33:36 +0000 you wrote:
> This is a follow up of commit 0a375c822497 ("tcp: tcp_rtx_synack()
> can be called from process context").
> 
> Frederick Lawler reported another "__this_cpu_add() in preemptible"
> warning caused by the same reason.
> 
> In my former patch I took care of tcp_rtx_synack()
> but forgot that tcp_check_req() also contained some SNMP updates.
> 
> [...]

Here is the summary with links:
  - [net] tcp: tcp_check_req() can be called from process context
    https://git.kernel.org/netdev/net/c/580f98cc33a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


