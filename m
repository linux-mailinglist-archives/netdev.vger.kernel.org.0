Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8431526EC1
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiENBER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiENBEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:04:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7218B46BAA4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50881B83250
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E744CC34119;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652487014;
        bh=UAlQDTtW6O6D4vPlV5XSZjFTzFflas7eRf6DK4LNvSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jV7ZvpoNrdiq6B9JdJEKz9oRR7YxlH7DWTHf8djQs82pseSQ8uTQrOhPqqpZ8EDAj
         xMFDb+EIJ8nAjJUZLgLEQW/KEiaJ1DoemW8aDKM67INFTrUTkhNJA9pu6d5TiYolDr
         ROeNiORKAeri45IcR3qwykFu4NzzPNi1K/byWK2ume6OHLgtDMoAxV6n7RCUS6nddu
         F+cMzdyqMlPmdArHiGA9C/yyiw3BT+dX+CpMIE1xxM32lWsKvLPyNPaFGhTpIROvOn
         Iq242B5NgNsGYRyKVcmvogq3RJbTcBLZyLxOs2pMRvS41cyc+c5uHdlHdlrR7NUl1L
         Dllfe8/MD7SEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA1BBE8DBDA;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ice: Expose RSS indirection tables for queue
 groups via ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248701382.14999.4422763087908308129.git-patchwork-notify@kernel.org>
Date:   Sat, 14 May 2022 00:10:13 +0000
References: <20220512213249.3747424-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220512213249.3747424-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sridhar.samudrala@intel.com,
        netdev@vger.kernel.org, sudheer.mogilappagari@intel.com,
        amritha.nambiar@intel.com, bharathi.sreenivas@intel.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 May 2022 14:32:49 -0700 you wrote:
> From: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> When ADQ queue groups (TCs) are created via tc mqprio command,
> RSS contexts and associated RSS indirection tables are configured
> automatically per TC based on the queue ranges specified for
> each traffic class.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ice: Expose RSS indirection tables for queue groups via ethtool
    https://git.kernel.org/netdev/net-next/c/d9713088158b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


