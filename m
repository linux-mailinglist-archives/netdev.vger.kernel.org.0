Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417A24AE36E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387233AbiBHWVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386424AbiBHUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B66C0613CB;
        Tue,  8 Feb 2022 12:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C40A8615F0;
        Tue,  8 Feb 2022 20:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27A50C340ED;
        Tue,  8 Feb 2022 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644352209;
        bh=68E9wnaLWeMFqEgMqg4BB32Vuzanv272UXTvoHKrz/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LeNeeVkcz+pgD7pQb/iigfOqreWO+hLisQUlTr0GeGrEisItKriZTRQhbQ0atGv2Y
         /9RU0h7Xrczxx7rzIY5e2aCto3CtiIm2WwsCXSb627fh/VDp1lebU5woHlNtB2Gn16
         8Y9COoX4xT3Ce3YvNOQ+7fWoHGWjRpOyOHDHorOdbrPqA4+U1Vyt0YpFPr8164uv3L
         6CufhgFZUI5O1h4YUEp7fVVgWPjUgm59/eMozqjFfN9b/Oz5nWBokK8wtFe1lsqp2w
         x4UNHzfzH6sGPGsaZtp2wf9BCwMB2S3iadUsrJHL1ipuJ/Er0l6KDtIPJkKfII9sMg
         6ZuJ5/B/9Qp0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 108C9E6BB76;
        Tue,  8 Feb 2022 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5] selftests/bpf: do not export subtest as
 standalone test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164435220906.16710.9125737350953431663.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 20:30:09 +0000
References: <20220208065444.648778-1-houtao1@huawei.com>
In-Reply-To: <20220208065444.648778-1-houtao1@huawei.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     ast@kernel.org, kafai@fb.com, yhs@fb.com, daniel@iogearbox.net,
        andrii@kernel.org, songliubraving@fb.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 8 Feb 2022 14:54:44 +0800 you wrote:
> Two subtests in ksyms_module.c are not qualified as static, so these
> subtests are exported as standalone tests in tests.h and lead to
> confusion for the output of "./test_progs -t ksyms_module".
> 
> By using the following command:
> 
>   grep "^void \(serial_\)\?test_[a-zA-Z0-9_]\+(\(void\)\?)" \
>       tools/testing/selftests/bpf/prog_tests/*.c | \
> 	awk -F : '{print $1}' | sort | uniq -c | awk '$1 != 1'
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5] selftests/bpf: do not export subtest as standalone test
    https://git.kernel.org/bpf/bpf-next/c/5912fcb4bee1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


