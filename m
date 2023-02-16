Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5FD698A3F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBPBuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPBuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E67042BDB;
        Wed, 15 Feb 2023 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E92361E4D;
        Thu, 16 Feb 2023 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59D5FC433D2;
        Thu, 16 Feb 2023 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676512217;
        bh=L8f3f2EA/svh/8Eme7QedwXcy4LnFCupfcem6P7rDbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/mSXHifmw6HZ9c6boZ6sGUe74VZenYL3ZfgyKCpwKkTo5DEqn+o73iYfM1q9iBgw
         2ozvCKNr4knOMMleTlmwySzB/tDM2SQ8dt8wAz2rcZFL+05fc+1CWCF03GccImEOef
         YIM4J6Tn7chlW/cbOSiBGlnlUL0gCoEv/1UpLfipcGhXzvuIync+IUMTFvcgzTR1+z
         yxUnteB0XejBMt9d0dZlR8wvPeTjDMLX5kPLqFhEidDkGKKFxG/bWl5fznZNlMr8uf
         NTqUTI8iNXtMuDsPpLmOcdjkW0ZrBoeNclFEeGsnvWKAXBtLGrvlVPsKPc13hcT0Vt
         CG9My8r1AQLZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E559C4166F;
        Thu, 16 Feb 2023 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4] bpf,
 test_run: fix &xdp_frame misplacement for LIVE_FRAMES
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651221725.16690.663326192912739439.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 01:50:17 +0000
References: <20230215185440.4126672-1-aleksander.lobakin@intel.com>
In-Reply-To: <20230215185440.4126672-1-aleksander.lobakin@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        toke@redhat.com, martin.lau@linux.dev, song@kernel.org,
        hawk@kernel.org, kuba@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Wed, 15 Feb 2023 19:54:40 +0100 you wrote:
> &xdp_buff and &xdp_frame are bound in a way that
> 
> xdp_buff->data_hard_start == xdp_frame
> 
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
> IOW, the following:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
    https://git.kernel.org/bpf/bpf-next/c/6c20822fada1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


