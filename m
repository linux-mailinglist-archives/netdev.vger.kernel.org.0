Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4151D574DE2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiGNMkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbiGNMkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891F257E3F;
        Thu, 14 Jul 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45D5FB824E7;
        Thu, 14 Jul 2022 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBD4DC3411C;
        Thu, 14 Jul 2022 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657802413;
        bh=FdVTZ5DW4oVoc//xaUHg2dn2UuyDn6PS3qa0VZztxDw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/N+9x21WekeXEZeCAJ+DYDIMytDxWpmulfbeCDQ0rMHWqhv3Av1ASFY5ORUCYcJb
         ZBSS3ym04K7JxR1AXho92pdMRYMpNzmL0EfqqsyR9sJQcrHv8Ev+oWlAMG/fi66yM/
         H5Mh55fML4aE0DEiR/Pn5z1phFP57re2SpoEjZvn6IRRg7ED0GDUdru9ltTc1Q2DEo
         qNw0bA0O9qqITC+88VKv0JTSLw1Ty4vHJOsrEgSGUMjU0G7zkVF/oySAIjhqP7H8C1
         x51bzMRhoJCTC/KsE/iSoKCloMYbXdD+B3zGNR7TPQAH6mZUfmfoFaSoBvYsjRiQM5
         DvpqyBxJSGoqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C33CE45225;
        Thu, 14 Jul 2022 12:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: atlantic: remove deep parameter on suspend/resume
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165780241363.16224.10800980406079530164.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 12:40:13 +0000
References: <20220713111224.1535938-1-acelan.kao@canonical.com>
In-Reply-To: <20220713111224.1535938-1-acelan.kao@canonical.com>
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, labre@posteo.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 13 Jul 2022 19:12:23 +0800 you wrote:
> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> 
> Below commit claims that atlantic NIC requires to reset the device on pm
> op, and had set the deep to true for all suspend/resume functions.
> commit 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
> So, we could remove deep parameter on suspend/resume functions without
> any functional change.
> 
> [...]

Here is the summary with links:
  - [1/2] net: atlantic: remove deep parameter on suspend/resume functions
    https://git.kernel.org/netdev/net/c/0f3325076038
  - [2/2] net: atlantic: remove aq_nic_deinit() when resume
    https://git.kernel.org/netdev/net/c/2e15c51fefaf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


