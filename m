Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A8561E09
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiF3Oep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbiF3Oeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:34:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABCF50708;
        Thu, 30 Jun 2022 07:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2891A622F9;
        Thu, 30 Jun 2022 14:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C37CC341CB;
        Thu, 30 Jun 2022 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656598814;
        bh=NHpZJJxerMp/V3SI99bfmObIYCbgF39n92fkVdF3ACw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DvnY9c54XCrQcYp6CBSVLhYc9jF5DWLjHPqqRKRlBRNWKln9Ij5SdH4IVU8PtDBwd
         v5UgAXaYi7xf6OSPnvhcC2G1zd3eI7rqRyOuY6smIiAg28uMW3+6ob5bvbOaydYY2W
         HzenzwzpTVNH24FJR3bVgFjrBKCUMFsEWNSyXjjgvqW4DI2cuerPMqJo4eeLTrMHjQ
         QcKkEAjyAi70blyhLxaFZfXBCouoG9rtlFaCB42BIZfh35MzimkawEkAK7JEr1og7D
         jV+0Ptql2QqNRlJaSPmPUnGftKCF8oUH8jMaUOynsLvho4RLWEHyaEshwDXfVK8YXY
         ys3Gabl0jGHKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CD61E49BBA;
        Thu, 30 Jun 2022 14:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] bpftool: Add command to list BPF types,
 helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165659881437.5783.4681054959379123186.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 14:20:14 +0000
References: <20220629203637.138944-1-quentin@isovalent.com>
In-Reply-To: <20220629203637.138944-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 21:36:35 +0100 you wrote:
> Now that bpftool relies on libbpf to get a "standard" textual
> representation for program, map, link, and attach types, we can make it
> list all these types (plus BPF helpers) that it knows from compilation
> time.
> 
> The first use case for this feature is to help with bash completion. It
> also provides a simple way for scripts to iterate over existing BPF types,
> using the canonical names known to libbpf.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpftool: Add feature list (prog/map/link/attach types, helpers)
    https://git.kernel.org/bpf/bpf-next/c/27b3f7055343
  - [bpf-next,v2,2/2] bpftool: Use feature list in bash completion
    https://git.kernel.org/bpf/bpf-next/c/6d304871e3ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


