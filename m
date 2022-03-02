Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC9B4C99CB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiCBAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 19:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiCBAUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:20:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D52737A3D;
        Tue,  1 Mar 2022 16:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089506152A;
        Wed,  2 Mar 2022 00:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59FC1C340F1;
        Wed,  2 Mar 2022 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646180410;
        bh=7TmbPNeyrbdTFC9kHvoFUq3Yxw1YNUw4vZHy9spdk38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t83ss6LXBDiERMFIoeHOzto1wVZOsLXRFlU4Ukc4hPxOSpUA50zfs/MtSGY30IiwS
         2PnYXuGSz2z9pMbjrrw+LCZmsKhWVAcsHQQ8rNQdtPd/P34OUo4po0XvXRwduSqf6A
         9/VSDNhTLohn5tS10Q2MSKcY35dEN6+/OzqCTTDWPVYGTCCHYZWRQupMqvSHascyUA
         5Eqs2z4QT4UK3VDAw3a86qipIA09jrJUeVNzTtLk6qDxBqpkIp423S79GQ4JbdzgB8
         YaPUZokNmjEcOurcZl4XOJ+wjcG3P7l3OUEi3+XJlMlz3JkZcjehC1jdAdjnIYdqSG
         88Uub7gb+Wl0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DBD0EAC096;
        Wed,  2 Mar 2022 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: test_run: Fix overflow in xdp frags
 bpf_test_finish
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618041024.17951.11462268457518578806.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 00:20:10 +0000
References: <20220228232332.458871-1-sdf@google.com>
In-Reply-To: <20220228232332.458871-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, lorenzo@kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 28 Feb 2022 15:23:32 -0800 you wrote:
> Syzkaller reports another issue:
> WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> check_copy_size include/linux/thread_info.h:230 [inline]
> WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> copy_to_user include/linux/uaccess.h:199 [inline]
> WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> bpf_test_finish.isra.0+0x4b2/0x680 net/bpf/test_run.c:171
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: test_run: Fix overflow in xdp frags bpf_test_finish
    https://git.kernel.org/bpf/bpf-next/c/530e214c5b5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


