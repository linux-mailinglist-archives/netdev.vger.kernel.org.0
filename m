Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C82667371
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjALNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjALNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:42:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD5B4915D;
        Thu, 12 Jan 2023 05:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09B17B81E6C;
        Thu, 12 Jan 2023 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F95DC433F0;
        Thu, 12 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673530816;
        bh=Qe/jbMn0nBHOwzU6t6oqDN4NnfrQ1M68uu6858CdlOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WPpNA4xWaKGmpdyjnmOd9lTGO24iATjUrPc+5y+STNAqReI1MdPcGTrA48IeiF5cc
         tHwGf4/cPGolj2DGyktxmJF0eyhrSi2L8/nNTkr2bczI3G/bPokfqyN1CHqyXWV2NS
         OrGsRmu7yAxHBownRukIKYaHHCDOEKsoNT8bhK5IVf4EFlxMrOjkD5llA4KfqDK0Lc
         WD868a2qMkk69Ry+F/G05bfVzVbxh0WHMseUPcEXEwced+fc+AFaL1mV0yZtpFsEhj
         6+f6gzinwdFzSak8hQJjivUTFWVi5cm70gqrOAVe2VH1J9o9vlCn8lzbHgpcwg/IYy
         HzMmmDemtjBcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E2AAC395D4;
        Thu, 12 Jan 2023 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167353081644.12757.14928786482494775013.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 13:40:16 +0000
References: <20230111133228.190801-1-andre.przywara@arm.com>
In-Reply-To: <20230111133228.190801-1-andre.przywara@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 11 Jan 2023 13:32:28 +0000 you wrote:
> The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
> Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
> machines, Microsoft uses a custom USB device ID.
> 
> Add the respective ID values to the driver. This makes Ethernet work on
> the MS Devkit device. The chip has been visually confirmed to be a
> RTL8153.
> 
> [...]

Here is the summary with links:
  - [net-next] r8152: add vendor/device ID pair for Microsoft Devkit
    https://git.kernel.org/netdev/net/c/be53771c87f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


