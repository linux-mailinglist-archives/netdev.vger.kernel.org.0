Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD3650C27
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiLSMuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiLSMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D4610058
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 04:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D92AB80E13
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D16AC433F0;
        Mon, 19 Dec 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671454216;
        bh=ODt7m5fFkLUibUGmZ07IUvaolox/rGuK7/hvOCL8SXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tx2F+bib7kBOMijsTjNi2oXoChuKyjdKYQr1QtO+olrxa1atfc7gAaXLNlugGgxd5
         nG7yHajReYpShx6KCsbSfCUN9r94zhKnHF3haB9OQ5ItrNaw5UL9C+V+IcTtPzJz82
         SaG4+5XYAcFE/Uv53QRPBzvj+oZvbO8iJ1W2hD1KMSSxVG3YJHz2qL0aEuH94AiyOE
         /aZDhZ4l4gDBhsOKnNELRGFe+et1wQBDHBv0y76fCZY62tMQDhZeDHzeGrth735ucf
         k49cXSA/7YFWprkZW85vmnZ8eu+IspczakcJNjMqc2LBbnKY9bB73e8kPJw7OX+PSl
         dgrf6kgcovBBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02BBBE21EF8;
        Mon, 19 Dec 2022 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: serial: Fix starting value for frame check sequence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167145421600.10746.10337384652720939675.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 12:50:16 +0000
References: <20221216034409.27174-1-jk@codeconstruct.com.au>
In-Reply-To: <20221216034409.27174-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, harshtya@google.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Dec 2022 11:44:09 +0800 you wrote:
> RFC1662 defines the start state for the crc16 FCS to be 0xffff, but
> we're currently starting at zero.
> 
> This change uses the correct start state. We're only early in the
> adoption for the serial binding, so there aren't yet any other users to
> interface to.
> 
> [...]

Here is the summary with links:
  - [net] mctp: serial: Fix starting value for frame check sequence
    https://git.kernel.org/netdev/net/c/2856a62762c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


