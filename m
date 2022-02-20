Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721134BCB8A
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 02:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243324AbiBTBka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 20:40:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240694AbiBTBk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 20:40:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C9F42A09;
        Sat, 19 Feb 2022 17:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 727A560F46;
        Sun, 20 Feb 2022 01:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF9FCC340EC;
        Sun, 20 Feb 2022 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645321208;
        bh=PnukixR+A2KtHQcL/rrSlVPDRMyonzeS6wryKYPbRhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kkaPLVSj+sV/2yqpJHhi2KgwPgBT3/yXlLTVdx6zBoSEY7F44YDrelQCdwz7toDhq
         yw8b2DTj6vnImAqN2naHYu7i8kShf8OuhU2eatcHe5Y1ayWd24njtQI9kszstMaXNt
         518KzXhcsCeGW9+sy55jJ3muB+Q1cZG7653K4sklzwacy3fP0Ealy4sEUE9nSrfkV6
         WaqzQv1IBlBHKebv1f0J7lCmx4XKffw8r9aPg6+f5NW9iN/hI5b+iEg+W9xKVPwjsN
         unD8hw2cOC0tAJD5nfxJqiynt+HCYwvSCdYtV78KOclKvdB6dA/KGV39PtLyggNe8n
         A2M5rd7k77BUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B87A2E7BB0C;
        Sun, 20 Feb 2022 01:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Initialize ret to 0 inside btf_populate_kfunc_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164532120875.31312.6528483112580808010.git-patchwork-notify@kernel.org>
Date:   Sun, 20 Feb 2022 01:40:08 +0000
References: <20220219163915.125770-1-jrdr.linux@gmail.com>
In-Reply-To: <20220219163915.125770-1-jrdr.linux@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, memxor@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Alexei Starovoitov <ast@kernel.org>:

On Sat, 19 Feb 2022 22:09:15 +0530 you wrote:
> From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
> 
> Kernel test robot reported below error ->
> 
> kernel/bpf/btf.c:6718 btf_populate_kfunc_set()
> error: uninitialized symbol 'ret'.
> 
> [...]

Here is the summary with links:
  - bpf: Initialize ret to 0 inside btf_populate_kfunc_set()
    https://git.kernel.org/bpf/bpf-next/c/d0b3822902b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


