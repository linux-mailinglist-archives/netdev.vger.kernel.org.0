Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625F44E2950
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbiCUODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349040AbiCUODR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3E040A33;
        Mon, 21 Mar 2022 07:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1DDB816DC;
        Mon, 21 Mar 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FF62C340F3;
        Mon, 21 Mar 2022 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871211;
        bh=mK5teC6+zPKnFcJwOGzftb1WQnkYYL5SXQ2iHcLb02Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ym2t4n+Bl/qIa1xdynVaIScKWfMvapwT1vyF1sygerHBs0d0gMtgkbnbOXlYVzFPh
         D/0Y/UMobkUYQoh8kXEYP9obDpTdi8/F+VuGnL5ZTuYZYmjuJecnpcBI8lOVRO28ln
         2sOgmnxfuhP6bIfETOv95XbzTWPbv6hdpodBPVDYD0kAjnIq0qEMP9jAjKQZ0ZvbbA
         fNb5NcGF7GInXkH+7tashI+imHq9UkbkMGBBpdf9SmlXsNfRnO0pIfUEfUTAGabU8q
         6fsNLtfnDLHR72t6DLPPWy8sggY5CaYC2GwTcKnXvOKhZP91znmH+9cish2YHRhepg
         +D0XQ4qR3hSPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56C84EAC09C;
        Mon, 21 Mar 2022 14:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Simplify check in btf_parse_hdr()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787121135.8124.13693033583396195102.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 14:00:11 +0000
References: <20220320075240.1001728-1-ytcoode@gmail.com>
In-Reply-To: <20220320075240.1001728-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, 20 Mar 2022 15:52:40 +0800 you wrote:
> Replace offsetof(hdr_len) + sizeof(hdr_len) with offsetofend(hdr_len) to
> simplify the check for correctness of btf_data_size in btf_parse_hdr()
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/btf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: Simplify check in btf_parse_hdr()
    https://git.kernel.org/bpf/bpf-next/c/583669ab3aed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


