Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DDC4B5386
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355257AbiBNOkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:40:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiBNOkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4034B844;
        Mon, 14 Feb 2022 06:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 499FBB8100F;
        Mon, 14 Feb 2022 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1090CC340F1;
        Mon, 14 Feb 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644849610;
        bh=/7ydwY1ED9vSNUjvEsRCpVUNRQt5eadoOpW6+Glxpr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ahrqnLpLwXt9iPplUQxS5ravd4Kk2Z7dQyh/sq13SRimvfV2XRKENseXLmSWCL2Pg
         xpnMWJ+o3VsMDgQ4u355F1pZHI0fUNGjbM60AJm2oseEmroYH0541hhkq8RHiOfj2+
         Diz5ho0ckF7/K/7eoQe7GyKfBYwQqUSUHaoLdMf/7sm+EfQFhnRzXxKUUgZwkXICkA
         A5jp1DtW02HOUjzf15gOZnAv29b4ojcItqof2T077LR5wKaHe5Kzq1LK8W09F2Vfb+
         0b7+wvrQk1X5JM51U13REz/qTd4CsGGStCIMiFGf6hgh5zOzoUBv+Lu48FPwYnV92D
         a8L3tbYTLTjjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED480E6D453;
        Mon, 14 Feb 2022 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3] USB: zaurus: support another broken Zaurus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484960996.24022.13808721872337302208.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:40:09 +0000
References: <20220214140818.26600-1-oneukum@suse.com>
In-Reply-To: <20220214140818.26600-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregKH@linuxfoundation.org,
        bids.7405@bigpond.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 15:08:18 +0100 you wrote:
> This SL-6000 says Direct Line, not Ethernet
> 
> v2: added Reporter and Link
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: Ross Maynard <bids.7405@bigpond.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215361
> 
> [...]

Here is the summary with links:
  - [PATCHv3] USB: zaurus: support another broken Zaurus
    https://git.kernel.org/netdev/net/c/6605cc67ca18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


