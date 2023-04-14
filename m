Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A426E2AF0
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDNUKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNUKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BF919AA
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 843F564A1C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 20:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD892C433D2;
        Fri, 14 Apr 2023 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681503018;
        bh=xmUu2JqZMFOlLcPA/JQMjykepcPG7LP85FIyve52L64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeA4FQkEfWfq/MprYVnlNc+hmoRBpifqVVUpOKOhsZZQLQxglnkkr4Fkh/tvHEpza
         vlMBRMvJF03j163/mJ2OqqLZqZF03zqb3YpHC2IjLj835paNC5T97L0p+ttn9l4wAh
         Cct8H1kYf1GzgjiUjrOD6+ck+LKOvBT9roOZ12tA2O1p1AX1VO0nmhq0mZBJRYfmIo
         Q0MbBcYKCp4o+oj2kjnQ1DFIeMAm54tYf9lDr3OAfUcrdBArXLu00EcdU9drUlO/u9
         j3YC+Ls7gFPD6MzvUw6SiA6H81wKXfVOBWLqIu6qGTGEwVjYrWE+AeNcPDYGVEDwjH
         5E1RNNh2iRuIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1B03E52446;
        Fri, 14 Apr 2023 20:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iproute_lwtunnel: fix JSON output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168150301879.15322.7106905942925387097.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 20:10:18 +0000
References: <20230414194841.31030-1-stephen@networkplumber.org>
In-Reply-To: <20230414194841.31030-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, uablrek@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 14 Apr 2023 12:48:41 -0700 you wrote:
> The same tag "dst" was being used for both the route destination
> and the encap destination. This made it hard for JSON parsers.
> Change to put the per-encap information under a nested JSON
> object (similar to ip link type info).
> 
> Original output
> [ {
>         "dst": "192.168.11.0/24",
>         "encap": "ip6",
>         "id": 0,
>         "src": "::",
>         "dst": "fd00::c0a8:2dd",
>         "hoplimit": 0,
>         "tc": 0,
>         "protocol": "5",
>         "scope": "link",
>         "flags": [ ]
>     } ]
> 
> [...]

Here is the summary with links:
  - iproute_lwtunnel: fix JSON output
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=0f32ef97babc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


