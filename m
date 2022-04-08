Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229B04F8DBA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiDHEMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiDHEMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755BD1EA5EA;
        Thu,  7 Apr 2022 21:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 072E561E2B;
        Fri,  8 Apr 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E0B2C385A9;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649391012;
        bh=vRmX5iSvgC8E4LHT51fSLE+1+UM0pMS536EIpWDch8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzTr1ddgzCvs0RDqYZbtX3XDQWtdRkqPjFTen7+kuPcnfoOnFZCMjJEFkMva41kGI
         yxYvoGr6zTFlvw2Ise3EYtMG31lZRhjY20886YksHYV+EsrmLhGiU9Wv8KUHKKUJ1a
         TNErkqv5n7fnBU9YREWk5DmUHcI4bCFEpGpuionOIA2Y9Fq0N6grNqUBP+8TbPHYAT
         AKyMuN563NlV73f5/NHjiQj6LlpmQ8jVZTzjv67SvMRJdIUKgxKu8cvxw+Uphd0Sgj
         WHJQnV/yaf8jCivoVN5Ary4MOYSiyCxd8gfFOzuLVRo2yf+JD7DcqtKTPcDqfFIx5g
         +tQNZ7WBRStBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AE0DE8DD18;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] storvsc, netvsc: Improve logging
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939101217.29309.15271831971294215849.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:10:12 +0000
References: <20220407044034.379971-1-parri.andrea@gmail.com>
In-Reply-To: <20220407044034.379971-1-parri.andrea@gmail.com>
To:     Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 06:40:32 +0200 you wrote:
> Two small (and independent) patches to augment and "standardize" the error
> messages.
> 
> Thanks,
>   Andrea
> 
> Andrea Parri (Microsoft) (2):
>   scsi: storvsc: Print value of invalid ID in
>     storvsc_on_channel_callback()
>   hv_netvsc: Print value of invalid ID in
>     netvsc_send_{completion,tx_complete}()
> 
> [...]

Here is the summary with links:
  - [1/2] scsi: storvsc: Print value of invalid ID in storvsc_on_channel_callback()
    (no matching commit)
  - [2/2] hv_netvsc: Print value of invalid ID in netvsc_send_{completion,tx_complete}()
    https://git.kernel.org/netdev/net-next/c/26894cd97116

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


