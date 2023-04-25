Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2935C6EDE83
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjDYIu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjDYIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845E1702;
        Tue, 25 Apr 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F586275C;
        Tue, 25 Apr 2023 08:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D264C433EF;
        Tue, 25 Apr 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682412619;
        bh=/cLF+9aK7pkKE3sHXgk7GQ2gkH1G4BF/ktLi5abJ6PQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aaFtEjqIwjwBjxr6D6kKkytM4wtjmrxFdLNEOD9w8yfec1BIVGSmiLd1c9afhIi58
         U3BKIPlr2F5kdToTNGaAFeQSLnZErLy70THBiF7y7PdsFhyPjZYux+OgOG1yfzHAaJ
         WAUWcAaClCOeAnLh3wwEryCwp1JQHkRnJWNUXfcLUFk9IZ5sXNcfOD/Y5UUkMxQOcU
         EHFi8DTxx0k5jq/sBYPkh2zrcEvFFGr8gdnekJfeytTiYm4tUVU7ck4LuYY5UmV2bJ
         aYSFFSh2fGxk2YGjowJLBoJtkZW7EfevUrihlceypULGbs3CH6TZzArWIShBlaOTaL
         hFSRapkuRI+AA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4F5DE21ED9;
        Tue, 25 Apr 2023 08:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] net: amd: Fix link leak when verifying config failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168241261893.1225.11201796847650893473.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 08:50:18 +0000
References: <20230424152805.188004-1-gangecen@hust.edu.cn>
In-Reply-To: <20230424152805.188004-1-gangecen@hust.edu.cn>
To:     Gencen Gan <gangecen@hust.edu.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hust-os-kernel-patches@googlegroups.com,
        dzm91@hust.edu.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 24 Apr 2023 23:28:01 +0800 you wrote:
> After failing to verify configuration, it returns directly without
> releasing link, which may cause memory leak.
> 
> Paolo Abeni thinks that the whole code of this driver is quite
> "suboptimal" and looks unmainatained since at least ~15y, so he
> suggests that we could simply remove the whole driver, please
> take it into consideration.
> 
> [...]

Here is the summary with links:
  - [v5] net: amd: Fix link leak when verifying config failed
    https://git.kernel.org/netdev/net/c/d325c34d9e7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


