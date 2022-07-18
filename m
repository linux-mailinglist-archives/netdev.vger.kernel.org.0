Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48003578799
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiGRQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiGRQkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B10CE11
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A58EB614E8
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6324C341C0;
        Mon, 18 Jul 2022 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658162412;
        bh=Hix7yctmIbYrKU0abLRi6KqsdwBWm5B1gl2uj2/Hk8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JsNNmTYarifehOyLn4mAOueOoE8kM6IEFfc/V9w7DlOEeUgS/ryalsBXyjljjmSmW
         mz9y9s88F6xdSv64dRQtVQnEQWfjGTXu66SSKbbR6eBZ7GgoblM6Q3Y/Un+8GEtnDQ
         bFzAt2bQWTWTLWq4FxXeb+mHKQkhAE/UofUCvAnu1UY2983te4Y03zKQDvNS+7MfJU
         zFirYioNt398BDVwSVZ1Bc084PYk5cv3Lo+6hcDceQ8F4pT3TZehzT82Q5iI19AQDz
         rIIFux08YAViBuuEa7qAnY9HGHrQ4uh3pzyTqXs576s7ID6yCBS+wCbOKhz1OYmQZ1
         G9UbrnASGtBwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBE6BE451B2;
        Mon, 18 Jul 2022 16:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] uapi: add virtio_ring.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165816241283.22901.740311487318229448.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 16:40:12 +0000
References: <20220718163513.12441-1-stephen@networkplumber.org>
In-Reply-To: <20220718163513.12441-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     elic@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 18 Jul 2022 09:35:13 -0700 you wrote:
> When vdpa was updated, it included linux/virtio_ring.h but that
> sanitized header file was not added.
> 
> Fixes: bd91c7647189 ("vdpa: Allow for printing negotiated features of a device")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  include/uapi/linux/virtio_ring.h | 242 +++++++++++++++++++++++++++++++
>  1 file changed, 242 insertions(+)
>  create mode 100644 include/uapi/linux/virtio_ring.h

Here is the summary with links:
  - [iproute2] uapi: add virtio_ring.h
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=325f706ba708

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


