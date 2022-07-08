Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3430056B9B9
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiGHMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiGHMaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1153331DEF;
        Fri,  8 Jul 2022 05:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93316626A5;
        Fri,  8 Jul 2022 12:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7427C385A2;
        Fri,  8 Jul 2022 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657283414;
        bh=S+17Nac2ZIldkq69SqPt+vSn4AM3hE7u7oO/OCFZ4J8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zsv53VZSKMPej1bgX0gp7hbHP6xEdyTjQJme03bkHZ/iIWxL3tAb60JDYBsepOpZN
         NYasU2ywrGiodX+aSpk5i2/VoKierNlCjsFuAcAAXV14qgu+esLWlBcLc5rIfKJDsl
         /h6Xwa7xw3UZ66OIGNNyUWFdI0OGLd2rd5YwPilVdxDnIpF/RdVkkabhoH5cKETGSl
         PMc8mh9Q6Tkt9AURHiHIzYxZPruSICT0iXbFt6+N4+dZ1fq7i4pPfJyT6OrwYnGDQh
         OlilpM5Xgp/edQSnMthsDz5rXGoMaspMrmo0xQ4Xfq5SDcs47QXAftlO97xcpTxdlt
         92ADNV4Y+CXdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD563E45BE1;
        Fri,  8 Jul 2022 12:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] xsk: cover AF_XDP test app in MAINTAINERS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728341383.9693.13945717406781339916.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 12:30:13 +0000
References: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Jul 2022 13:16:11 +0200 you wrote:
> MAINTAINERS needs adjustment after file moves/deletions.
> First commit does s/xdpxceiver/xskxceiver while second adjust the
> MAINTAINERS.
> 
> Thanks,
> Maciej
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] selftests: xsk: rename AF_XDP testing app
    https://git.kernel.org/bpf/bpf-next/c/018a8e75b49c
  - [bpf-next,2/2] MAINTAINERS: add entry for AF_XDP selftests files
    https://git.kernel.org/bpf/bpf-next/c/d6f34f7f77fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


