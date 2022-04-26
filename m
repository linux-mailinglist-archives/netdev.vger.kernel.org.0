Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC00850F683
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344109AbiDZI4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347345AbiDZIvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6402CD0A92;
        Tue, 26 Apr 2022 01:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D926460EC7;
        Tue, 26 Apr 2022 08:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D771C385C5;
        Tue, 26 Apr 2022 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650962411;
        bh=bQ+5P70i0WtQREnFW1rAYAo8fBoIK7QDEbySBRRFQQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VdFnZ9kn7yj/wrQPr36e6fff/EGK3not/II/W0y+qc1pgc62dRvD0XmQUTPTqcsdT
         DlV8ER/LA2AibF005ySJ4c9WaEqL1ITkbEvzOgVVPtfLh0qoTiStY96KosKeHB5UgS
         deT/XYm6DSxPQq5wSaaerT1YeBpGlZzDLm1ahDsXkNmtXcLkB7IYumpcjVUSNYSwvz
         FY2FPsMyCwJmX6jElV2URbUW0zFt/ec3azfVxOdl358UNxuczj2rZDU0MeX92Jz6iY
         J/u8HQGdAgeFUXrrDCYNwdXiQS3yvnoIikOV7Xc1olWZzIAtUKCjnXjhKraFH21rM1
         PqYT/A3mo6yQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1AAE6E8DD85;
        Tue, 26 Apr 2022 08:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net: dsa: ksz: added the generic port_stp_state_set
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096241109.29558.13120003848434431521.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 08:40:11 +0000
References: <20220424112831.11504-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220424112831.11504-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 24 Apr 2022 16:58:31 +0530 you wrote:
> The ksz8795 and ksz9477 uses the same algorithm for the
> port_stp_state_set function except the register address is different. So
> moved the algorithm to the ksz_common.c and used the dev_ops for
> register read and write. This function can also used for the lan937x
> part. Hence making it generic for all the parts.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: ksz: added the generic port_stp_state_set function
    https://git.kernel.org/netdev/net-next/c/de6dd626d708

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


