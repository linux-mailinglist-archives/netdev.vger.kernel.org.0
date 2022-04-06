Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321534F69A5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiDFTRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiDFTPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:15:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B08216F99;
        Wed,  6 Apr 2022 10:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E52DDB824E9;
        Wed,  6 Apr 2022 17:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E92AC385A5;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649265612;
        bh=MMU5XGllo+8yHGXnAXzQ3+JJnqca7TBXCTyeXdUvgaA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DOaGlWEJrdtAqZXkQyVy1N1txuyk5/oz1bUyME6JV2nkUEFsT8JHPimoJpJklBtMH
         TRCG7xju/Au4KsRZWr1o5UdPB7gxYqJn/pMhcX7AM8VNjlQu14tPhV/T9eyhB59wau
         Q7C3OAcWZBtjsebYCxAYHByjH2VEPtwdbbsdwUC6AvsECoD/cVuZFUXpMxqJAKmQ5J
         uHqdk9f2P0ucLYNOFVhTXCQ2Iy+6abGm70xwF4pWdnzuwJZgXjU+C1wd3T0Lk8fsG5
         rdeEBc1dBsJ8LkoSKp280LbLEOXF9PqgafaPqbO/F8Nzqto4RsloqLVeu49HxmNeCm
         kaoLomJdkzvxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B49CE85BCB;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] selftests/bpf: Fix issues in parse_num_list()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164926561223.23950.5441480485947664508.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 17:20:12 +0000
References: <20220406003622.73539-1-ytcoode@gmail.com>
In-Reply-To: <20220406003622.73539-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     andrii.nakryiko@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  6 Apr 2022 08:36:22 +0800 you wrote:
> The function does not check that parsing_end is false after parsing
> argument. Thus, if the final part of the argument is something like '4-',
> which is invalid, parse_num_list() will discard it instead of returning
> -EINVAL.
> 
> Before:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] selftests/bpf: Fix issues in parse_num_list()
    https://git.kernel.org/bpf/bpf-next/c/958ddfd75d83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


