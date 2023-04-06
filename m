Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4804A6D9F65
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbjDFSAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbjDFSAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9376F7AA5;
        Thu,  6 Apr 2023 11:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D6E64A1A;
        Thu,  6 Apr 2023 18:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81AFCC433D2;
        Thu,  6 Apr 2023 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680804019;
        bh=v5R4mMUnqXdjSSEA3QJ6nJ6ktc9IvAa/Dw0E0pHH0C0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MpD3RlAcmpQCxFQxkovTDcFJVP8kVKy3bRcM++wLZdhkvg8UrEcBBIwp6YMCCa1QH
         5S6v7l0TQzf3PXDWlawD2rt8MThFwbBvSSCNsE+lWimd+Ea8ol7Itkk8594KnwENUY
         Wy7gh86ItDheHLfHEqYo2v5gIOxTDXcEUTskU31ff3fzjP0w1oFN4qac+4MOcWWzuR
         WFtKmNyBfLaFFEadhoLzGzEAKrlgRq/u1juPnWzbOeEqG8sTtavr8TNGDXnQWx5kGF
         u5aELag0xiaA4giHFhL0/FbhDlDkCpTtQWpVyF5tjyja8XJpu76rfaFKtqk1R0vCuk
         S8fqx0dy2Uavw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B855E4F14C;
        Thu,  6 Apr 2023 18:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] xsk: Fix unaligned descriptor validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168080401937.30717.9924260915794776504.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 18:00:19 +0000
References: <20230405235920.7305-1-kal.conley@dectris.com>
In-Reply-To: <20230405235920.7305-1-kal.conley@dectris.com>
To:     Kal Conley <kal.conley@dectris.com>
Cc:     magnus.karlsson@intel.com, martin.lau@linux.dev, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Thu,  6 Apr 2023 01:59:17 +0200 you wrote:
> This patchset includes the test with the bugfix as requested here:
> https://lore.kernel.org/all/f1a32d5a-03e7-fce1-f5a5-6095f365f0a9@linux.dev/
> 
> Patch #1 (the bugfix) is identical to the previous submission except
> that I improved the commit message slightly.
> 
> Magnus: I improved the test code a little different than you asked
> since I thought this was a little simpler than having a separate
> function for now. Hopefully, you can live with this :-).
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] xsk: Fix unaligned descriptor validation
    https://git.kernel.org/bpf/bpf-next/c/d769ccaf957f
  - [bpf-next,v2,2/2] selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
    https://git.kernel.org/bpf/bpf-next/c/c0801598e543

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


