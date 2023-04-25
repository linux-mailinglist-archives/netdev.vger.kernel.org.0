Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE876EDA1D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 04:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjDYCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 22:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDYCAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321535FFD;
        Mon, 24 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C095662AE6;
        Tue, 25 Apr 2023 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 219ADC433EF;
        Tue, 25 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682388019;
        bh=u9KsuYpPH1hP1pH4Xf5L9xtgjgGu8HtuAHRBT4oovKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xj4FYJ7znUz25og8bvzl1amvxfV8cw5doizDEdk7c93yTQSOQhUdgF2Vl2nKWNQ8z
         eV7CYa/YHvEAtKLTUblafWU9JeP+AWGv14D36AGOoWsLS6ijL3uGX8UKvXueZVq1st
         iF3dR1UZdoIbwNHG72aHwGJdi7gO5fV06DzxLwU5I8Krjt5TBlZYc1Bxl6tuQni2cQ
         fBiurQdJb1ck0Q6rHtecNl/pJ2rGKCXvpFFaSgJQxGEGW5s4Sdg1KUmeDKaIQSFVYH
         EtQPItNfCnGzTfa0Jo0r3xOVe3zUY57Anpz7Q/t5kxhCCRqcog6fXYlvM2Fg0hKrJR
         fKd+IefKnoiSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE0D0C395D8;
        Tue, 25 Apr 2023 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-04-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238801897.30299.17302345904252825144.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 02:00:18 +0000
References: <20230425005648.86714-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230425005648.86714-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, andrii@kernel.org,
        martin.lau@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Apr 2023 17:56:48 -0700 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 5 non-merge commits during the last 3 day(s) which contain
> a total of 7 files changed, 87 insertions(+), 44 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-04-24
    https://git.kernel.org/netdev/net-next/c/ee3392ed16b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


