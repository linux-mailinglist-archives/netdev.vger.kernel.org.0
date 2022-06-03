Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D153D35A
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349472AbiFCVuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348524AbiFCVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C21857B3E;
        Fri,  3 Jun 2022 14:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0954DB824D3;
        Fri,  3 Jun 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B99DBC385B8;
        Fri,  3 Jun 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654293012;
        bh=fR6fob+9O+pCOSCd6PBNvUuCkKOXMFXpOeVqRlpSb2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PlGG7ZmaQDP22LGd52GJqmVRTXXt1Sh4ywBFNh9+xbPfDitPyfaaliCFn3jAVvKVw
         l1TmL72iD+4ZOM1hnpO6QSBV6fSeEixAYb7ahpNE95sIUQOuosoyvDtWS1fwtvhS/2
         MtnSnYGKNV0RbxzxR7m+tY11HCakdDMDw+bk5QEoMcQ616QPfevgF4SxqsA8bLR2Ne
         S0HOtwzVl3a/yPscgC/JCOk5yHwcmPv4UYzWnYRrfOkRppLAVJ/it7N3oK5HJhWgLt
         KQwNb+wMDpQvc0cxX2O4csJcCg/D9nh3f7Qyz/Cg0w616/yr6leWO/nbmkwjefO/bE
         jX/UiDlxvwlJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9373DF03953;
        Fri,  3 Jun 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: add drv mode testing for xdping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165429301259.9114.6663984717109510766.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Jun 2022 21:50:12 +0000
References: <20220602032507.464453-1-liuhangbin@gmail.com>
In-Reply-To: <20220602032507.464453-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, m.xhonneux@gmail.com, u9012063@gmail.com,
        toshiaki.makita1@gmail.com, brouer@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu,  2 Jun 2022 11:25:07 +0800 you wrote:
> As subject, we only test SKB mode for xdping at present.
> Now add DRV mode for xdping.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_xdping.sh | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [bpf-next] selftests/bpf: add drv mode testing for xdping
    https://git.kernel.org/bpf/bpf-next/c/43496801c7bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


