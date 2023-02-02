Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD8D687541
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjBBFdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjBBFdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:33:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ADD7BBEC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8268261556
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA7ADC4339B;
        Thu,  2 Feb 2023 05:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315816;
        bh=QYD1sGoC74tXozvEkeTC83S/C7tMffE37VnhthrOlHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JSfYT+jx54uikimOQhbYZxC8T/PJu5avWZd5YkMtAzfNU+LkdMkp8DRymRkjP5ep/
         QsWbHiIRYf455+yX82BcdI85ebhzd6tGyKD8vY99lhVg5KjmKAo0AvfeCImokrEwWe
         ywIjmHMnM8kjz2QWRMfYWl68AQrADfh2Mild8AjWezU72o0N+ERL2P3/xVDoPKOH4L
         kLczhfCgon6LTze79tYp7SGaR8RNgIPjNVCutHFfGXgK+aDS/aqYR8oMmAU6NLiWaY
         IDa7BgfaUqobPnNIG4tYytguTsHClFv2Feq5+XbOsozsx9Z9XLiU6r9Fwf7jbMCNfz
         X+V/c+bd0xYew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD416E4D037;
        Thu,  2 Feb 2023 05:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igc: return an error if the mac type is unknown in
 igc_ptp_systim_to_hwtstamp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531581677.11250.1269373996432410740.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 05:30:16 +0000
References: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, trix@redhat.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, vinicius.gomes@intel.com,
        simon.horman@corigine.com, sasha.neftin@intel.com,
        naamax.meir@linux.intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 13:54:37 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports
> drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
>   '+' is a garbage value [core.UndefinedBinaryOperatorResult]
>    ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>    ^            ~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net,1/1] igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()
    https://git.kernel.org/netdev/net/c/a2df8463e15c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


