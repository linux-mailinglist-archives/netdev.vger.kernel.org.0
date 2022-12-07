Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D316452E9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLGELC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLGEKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:10:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8003C56553;
        Tue,  6 Dec 2022 20:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2FF261628;
        Wed,  7 Dec 2022 04:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F86DC433C1;
        Wed,  7 Dec 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670386216;
        bh=u43Wrj7LqwbZbNTe/wgV3/vOTBju22GcWv2aBAMaLHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bUVRywHrluPHy+gxWr0IG/U2cJVyVcjJ0YYGTfegZUMxh7E+OJ61Ftldlza9AgR2J
         k/BH8buZostw9sL2873ZpA6fnN02OzeedG7TFY7nZlNKazQVU5G+SovbHAFrpgK4Nj
         X2XiqhkUMPlmMbkTyQbGXVIS1ck/kwQDwBIFn480VOodkO3pU4f0VZ204T+VNb/1b8
         47j+QHCvrPse80WCuxEmbYfqEUDgta5ICPWq/iVcWYntwQ8toKCcCIFehbUX5sjY19
         IipbVI5oBxnUH7uVh1d2lnFj3Cr04nqyxCQ9/sy8JU6aq6J6r9Sef8oq49t3wVH3WO
         2maieB8+dVFCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11A7AE49BBD;
        Wed,  7 Dec 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: xsk: Don't include <linux/rculist.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038621606.4717.104553106066207739.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:10:16 +0000
References: <88d6a1d88764cca328610854f890a9ca1f4b029e.1670086246.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <88d6a1d88764cca328610854f890a9ca1f4b029e.1670086246.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sat,  3 Dec 2022 17:51:04 +0100 you wrote:
> There is no need to include <linux/rculist.h> here.
> 
> Prefer the less invasive <linux/types.h> which is needed for 'hlist_head'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Let see if build-bots agree with me!
> 
> [...]

Here is the summary with links:
  - net: xsk: Don't include <linux/rculist.h>
    https://git.kernel.org/bpf/bpf-next/c/e9b4aeed5669

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


