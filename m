Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043E054EA54
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378143AbiFPTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiFPTuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961925133E;
        Thu, 16 Jun 2022 12:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E60EB825F5;
        Thu, 16 Jun 2022 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD113C3411B;
        Thu, 16 Jun 2022 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655409013;
        bh=um5m49GPpeEUSpRAePM11CTNL/FY/Sqwi3oYSzeUaqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WyyJhsomMEUj3l+sRNAkv+zn9fku5ja1XEF5EZ0KI9TxBV1OsJoFxa+6CMStKtJH3
         SNmj+ksduQMoX6PO2ifR1WE6rlkU/qcVRXZIAu4n0uTswCsvPWm3FrmJUVJQ7PTvUS
         jPwW13g5tnh1qoaWjLvaQposfzwIcBQcavfrO8mEK5HWnWfXVQ/osKXMEm5OmhLxPT
         xAdWGOgI7lzBcGJl6iONhXGQGfW6ciClx6BIAczDZLR+lVjeXTtIh5dfIf+7HcFa9N
         egX52OpQT21Bi3AP88NRkzdzkRTZ2GicBDqmaACovEmzsUVdiYQD+eLoNF7L4Agsxz
         VUZgx0WFY6Lug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C13FFE7385C;
        Thu, 16 Jun 2022 19:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Fix tail call counting with bpf2bpf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165540901378.6261.15158160750256400048.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 19:50:13 +0000
References: <20220616162037.535469-1-jakub@cloudflare.com>
In-Reply-To: <20220616162037.535469-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        maciej.fijalkowski@intel.com, kernel-team@cloudflare.com
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

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 16 Jun 2022 18:20:35 +0200 you wrote:
> Please see patch 1 for the explanation of the problem.
> Patch 2 adds a test so that we don't regress.
> 
> v1 -> v2:
> - switch from __attibute__((always_unused)) to unused to avoid CI failures.
> 
> Jakub Sitnicki (2):
>   bpf, x86: Fix tail call count offset calculation on bpf2bpf call
>   selftests/bpf: Test tail call counting with bpf2bpf and data on stack
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf, x86: Fix tail call count offset calculation on bpf2bpf call
    https://git.kernel.org/bpf/bpf/c/ff672c67ee76
  - [bpf-next,v2,2/2] selftests/bpf: Test tail call counting with bpf2bpf and data on stack
    https://git.kernel.org/bpf/bpf/c/5e0b0a4c52d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


