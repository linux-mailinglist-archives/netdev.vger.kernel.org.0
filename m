Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B576CC0E9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjC1NbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjC1NbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B63DCC17;
        Tue, 28 Mar 2023 06:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87428617BB;
        Tue, 28 Mar 2023 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF534C433A7;
        Tue, 28 Mar 2023 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680010218;
        bh=wAOqKXa5k+PpvaTqojjqTGvRwfUjAI5kHX4cGuCo+zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uYFmZ+KCxb84fhWh6BTAOpT75G1dlq265BRyJH9EwV+5fNqyj3t1NNe3aEKjwz49z
         /7k2Zjq5O+zK7A0piXnv5r2oPRwUpKWezf/XSaRx4x/92BArDGtSAcOI/iicezlmjB
         0947QOThA8fpXzkBlpXJdFni1ygDCQIOeY7LmyqK5u1kTBjBvMfy649GCcYY9Yg0za
         1x2jFsD6J+wRbxLqZmxrUs8F1qIwQ5iou6lt4p+XAU6m7ejMvlW3BOtimwKJ5vnihi
         adc6QkoW9kYQnYXxxPHqmcjU+cWtGdwQGsoLrfOcR0tpc1xzGtb+xuNkh4r9p5npHt
         P7oWeNeAswnYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE71DE50D77;
        Tue, 28 Mar 2023 13:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] xen/netback: fix issue introduced recently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168001021877.12098.5546775808625533153.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 13:30:18 +0000
References: <20230328131047.2440-1-jgross@suse.com>
In-Reply-To: <20230328131047.2440-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 28 Mar 2023 15:10:44 +0200 you wrote:
> The fix for XSA-423 introduced a bug which resulted in loss of network
> connection in some configurations.
> 
> The first patch is fixing the issue, while the second one is removing
> a test which isn't needed. The third patch is making error messages
> more uniform.
> 
> [...]

Here is the summary with links:
  - [v2,1/3] xen/netback: don't do grant copy across page boundary
    (no matching commit)
  - [v2,2/3] xen/netback: remove not needed test in xenvif_tx_build_gops()
    https://git.kernel.org/netdev/net/c/8fb8ebf94877
  - [v2,3/3] xen/netback: use same error messages for same errors
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


