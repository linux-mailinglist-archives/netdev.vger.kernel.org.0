Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA924D0FCB
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiCHGLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiCHGLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:11:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6831C33E39;
        Mon,  7 Mar 2022 22:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19AC6B81737;
        Tue,  8 Mar 2022 06:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A77E3C340EC;
        Tue,  8 Mar 2022 06:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646719810;
        bh=Y7yBcvdHgVlyO4RBCyQTcv/HuLo3QjAKY/d5k8yJOaI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDnFFFiXNkSpuozA63pp9x9eOfwnFDwdbjVL2INdPXYABFiDdWK9MzVg0cdokVVow
         6/YdanDGZbMB/iBsbN11N3IUkDafj+795wQ6ozork8AVE74GS7psE3D/8jNuhhgWGn
         iWqciGXIV1/oUEpd/LftpOECUObLKWUINOpblSprS/skEhr1mBQ9FT8MSjKJB7SV2G
         Zre+dttL+JfHDpWiL+jD4QTfisQ8beRa8hZ+JxDoNpN0S7lXZgGvGXTUvp9/4zKPVV
         RnImtaW2jTAZxO0hOzBsdG4JvNzSkKpkqztvGyB7O0d+DgYDoJfsyB0Xpze9HQMWdD
         9taxdKvnHLBSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 875A2E6D3DE;
        Tue,  8 Mar 2022 06:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf: Replace strncpy() with strscpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164671981055.5704.6695413392118997565.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 06:10:10 +0000
References: <20220304070408.233658-1-ytcoode@gmail.com>
In-Reply-To: <20220304070408.233658-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     yhs@fb.com, andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  4 Mar 2022 15:04:08 +0800 you wrote:
> Using strncpy() on NUL-terminated strings is considered deprecated[1].
> Moreover, if the length of 'task->comm' is less than the destination buffer
> size, strncpy() will NUL-pad the destination buffer, which is a needless
> performance penalty.
> 
> Replacing strncpy() with strscpy() fixes all these issues.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: Replace strncpy() with strscpy()
    https://git.kernel.org/bpf/bpf-next/c/03b9c7fa3f15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


