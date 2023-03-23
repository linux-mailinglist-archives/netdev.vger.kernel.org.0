Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04CA6C5E7C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjCWFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCWFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4391F4A7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5836DB81F14
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F057AC433A1;
        Thu, 23 Mar 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548218;
        bh=bSnG8yl/RperUVzU4mA8moPCmew8HXA3w/MnCgmmqRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ESJq7CuLlCwYTm5EPCNF9O6ZA8z4Dy1iolF29kDmHo3qJpE2pIRIyNmivji4IXy3L
         qrmbvY5EFMBjOaIEN1sT8CmqQ8dNckFHdfv3+UMpE0FLkZVT11SzlH+EsKD3m6BO9h
         Uc5hUAynZPEtWeqiIXj6aSN5fC9mTGcX0FobsY0k9X+iDrdgL3PY+XEKzQN99wI55I
         phHodPzoMFKSlc8RxnFkub/PVFL8cJMeFQSBJ5npLUJS60/o+/jS+mdPsCG1tnBjRL
         L9qBJPVu0O+MLjPADELNdusNbRCLH58+B++7sJgLoD6UOIuURajOTFBTtuDF1EcsjD
         mATI2Ni1xPUCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2D8BE61B86;
        Thu, 23 Mar 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] gve: Cache link_speed value from device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954821785.28676.15834719874847752082.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:10:17 +0000
References: <20230321172332.91678-1-joshwash@google.com>
In-Reply-To: <20230321172332.91678-1-joshwash@google.com>
To:     None <joshwash@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 10:23:32 -0700 you wrote:
> From: Joshua Washington <joshwash@google.com>
> 
> The link speed is never changed for the uptime of a VM, and the current
> implementation sends an admin queue command for each call. Admin queue
> command invocations have nontrivial overhead (e.g., VM exits), which can
> be disruptive to users if triggered frequently. Our telemetry data shows
> that there are VMs that make frequent calls to this admin queue command.
> Caching the result of the original admin queue command would eliminate
> the need to send multiple admin queue commands on subsequent calls to
> retrieve link speed.
> 
> [...]

Here is the summary with links:
  - [net,v2] gve: Cache link_speed value from device
    https://git.kernel.org/netdev/net/c/68c3e4fc8628

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


