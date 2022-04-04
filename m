Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B344F0D29
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376773AbiDDAMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiDDAMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:12:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FF06416;
        Sun,  3 Apr 2022 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952BF60FEC;
        Mon,  4 Apr 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E48ACC340F3;
        Mon,  4 Apr 2022 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649031012;
        bh=Z9X249NGSLfcozOTrs8dqrPsOAjfMVEpU43qN71Dvow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZbnrxaoFWg0cPz5MJ9/WcfhMz5XaAaiHmNLnuIE8gUcsla93h1QGi9XAZeVyFMZj+
         p7g1slYvSvL0psneA2awXtTA9ehkPn1OS9gk1wjTVgIbJIA5JiZsxyR5NF4HINEGMt
         oAYXF6O5Dog/UC9T1dbBOzEUYSPzvOxwavNa8zM7ob7l/7WqF/WnLKuXxEuV2LCpiI
         brP5FWUaclQClLeQbqLyY3Dd3FMxdncInkjDELeQj7nN1C4yBV6suX138VReqOnZVz
         XijO0vg26UXsj28JPWvq3OVOBq23dK6Cnw1T+nfkBfolLGnsZWEZpUv6K7tXMKFI9U
         Mh4EbqSrkUrXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B80C3E85BCB;
        Mon,  4 Apr 2022 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bpf: correct the comment for BTF kind bitfield
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164903101174.15203.3501993959808666885.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 00:10:11 +0000
References: <20220403115327.205964-1-haiyue.wang@intel.com>
In-Reply-To: <20220403115327.205964-1-haiyue.wang@intel.com>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Sun,  3 Apr 2022 19:53:26 +0800 you wrote:
> The commit 8fd886911a6a ("bpf: Add BTF_KIND_FLOAT to uapi") has extended
> the BTF kind bitfield from 4 to 5 bits, correct the comment.
> 
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
> ---
> v2: update the btf.h under tools directory.
> 
> [...]

Here is the summary with links:
  - [v2] bpf: correct the comment for BTF kind bitfield
    https://git.kernel.org/bpf/bpf-next/c/66df0fdb5981

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


