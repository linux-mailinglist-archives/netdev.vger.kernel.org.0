Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B50543295
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbiFHOaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241114AbiFHOaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:30:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E63202D34;
        Wed,  8 Jun 2022 07:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F77CCE2909;
        Wed,  8 Jun 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 882B5C3411D;
        Wed,  8 Jun 2022 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654698612;
        bh=VGy4C9AHRhQkQz/+S51Y5tPsXekaEbIMrlULX9E5iv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u30Pa815vfUZB44AQI9WemShM5hBKCdwFqn7BEkIDhbhIgzZIJI2JqhQaS3dftl6Y
         gKZrNk4URRGXHbwsGUuDW669RjJjS8IkhnFQYRVDmfqRL8M1MGn5lEmpiErrD89OMf
         hgq9i9OATaIH+mBOqsXlrs1cODCveT1ZMmJma4bg+RBCS8Qz3aWFdPBiPYtQFQeEqA
         QKRV7OpPAydiJ0aBLZT6FF04Gzxw8myNV2CYWE1WLHGBYRdWxjhUix2y19WAUAGeoF
         Ha/nYvx4vQkW01R+qhliyTs0eFhHC73w69BlmgeOA5K92cHKNlUSod2Rnh0S8y4eo5
         Hs0TTViaz8+mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66E39E737F6;
        Wed,  8 Jun 2022 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: Fix handling of invalid descriptors in XSK Tx
 batching API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165469861241.22143.18204022493863503886.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 14:30:12 +0000
References: <20220607142200.576735-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220607142200.576735-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  7 Jun 2022 16:22:00 +0200 you wrote:
> Xdpxceiver run on a AF_XDP ZC enabled driver revealed a problem with XSK
> Tx batching API. There is a test that checks how invalid Tx descriptors
> are handled by AF_XDP. Each valid descriptor is followed by invalid one
> on Tx side whereas the Rx side expects only to receive a set of valid
> descriptors.
> 
> In current xsk_tx_peek_release_desc_batch() function, the amount of
> available descriptors is hidden inside xskq_cons_peek_desc_batch(). This
> can be problematic in cases where invalid descriptors are present due to
> the fact that xskq_cons_peek_desc_batch() returns only a count of valid
> descriptors. This means that it is impossible to properly update XSK
> ring state when calling xskq_cons_release_n().
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: Fix handling of invalid descriptors in XSK Tx batching API
    https://git.kernel.org/bpf/bpf/c/d678cbd2f867

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


