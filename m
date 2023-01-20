Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332566755CF
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjATNaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjATNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:30:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D765EC41C4;
        Fri, 20 Jan 2023 05:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00F10CE2481;
        Fri, 20 Jan 2023 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00BCBC433A7;
        Fri, 20 Jan 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674221417;
        bh=14qKjVmYiRnKW0YAPYLimUZIu9YatqU1A6D8IUSQe5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ncRTeC6fOlPl3C+5YMzwqfkOEZaMuTnGVG3aE/S9pcz0vX3uL1IbnOVmP6sDY6S33
         vph2rSe1qN5jdfDbFDsbwkXbWRnFyc6h43EweQMYFsTYEXg6sa5jdfm0loBQ6bu+fW
         4qJHUYWHVjPtKf4hO6+egwjlMuwiqcFA2Wreb5IRTB3vPej6fjwjh55eCh/129vQpy
         wqM7pji2HF8FRhvJbjZd0Qds1oHBXcp2IcIu23tEWJsOqGxrtcIJ13yK+C996bEr2z
         a4QgkJI5Gp63zNrSG7ozTPYZ0o7ZKnInajiwi7di9lzUKcx0VvCq1O3Piza1HfleGh
         LB7s1zkE2JWUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF572E54D2B;
        Fri, 20 Jan 2023 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] ACPI: utils: Add acpi_evaluate_dsm_typed()
 and acpi_check_dsm() stubs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167422141691.18652.6742541025937587197.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 13:30:16 +0000
References: <20230119191101.80131-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230119191101.80131-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     anthony.l.nguyen@intel.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rafael@kernel.org,
        lenb@kernel.org, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 21:11:00 +0200 you wrote:
> When the ACPI part of a driver is optional the methods used in it
> are expected to be available even if CONFIG_ACPI=n. This is not
> the case for _DSM related methods. Add stubs for
> acpi_evaluate_dsm_typed() and acpi_check_dsm() methods.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs
    https://git.kernel.org/netdev/net-next/c/1b94ad7ccc21
  - [net-next,v2,2/2] net: hns: Switch to use acpi_evaluate_dsm_typed()
    https://git.kernel.org/netdev/net-next/c/498fe8101112

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


