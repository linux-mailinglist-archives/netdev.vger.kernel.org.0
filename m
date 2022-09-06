Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16065AF7B2
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 00:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiIFWKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 18:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiIFWKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 18:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C33394125;
        Tue,  6 Sep 2022 15:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B000C616FE;
        Tue,  6 Sep 2022 22:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 148B5C433D7;
        Tue,  6 Sep 2022 22:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662502233;
        bh=6nl+07PG2EsRbuGvtWZzO5LV/7d3NT0wju8FrZ4HUY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pchr5qgoaQt4vV0dOQtjSiWTgrgjlPJFP4u204fUqJqLtf03ePOg7Jz52QSPbU8ag
         y5MXTiSfJZo8BsfQzxhU2gMwRMdIW29qqHiztoKER13mMNpUXAkfjHIsYqblXcZ6Vu
         joS1ygLRomQGW7zjR+pqsC4OjMNsYjFUZ3aWxT93zs/4AcRDXNCVDa1cykNSEQm/WJ
         eY7HPNpG+NRdc8tsALOhfqcWatMGajFXUncxuCf/t1SJ0NSegTq0269XrvzKzbAWYS
         6OYAG3G9ld0dR0ri5bkxw3JAycJnRljKYGiFslpObOeCDIRPQtV8XRH1snpYV/2TNH
         JQTYbMX5UEqcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6B8CC73FE9;
        Tue,  6 Sep 2022 22:10:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-09-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166250223293.18190.3241675203059060448.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 22:10:32 +0000
References: <20220905161136.9150-1-daniel@iogearbox.net>
In-Reply-To: <20220905161136.9150-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Sep 2022 18:11:36 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 106 non-merge commits during the last 18 day(s) which contain
> a total of 159 files changed, 5225 insertions(+), 1358 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-09-05
    https://git.kernel.org/netdev/net-next/c/2786bcff28bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


