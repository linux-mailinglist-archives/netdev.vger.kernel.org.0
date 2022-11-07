Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B724461F3AF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiKGMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiKGMuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5123B4A9
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815BD60EDC
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFA07C433C1;
        Mon,  7 Nov 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667825416;
        bh=FTaD1hR9PlnFdRGXIX1N8BUVqslOTnyztotahcicDJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VgtYZGJLNndyj7L+ZEHqGMF/txk7V+c5Nq1p45R/nrIuyhV2wfp3eO7YTanmd/geQ
         6njx3QgEEGJTs4UJg423AYBGjiDr2/mFpq0JpMsxs+utCy3QK6UN7Teltw3x/yFGC5
         z98VZCRyC+r0Spug3wlKIwZbTSCc77CSDuzceIxXOnFDAH3cy9IQ7TUjOMlZ2DHUld
         TnQMyS9P2cLq3Sbu2Wsc+M0QGqkzs7lsaatyQzo/6WgyZXi+4phySEjVMVgv8aEdt+
         HPpWNtaFYXXtKP8D1ZZ5g/YOmDJIHCBvN83S0Cdz3F/llcWgkSE5H3YPI+nECpjpqq
         pTUKdioXBEfcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4467C41671;
        Mon,  7 Nov 2022 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/13] genetlink: support per op type policies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782541673.29638.6404323144233326170.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 12:50:16 +0000
References: <20221104191343.690543-1-kuba@kernel.org>
In-Reply-To: <20221104191343.690543-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Nov 2022 12:13:30 -0700 you wrote:
> While writing new genetlink families I was increasingly annoyed by the fact
> that we don't support different policies for do and dump callbacks.
> This makes it hard to do proper input validation for dumps which usually
> have a lot more narrow range of accepted attributes.
> 
> There is also a minor inconvenience of not supporting different per_doit
> and post_doit callbacks per op.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/13] genetlink: refactor the cmd <> policy mapping dump
    https://git.kernel.org/netdev/net-next/c/ff14adbd8779
  - [net-next,v3,02/13] genetlink: move the private fields in struct genl_family
    https://git.kernel.org/netdev/net-next/c/7c3eaa022261
  - [net-next,v3,03/13] genetlink: introduce split op representation
    https://git.kernel.org/netdev/net-next/c/20b0b53aca43
  - [net-next,v3,04/13] genetlink: load policy based on validation flags
    https://git.kernel.org/netdev/net-next/c/7747eb75f618
  - [net-next,v3,05/13] genetlink: check for callback type at op load time
    https://git.kernel.org/netdev/net-next/c/e1a248911d06
  - [net-next,v3,06/13] genetlink: add policies for both doit and dumpit in ctrl_dumppolicy_start()
    https://git.kernel.org/netdev/net-next/c/92d3d9ba9bb3
  - [net-next,v3,07/13] genetlink: support split policies in ctrl_dumppolicy_put_op()
    https://git.kernel.org/netdev/net-next/c/26588edbef60
  - [net-next,v3,08/13] genetlink: inline genl_get_cmd()
    https://git.kernel.org/netdev/net-next/c/8d84322ae6d7
  - [net-next,v3,09/13] genetlink: add iterator for walking family ops
    https://git.kernel.org/netdev/net-next/c/6557461cd278
  - [net-next,v3,10/13] genetlink: use iterator in the op to policy map dumping
    https://git.kernel.org/netdev/net-next/c/b502b3185cd6
  - [net-next,v3,11/13] genetlink: inline old iteration helpers
    https://git.kernel.org/netdev/net-next/c/7acfbbe17c18
  - [net-next,v3,12/13] genetlink: allow families to use split ops directly
    https://git.kernel.org/netdev/net-next/c/b8fd60c36a44
  - [net-next,v3,13/13] genetlink: convert control family to split ops
    https://git.kernel.org/netdev/net-next/c/aba22ca8ccd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


