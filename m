Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDFF5A7696
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiHaGaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiHaGaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC862DAB9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6591D61777
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9E86C433D6;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927417;
        bh=kdSr5DEoAp51XIXOq47KlfgrWrrSxM7wdAukj5UK2k8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQvwBSpwL2TZbuLNXLf/+i4qOKM2a0IoGxKvdQmuXdSG7EPFiBGf0w9DZBzxreDhZ
         t+Da8CPBmBHT3zh+QEsVSvq7t68oFopJLUdRZGx0ty5Dh5zB9E4+G6o71kw0rx39IQ
         AHzJwS/xFxfU+SG0vMRtjPykOuV+zaORol5RmqUWTPekVQHWlioBfcPQpM/wA9r3B0
         LsKLFb4I+alnxT3+6rIkgBImmOdvFRhTgZxbl/7qae0wzPfYmWL1nTvEY8liAwkonU
         6rAjr5ertxhiKe9se/Bh+UTtHw4d3gXtzgwuGp+gj4JySc7g0frI9ELrTvGgrACy5n
         UYa8AAylj+6bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B937CE924DB;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: bonding: clarify supported modes for
 tlb_dynamic_lb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741775.4297.3056038056426596006.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:17 +0000
References: <20220826154738.4039-1-ffmancera@riseup.net>
In-Reply-To: <20220826154738.4039-1-ffmancera@riseup.net>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 26 Aug 2022 17:47:38 +0200 you wrote:
> tlb_dynamic_lb bonding option is compatible with balance-tlb and balance-alb
> modes. In order to be consistent with other option documentation, it should
> mention both modes not only balance-tlb.
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  Documentation/networking/bonding.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] Documentation: bonding: clarify supported modes for tlb_dynamic_lb
    https://git.kernel.org/netdev/net-next/c/fa8724478e64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


