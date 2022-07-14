Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3C457420A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiGNDuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGNDuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4BA2655F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F68B81647
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DBD4C341C6;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657770614;
        bh=Pv/5Y3mCyttI/xdo5My8rlZf+KkrZH/4BTDbaMk91+k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cau9BlhfMVtIG0fMNgiOoI3sGdVbMsZSyhKxs1M2rsZp1CB5Z/nfuKY7B41ff4aZm
         kOdHuxgWsTrk0HQZUlx6fh/i9VFH0ZO9RWojBzXEk7xl58FuOo5+U50ASD/cZ6REjj
         UFU4EZ+LL3lrJts7nRstav2Rzmhgq0dVfUztjnKgYbFf7e1QgobGZRJiLMhr3H1jT/
         IuBpmCQEb+u7NdbgVZC0Zp2VClkmXTdsYSPtNU92OAnTOhhOQco9qHS7mSXZiMkJ/+
         aREhIac0rNcLDI6G/AOyewloAJPWl1/kqj1SyRoXgA4vfIm0bHOJDvhbPieVfoa5Am
         +nLKz6DZoW9yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48925E4522E;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] sfc: fix use after free when disabling sriov
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165777061429.21676.1244117148612130085.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 03:50:14 +0000
References: <20220712062642.6915-1-ihuguet@redhat.com>
In-Reply-To: <20220712062642.6915-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        sshah@solarflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        yanghliu@redhat.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Jul 2022 08:26:42 +0200 you wrote:
> Use after free is detected by kfence when disabling sriov. What was read
> after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> and later read in efx_ef10_sriov_free_vf_vports, called from
> efx_ef10_sriov_free_vf_vswitching.
> 
> Set the pointer to NULL at release time to not trying to read it later.
> 
> [...]

Here is the summary with links:
  - [v2,net] sfc: fix use after free when disabling sriov
    https://git.kernel.org/netdev/net/c/ebe41da5d47a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


