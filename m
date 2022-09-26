Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C9B5EB216
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiIZUa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIZUaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACB5870A1;
        Mon, 26 Sep 2022 13:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCBF161323;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E92BC43470;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224215;
        bh=WNvu7r06OOPub76CStMjE0RI61MQ92smDFOOA/AjRAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hJHUe4fTFE+XLzktGnAYCcu+6axVqhucN0tg/BmKNYGisEOqkSu7bb3Aqbh7QJHa8
         EbIddE394pvbP3/gRGoF0/TWG9Wn6tIoosdUoxMCSI0lX8cqtv1gErj+3wxz4VYYBR
         aLzmZK1n0bHY2J1JDCefWJPl8FhGvvurtx/CzXyVWtzbP8s6TViVnFXFKKPtCZwOmM
         H6VTBJNb55CNHrKW7iv+vDSaljNOk8kyJ9lmCFds2IXPc7dUVPVW3BrrQH2SN88JaP
         mshOvrtADNSYWaIlzJ6ROBQeCMpHJh8hLjpV/JiuKs0Ax8tFk4Hwz2gDmjaxvJ04z8
         Zt30WBpFkHtyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F08ABC070C8;
        Mon, 26 Sep 2022 20:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: fix missing unlock on ETHOFLD desc collect
 fail path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422421498.13925.11665049559919706317.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 20:30:14 +0000
References: <20220922175109.764898-1-rafaelmendsr@gmail.com>
In-Reply-To: <20220922175109.764898-1-rafaelmendsr@gmail.com>
To:     Rafael Mendonca <rafaelmendsr@gmail.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rahul.lakkireddy@chelsio.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 14:51:08 -0300 you wrote:
> The label passed to the QDESC_GET for the ETHOFLD TXQ, RXQ, and FLQ, is the
> 'out' one, which skips the 'out_unlock' label, and thus doesn't unlock the
> 'uld_mutex' before returning. Additionally, since commit 5148e5950c67
> ("cxgb4: add EOTID tracking and software context dump"), the access to
> these ETHOFLD hardware queues should be protected by the 'mqprio_mutex'
> instead.
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: fix missing unlock on ETHOFLD desc collect fail path
    https://git.kernel.org/netdev/net/c/c635ebe8d911

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


