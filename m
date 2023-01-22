Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE15677159
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 19:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjAVSKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 13:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjAVSKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 13:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA1A7D9D
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 10:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ACC6B80B43
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76869C4339B;
        Sun, 22 Jan 2023 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674411017;
        bh=JvaqyJbLunW409VX0gz6/4onJ1M6d7+hR2taF7GHBdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZzwBSWLTNy8C1eoa0oVFxRU7nbdbPiMa46/HoJsjG9EgV2WGdoIFwlx3NAzMQb8jc
         tCaaSFYw9ItoJ2kMrm5XFVNfwFkuo2LGEJZHE0y72pnkOd29138noKMwbsvpJB+8ZK
         IGWvEPCI/5xdFP/OHdpYJBL2qMGuGy+5zOx2bCbkzP1ei4rJM9z7At/YziNTE/p1jZ
         w7nFKG9cugM2U6alOrCc6MQGsjm2Lq3CFLeACKOuBLGZQacwZgn4QfgdPkyYSnIJcW
         LLvf0PY+A50uhvhPC4KBh5345KnyuxbNQi/syMflENgNRv96GyMy8pYysGVX+GaJtg
         64UNQ/UR05kMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E656C73FFF;
        Sun, 22 Jan 2023 18:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 iproute2-next 0/2] tc: add new attr TCA_EXT_WARN_MSG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167441101731.17541.6561355295995339191.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Jan 2023 18:10:17 +0000
References: <20230117071925.3707106-1-liuhangbin@gmail.com>
In-Reply-To: <20230117071925.3707106-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 17 Jan 2023 15:19:23 +0800 you wrote:
> This patch set revert commit 0cc5533b ("tc/tc_monitor: print netlink extack
> message") as we never used it. Then add new attr TCA_EXT_WARN_MSG to print
> the extack message as we proposed in the net-next patch.
> 
> I would reply to the kernel patch directly as it's not updated.
> 
> v2: Add a helper to print the warn message. I still print the msg in
> json ojbect given the disscuss in
> https://lore.kernel.org/all/20230114090311.1adf0176@hermes.local/
> 
> [...]

Here is the summary with links:
  - [PATCHv2,iproute2-next,1/2] Revert "tc/tc_monitor: print netlink extack message"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=77d4425560ce
  - [PATCHv2,iproute2-next,2/2] tc: add new attr TCA_EXT_WARN_MSG
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


