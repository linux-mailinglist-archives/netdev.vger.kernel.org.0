Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD66F5080B6
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 07:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348862AbiDTFxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 01:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359429AbiDTFw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 01:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C70DB864;
        Tue, 19 Apr 2022 22:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A237161776;
        Wed, 20 Apr 2022 05:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE1CEC385A1;
        Wed, 20 Apr 2022 05:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650433811;
        bh=/+U+gKD1f49TgqriF1wxYhDRqEV/GkSfbSwhfHIPWUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CbcKD81xuskVM6n7374T5uTjSsnAUgTGBo/oKpeOxbrLlKstCh75aPK9hLROkYrhF
         9ohJlet33NsMQ+JCHLHRQ48emiDKbT/Wo3IFOs+2s/bfU8vjkdUPmpqSJm3dqaYxy8
         MJBS4mnMxITU2LTyxFWxBP3mwQ3fIkIJcp9T6FFx0p/NU3IbfTGvDL6TVM8wMDFUGd
         rbLER66azoTi4CnUccQ8gBgiKsN0pS7w3BbTKwKqMThQmSZmVoOdJe/2R5zkMzoTQ1
         5rnode6Vm60n/XPhS4vd50Gu9mXBHbckv6AkU8pUN1h+FmOWvYdJXgMhAMxg2Tl1Tj
         +RpZe9b6NwFCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DC4AE8DBD4;
        Wed, 20 Apr 2022 05:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/2] Support riscv libbpf USDT arg parsing logic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165043381164.28808.5094554750645072306.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 05:50:11 +0000
References: <20220419145238.482134-1-pulehui@huawei.com>
In-Reply-To: <20220419145238.482134-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
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

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 19 Apr 2022 22:52:36 +0800 you wrote:
> patch 1 fix a minor issue where usdt_cookie is cast to 32 bits.
> patch 2 add support riscv libbpf USDT argument parsing logic,
> both RV32 and RV64 tests have been passed as like follow:
> 
> # ./test_progs -t usdt
> #169 usdt:OK
> Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/2] libbpf: Fix usdt_cookie being cast to 32 bits
    https://git.kernel.org/bpf/bpf-next/c/5af25a410acb
  - [v2,bpf-next,2/2] libbpf: Support riscv USDT argument parsing logic
    https://git.kernel.org/bpf/bpf-next/c/58ca8b0572cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


