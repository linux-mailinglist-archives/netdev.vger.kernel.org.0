Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBC76A09DA
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjBWNK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbjBWNK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740C051FBD;
        Thu, 23 Feb 2023 05:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545DE616E3;
        Thu, 23 Feb 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A588C4339C;
        Thu, 23 Feb 2023 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677157817;
        bh=2eLky8gBvHxAxv06XlZQKw9omFNkrqf9K6xgZWiZpM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XV5Yz+SRsb6OBSPA2u49bIAcK6tGukmivybif/mEFu0I6AG3ANjs7isBmWND/bZFc
         BkcgrGI7+vPj/for8w2IVf/Vy8sfljY2YPMRLhi/qu36n71W1haq3Clnqv8xK2zSWF
         O+1YanUj5NqKa86EdPDB/rjINoQYPKAtwaxZQG3lvK3mL4WA5Bp4Wv5C915m7WRryA
         wkFhRZdLHBI+XoHXIV0OwsVdOZdl0JDP0wifo9gWM4+4Eia6FkYWWWgLbAp9/17oGC
         CiCjXr7iyIxHcRDM211GnAIasFdS8FSwr3XcCGW03rL96hLbqAXzYi6Booio2/Rsja
         b9dW9lEntoS9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 446AAC395E0;
        Thu, 23 Feb 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] octeontx2-pf: Recalculate UDP checksum for ptp 1-step
 sync packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167715781727.23818.4267546312113969730.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Feb 2023 13:10:17 +0000
References: <20230222113600.1965116-1-saikrishnag@marvell.com>
In-Reply-To: <20230222113600.1965116-1-saikrishnag@marvell.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, hkelam@marvell.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 22 Feb 2023 17:06:00 +0530 you wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> When checksum offload is disabled in the driver via ethtool,
> the PTP 1-step sync packets contain incorrect checksum, since
> the stack calculates the checksum before driver updates
> PTP timestamp field in the packet. This results in PTP packets
> getting dropped at the other end. This patch fixes the issue by
> re-calculating the UDP checksum after updating PTP
> timestamp field in the driver.
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet
    https://git.kernel.org/netdev/net/c/edea0c5a994b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


