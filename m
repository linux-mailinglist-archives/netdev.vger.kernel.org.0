Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2072B4C6E30
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbiB1Nbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiB1Nbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:31:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD95B32EE5;
        Mon, 28 Feb 2022 05:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B369B80D90;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16CE9C340F0;
        Mon, 28 Feb 2022 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646055058;
        bh=/VuYTTGgeEib3boM9Ub2hTNazbf2SqMji6n9B3orojI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RxTGsogK/V7McELULdz3MvlwygpAWPsnAc+UpNS4QL229/0eUVRAtlYWh1jUCjahn
         1u6LXGYmz+LfiW03HZSJ+LgHz+pESJgYX9qCZXh7FAFch9V4z1mfGm4Vq1cOXc4Cjh
         tCi2YLlkNAwZxbzEcpzdtWIBkQn/2xsHls3wTO7fN33szxMQWMRsDjS4WM38PSgIgu
         kvxDXk3J+JFTNaZ34G7aj4Z6srx3SAACQJjh4MdJtLvF/9DYOSo6U8jUWljr3Mws2q
         WJde7W6im2prdC9xj/5XTnvviksR43wU6sq+EnKnx3CECE+GvIcDMagtWWZVFqem9G
         I/q38MwD5qH+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE84CE5D087;
        Mon, 28 Feb 2022 13:30:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: add config to allow loading modules with BTF
 mismatches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605505797.13902.1254314206143134404.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:30:57 +0000
References: <20220223012814.1898677-1-connoro@google.com>
In-Reply-To: <20220223012814.1898677-1-connoro@google.com>
To:     Connor O'Brien <connoro@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        shung-hsi.yu@suse.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, msuchanek@suse.de
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

On Wed, 23 Feb 2022 01:28:14 +0000 you wrote:
> BTF mismatch can occur for a separately-built module even when the ABI
> is otherwise compatible and nothing else would prevent successfully
> loading. Add a new config to control how mismatches are handled. By
> default, preserve the current behavior of refusing to load the
> module. If MODULE_ALLOW_BTF_MISMATCH is enabled, load the module but
> ignore its BTF information.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: add config to allow loading modules with BTF mismatches
    https://git.kernel.org/bpf/bpf-next/c/5e214f2e43e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


