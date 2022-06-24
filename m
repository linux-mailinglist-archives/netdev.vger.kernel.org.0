Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E955A2DE
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiFXUkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 16:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXUkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 16:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D88506EB;
        Fri, 24 Jun 2022 13:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5435FB82C11;
        Fri, 24 Jun 2022 20:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 060D5C34114;
        Fri, 24 Jun 2022 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656103213;
        bh=9iPJDMdsLOTs+gVhh/J9sqCKNq4wk8utxW/b4IH50iQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IG67JxY0FIPu2CHbfl7ych6gXyxZQ8hUZ62LvDqoeiIy0pbPStyPq02Zo0plk8hrm
         5cFnsOmqnB53YtO8tZEkMviu+tT4bDkBbWL/FdYg5CmSBnOWchrJig4ZX/YHpvAzHv
         Lhh33C7K9tzXYgSSXL3lKWFiMN0IyKr2vcsn/msLmiKIQp1hGxBuf1JjeXdOTqHN7w
         CCbQ+c0QfS15w720ndL8YYV34V+B6sLGS4paM4pYLtIdQkBsunY36wHoojoXPJLw0q
         89U02dDzQXCPl7XqvR7Xed9tyKN8+xh8yVnI5I24nL6KfWKxrvcF3l/i9OrQ/96idq
         Z07M9bJntDhTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E014CE737F0;
        Fri, 24 Jun 2022 20:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 bpf-next 0/1] perf tools: Fix prologue generation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165610321291.32168.11018330141135892002.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 20:40:12 +0000
References: <20220616202214.70359-1-jolsa@kernel.org>
In-Reply-To: <20220616202214.70359-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     acme@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, mingo@kernel.org,
        namhyung@kernel.org, alexander.shishkin@linux.intel.com,
        a.p.zijlstra@chello.nl, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, irogers@google.com
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

On Thu, 16 Jun 2022 22:22:13 +0200 you wrote:
> hi,
> sending change we discussed some time ago [1] to get rid of
> some deprecated functions we use in perf prologue code.
> 
> Despite the gloomy discussion I think the final code does
> not look that bad ;-)
> 
> [...]

Here is the summary with links:
  - [PATCHv5,bpf-next,1/1] perf tools: Rework prologue generation code
    https://git.kernel.org/bpf/bpf-next/c/b168852eb8ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


