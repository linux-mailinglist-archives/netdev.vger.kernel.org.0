Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618BB60B92D
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiJXUFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiJXUE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E2B8E7AE;
        Mon, 24 Oct 2022 11:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B271EB8119F;
        Mon, 24 Oct 2022 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E8EFC4347C;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635618;
        bh=R+2KtxrUyL+pTjdv66gb+xQQQUElVH62Vagfs8JDJCE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pc7pLaUa/qb37g1NNG6M3aUdVUzNzHLt5ZQUC9SdD4+lFwEyL9sHoCoUyy5jmzeuG
         +KnTEst0IXUn/mA0d8Cb0PdZHky5puFncTpYELnUJaW+wiogzCVMsPoZzss4hRJDe0
         J2GSTHcDyNxZtTkOIKVBcmitMU+AQ2JKYrSAzkSlcU41bZHF4Fm8BDotvJAyszbXww
         bh7H1xEBgtJgqqgnVaxFdwQj39kyQybhLXrntbQbvfdAkr5bMB+KKG+Zk6Z+nH5lxf
         /i4PR5XFY1uV44dckngYI1ZdR8fcjRV2caOxYFecyZX9LxrxwGMTSCm2tohBVbsb94
         sSt5VdTWUa3Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 415BEE270DD;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-10-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166663561826.26708.13087154571198940817.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 18:20:18 +0000
References: <20221023192244.81137-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20221023192244.81137-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, pabeni@redhat.com, edumazet@google.com,
        kafai@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 23 Oct 2022 12:22:44 -0700 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 18 day(s) which contain
> a total of 8 files changed, 69 insertions(+), 5 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-10-23
    https://git.kernel.org/netdev/net/c/e28c44450b14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


