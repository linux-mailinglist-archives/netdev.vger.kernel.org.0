Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8340454FB3B
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383350AbiFQQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiFQQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C9043491;
        Fri, 17 Jun 2022 09:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 916F9B82B1C;
        Fri, 17 Jun 2022 16:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5145FC3411C;
        Fri, 17 Jun 2022 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655484016;
        bh=Qer7R+JRaL9ozPcr8fm1m4NZiITMwGqWJq6hQYI2NJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vDEKuiV1w8vjMNEnfC5oJFXeLMXMD7H/kVHq3NRXvUsiYFer1qjDGT5JKm0MHTzc+
         VuJX0qKcsl77LN25afVJiMziFr8wSzSBaW5sb0kBvbBpKjJqFW1yhpF//7UV1qlnBC
         ggiCtrzOl837NoGcRXrdzRKUNcBWnkCDmjFsMigAgT5fOUkkiHc5+qJIRWVgZDzQg8
         vXgcokuT5vCE594KzSQ1SXHwiDvv4JZAgWoQ3lWIDK8f0I4FiwYYiI+ZRzf2vN5N3h
         FDOYtJ5kS5BwIwr2Km/+DyaqTXmV1LLo3FePFl1SXAv2mN2693I27Vmi8+wBaKNIyA
         iKCTImOrmAj7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 395E8E7385C;
        Fri, 17 Jun 2022 16:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: fix bpf_skc_lookup comment wrt. return type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165548401623.32767.11672891137463822335.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 16:40:16 +0000
References: <20220617152121.29617-1-tklauser@distanz.ch>
In-Reply-To: <20220617152121.29617-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 17 Jun 2022 17:21:21 +0200 you wrote:
> The function no longer returns 'unsigned long' as of commit edbf8c01de5a
> ("bpf: add skc_lookup_tcp helper").
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  net/core/filter.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - bpf: fix bpf_skc_lookup comment wrt. return type
    https://git.kernel.org/bpf/bpf-next/c/f5be22c64bd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


