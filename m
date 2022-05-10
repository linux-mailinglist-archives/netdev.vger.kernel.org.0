Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2B522323
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348426AbiEJRyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343670AbiEJRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED1362205;
        Tue, 10 May 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8888619BF;
        Tue, 10 May 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DE7FC385C8;
        Tue, 10 May 2022 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652205013;
        bh=QxD8u2R9y27i69bURiPzO1upnHPbeXgzvTA9oF2xSLo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lLtSBH3pEYtCkaYUnulgmLEk4dL9utQPYnMCim53iYvmT5jomINaXsUnOt4xPYxXE
         7uk6PvJYHnaXyY1MKAxMDC9jp1XldjLfAaMacFGYqa48ZiomwyBYnjUKqPFxAt2kue
         zPKstTjjA2YnO6mCbjjPt9ZOKivh+RItuCvq6q4TIBVYvRH2WXiArqbIsF1ScBpwO2
         0qjEaiDUX9svFMMxVeVkyKrqdQqoT+VF1xXjtcyRC6zp3yW9FpAjXKqTnZnrQWFvJ1
         jmWhQByVFz4f18JiO+IpqK5NCZ4vMtcBHNGobl+eOaaQN7Vhi27wPlydrUX03Yo3h2
         rlQUFmRS+rC9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20014F0392E;
        Tue, 10 May 2022 17:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v6 1/2] bpf: Extend batch operations for map-in-map
 bpf-maps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165220501312.1369.12954658949323074490.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 17:50:13 +0000
References: <20220510082221.2390540-1-ctakshak@fb.com>
In-Reply-To: <20220510082221.2390540-1-ctakshak@fb.com>
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
        ast@kernel.org, ndixit@fb.com, kafai@fb.com, andriin@fb.com,
        daniel@iogearbox.net, yhs@fb.com
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
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 10 May 2022 01:22:20 -0700 you wrote:
> This patch extends batch operations support for map-in-map map-types:
> BPF_MAP_TYPE_HASH_OF_MAPS and BPF_MAP_TYPE_ARRAY_OF_MAPS
> 
> A usecase where outer HASH map holds hundred of VIP entries and its
> associated reuse-ports per VIP stored in REUSEPORT_SOCKARRAY type
> inner map, needs to do batch operation for performance gain.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v6,1/2] bpf: Extend batch operations for map-in-map bpf-maps
    https://git.kernel.org/bpf/bpf-next/c/9263dddc7b6f
  - [bpf-next,v6,2/2] selftests/bpf: handle batch operations for map-in-map bpf-maps
    https://git.kernel.org/bpf/bpf-next/c/a82ebb093fc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


