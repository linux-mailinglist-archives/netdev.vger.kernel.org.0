Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2AF520A65
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiEJAyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbiEJAyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:54:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBF72B2771;
        Mon,  9 May 2022 17:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3609ACE1BE4;
        Tue, 10 May 2022 00:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88963C385C6;
        Tue, 10 May 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652143812;
        bh=4Gt4uG9eEST7m4d9wMaDLLV5BH5/ZE6MmA+v6xS95zE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rY5dm9mo1KFmN4F63WHvB+uNf6evUp8NUW4N2xVR0UE/1IJ7O9ltbZtHEKEwzlfY9
         SredNeqCBK/bbgr/+KYPI183VbUQs7jskk3PN2j+OFvq9TD1DozbSJSHmjGqQ+t6O4
         utxJbUeh9+jdwS50joK6mXJipBdzxDhGcV/rzfXQqZ3IX74yzgqfSG6tFiPtnRVBBc
         +2y1+BafOBBQ9SZ0MoSa/006+6QmTkWHAAV1GsxHxHcjPoiEp2qfFYzjjFFuMxQyp5
         aeFdrMh117mdJ70KQh2XvkhO2FoG+T2Qsvd7SwDuZOUlY5lNTDp8+8HoUADiqZX2k/
         ACdAjDPbk8hXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 635E1F0392B;
        Tue, 10 May 2022 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples: bpf: Don't fail for a missing VMLINUX_BTF when
 VMLINUX_H is provided
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214381239.1602.1018932987303312053.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:50:12 +0000
References: <20220507161635.2219052-1-jmarchan@redhat.com>
In-Reply-To: <20220507161635.2219052-1-jmarchan@redhat.com>
To:     Jerome Marchand <jmarchan@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        memxor@gmail.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Sat,  7 May 2022 18:16:35 +0200 you wrote:
> samples/bpf build currently always fails if it can't generate
> vmlinux.h from vmlinux, even when vmlinux.h is directly provided by
> VMLINUX_H variable, which makes VMLINUX_H pointless.
> Only fails when neither method works.
> 
> Fixes: 384b6b3bbf0d ("samples: bpf: Add vmlinux.h generation support")
> Reported-by: CKI Project <cki-project@redhat.com>
> Reported-by: Veronika Kabatova <vkabatov@redhat.com>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> 
> [...]

Here is the summary with links:
  - samples: bpf: Don't fail for a missing VMLINUX_BTF when VMLINUX_H is provided
    https://git.kernel.org/bpf/bpf-next/c/ec24704492d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


