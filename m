Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18895232FA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiEKMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiEKMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BB693986;
        Wed, 11 May 2022 05:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2AD3B822BE;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EEB8C34110;
        Wed, 11 May 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652271612;
        bh=321uBqEA+gMFFgP+/Jy9UBeFESI24OAPZOPMps+TQAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XfUu0Kcf74ixJvFW69re0JBs2bXoN+xF+6IHw8ofCsd+ddGpe3RVCP4Dv5EIT36jz
         VGHqjf2DEczpVJULfEiH1MIBZeegjUwUlbtQdPhweOu9+YdBqzdu/7tC/gtc+G86SJ
         GfOaFfSo561tym7sxqacsnqCLL7djB3LYLobUPWJxX4idDto077bDnrrJcN6LMKDhu
         pcawn04ed7lzhrXPkNfsQMugeYaBVz05gcyIyf2PfqnWvBgeaV7dgeSQLlwLEZCPr5
         qJ/oSak22asWQ4lDG6D1Zkq5vAM1h13VCK1PtF3zLV3+P8aQGdFKapd7SEHBcVYqNS
         XtI6RSZ0WcxLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DF94F03930;
        Wed, 11 May 2022 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165227161237.6774.12698881017811267125.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 12:20:12 +0000
References: <20220510074659.2557731-1-jolsa@kernel.org>
In-Reply-To: <20220510074659.2557731-1-jolsa@kernel.org>
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

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 10 May 2022 09:46:56 +0200 you wrote:
> hi,
> sending change we discussed some time ago [1] to get rid of
> some deprecated functions we use in perf prologue code.
> 
> Despite the gloomy discussion I think the final code does
> not look that bad ;-)
> 
> [...]

Here is the summary with links:
  - [PATCHv2,bpf-next,1/3] libbpf: Add bpf_program__set_insns function
    https://git.kernel.org/bpf/bpf-next/c/b63b3c490eee
  - [PATCHv2,perf/core,2/3] perf tools: Register fallback libbpf section handler
    (no matching commit)
  - [PATCHv2,perf/core,3/3] perf tools: Rework prologue generation code
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


