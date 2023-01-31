Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B127E6828DB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjAaJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjAaJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E949759
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0440661478
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 642ACC4339C;
        Tue, 31 Jan 2023 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675157416;
        bh=P/t5nLr9faijOL0VHCCe3zhm7vumrNFIqczLO8u7L2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BNsDhTqtQtDmXSKHDke4alCHYD7GK1DRmzi2OYOPHZb3wVTo3mXZ45KvJO/syTrQA
         z6nhpW4AxmvuXq9Di7DkPP3HQEXESVR9CZzE6xWp4Q5SRjDL3xXQx6AFf+PsQ/PtC2
         zEYD3ZZ087g3S558cEeEHE/gov1HUk+RTjbORWz0mwKiIchnhUuIdDMmuKZEofgc+4
         QYs0rlaDHjKv4LUBJcTj3spHsCDCRUq8XM+njMMCMmy1z+fKy9ZoyzMepwDFlPIv3s
         rBIILt2+Ebin1c+nmAzcWsokTY9OrWmkr5fjyzxxxXQmcA1kE9S2bo871qbFMmWuFl
         QHF6ai2Z8A5dQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4878BC0C40E;
        Tue, 31 Jan 2023 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ibmvnic: Toggle between queue types in affinity
 mapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167515741629.26648.10038272468094003278.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 09:30:16 +0000
References: <20230127214358.318152-1-nnac123@linux.ibm.com>
In-Reply-To: <20230127214358.318152-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 27 Jan 2023 15:43:58 -0600 you wrote:
> Previously, ibmvnic IRQs were assigned to CPU numbers by assigning all
> the IRQs for transmit queues then assigning all the IRQs for receive
> queues. With multi-threaded processors, in a heavy RX or TX environment,
> physical cores would either be overloaded or underutilized (due to the
> IRQ assignment algorithm). This approach is sub-optimal because IRQs for
> the same subprocess (RX or TX) would be bound to adjacent CPU numbers,
> meaning they were more likely to be contending for the same core.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ibmvnic: Toggle between queue types in affinity mapping
    https://git.kernel.org/netdev/net-next/c/6831582937bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


