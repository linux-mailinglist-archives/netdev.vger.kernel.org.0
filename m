Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B800A4E2810
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbiCUNvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiCUNvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:51:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5B813BAFD
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55B4EB81670
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15793C340ED;
        Mon, 21 Mar 2022 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647870610;
        bh=2hYTFGi9ge6ZIlBN0gQXCADsxaCzlNOsZSkPxYSSipE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IIgFvI7AYYVq16ZcEIVE+D1snPn4dxzv4gfzW3+UA5yxmrUwC18WI8kX6o8anCyO6
         Oi1xoNsOy+TOCb8DyW/vhQHpd+vwMH3e8Co+skhSsLuNoT8uTyrFosQJBrSdEQyCfw
         /2eGOvh0vGWy3XptyVux83ZUuXqZxqdNK3vSpa9ERsKW75kVRKNlr4IHSREtxQuOOw
         O3aYDWx6KD9OTwjxkvrThs3hjeG4G0kRy6w5UCpR0E7NA8QxP+5XR9zdcmZoVq6oeM
         8uzZxnTo2zOtKG5Mqx1KQn8eRlcIKePb9Mi/fGGay/8/LIt7lGsr45BMdj/lErSnBU
         ikmpr8swLivoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC87AE6D44B;
        Mon, 21 Mar 2022 13:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 bpf] selftests/bpf/test_lirc_mode2.sh: exit with proper code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787060996.2929.14760488487635325153.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 13:50:09 +0000
References: <20220321024149.157861-1-liuhangbin@gmail.com>
In-Reply-To: <20220321024149.157861-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, sean@mess.org, ast@kernel.org,
        daniel@iogearbox.net
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 10:41:49 +0800 you wrote:
> When test_lirc_mode2_user exec failed, the test report failed but still
> exit with 0. Fix it by exiting with an error code.
> 
> Another issue is for the LIRCDEV checking. With bash -n, we need to quote
> the variable, or it will always be true. So if test_lirc_mode2_user was
> not run, just exit with skip code.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,bpf] selftests/bpf/test_lirc_mode2.sh: exit with proper code
    https://git.kernel.org/bpf/bpf-next/c/ec80906b0fbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


