Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1CD6C7B15
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjCXJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjCXJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8611CBC6;
        Fri, 24 Mar 2023 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06F4EB8227A;
        Fri, 24 Mar 2023 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FA1EC433D2;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649620;
        bh=cjTDtwWsOyggPgElDsrJ5q9PiNbs6LROBoekyo0atzE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bIzT5xnjSnyDE4LlqcTufV+OyaebYfJJYrdUm86hDx0zE9nxBLVf9DbfDzYQldQOy
         w6ZhqBD3C5rkzZ8tMkqNa3PHVYmtFp534L7UQhQj7dKo8yPh84ngpeEw1/WhFECEfH
         hoCfcu7ebsOF319PPegjWlDdNW2pymiEtV0cnt0IP3jaEo381FZ7g0EJk/6b2d1jVK
         bbU82v4qqTwWOkhY80KzmjcqQhCVGHAd2Lukef0VMdB2VJJ6JEZUlF9EWGkgyML01c
         /4As3Eg+dYFVYPbUO3RWKORL1dDUluRw2GUuLak0TEnsncgmtSrWoidXdHalwCVyD+
         o/aECAPNoAWog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C902E4D021;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ism: Remove redundant pci_clear_master
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964962043.21111.16470870678286692653.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:20:20 +0000
References: <20230323120043.15081-1-cai.huoqing@linux.dev>
In-Reply-To: <20230323120043.15081-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 20:00:43 +0800 you wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> [...]

Here is the summary with links:
  - net/ism: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/c85bd3dacc80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


