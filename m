Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71216B8632
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCMXkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCMXkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EE637B64
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC82C6155B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DD9CC4339C;
        Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678750817;
        bh=k5pBF35sRez4Hl4aTCSHcO4mJh2/8hHKVc2NDkAP1Qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WyupZ93+5jFXM6eWIZ3AEt2YVfdBoJudQ+xirDALl6TS87q6BDZgNlY8yh5IG+NOr
         mY8mx9OFl2qWO0Cdp5UNnh4/arqqqB8ayqJBoaS3QeC+4SUO+grCETEQ4apRzLKRYF
         9XDG+haktHaaAPvO4plp6jmpsFIGOP/UiWuW5vVl8shCl/vbY+RLQo2O7fQa/dWyge
         McIxMCsS8GVSOol5LZNP98ZHiGUHV3AeKqx1gVAVKITPJNyaF/leMqya+qT2boZGHy
         2+lQ7n1lDn5Xi2dnKp5nqPBxd+8mRzrQ1J0b2viZM7uOXsxqI8qrMGxBP0TfDL7Iu7
         Jn2A6Ej9DTvoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12B73E66CBA;
        Mon, 13 Mar 2023 23:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v4] net: virtio_net: implement exact header length
 guest feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875081707.805.3103507191254448276.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:40:17 +0000
References: <20230309094559.917857-1-jiri@resnulli.us>
In-Reply-To: <20230309094559.917857-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com,
        willemdebruijn.kernel@gmail.com
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

On Thu,  9 Mar 2023 10:45:59 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that device benefits from knowing the exact size
> of the header. For compatibility, to signal to the device that
> the header is reliable driver also needs to set this feature.
> Without this feature set by driver, device has to figure
> out the header size itself.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] net: virtio_net: implement exact header length guest feature
    https://git.kernel.org/netdev/net-next/c/be50da3e9d4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


