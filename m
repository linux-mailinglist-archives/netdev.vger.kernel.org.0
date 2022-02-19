Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C957B4BC564
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiBSEuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:50:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:50:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B75650B22
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEDA2B82711
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BEACC340ED;
        Sat, 19 Feb 2022 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645246217;
        bh=lD4aFRCxvz9IKbx2fbaWfQ+3Ga6cjYt4LLxZE8waAzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ho54WycE5DY2X7IGoeKrReBjh84jcFruAxB3A7QgiJMdR9uMX2S0RLM6pBQ5MAHFJ
         CV+JLLGHr3IVu3p3PwQe8V7wQnqBGrUCmwKJtbbIsyiEdDib/Vyd9TEX/A167L3QhQ
         xWM6pMzePCD9raqdjGlD0vJFB5eLata7DFVKbjZsd2vEZ8YSWUhovgp0Sq3IyoLmGq
         1bzqLafXwp4MqsZPTGLlDX635UzEZF15sOLfJdLm8jnhwOqibDy2x0I8l69+hjz0JK
         i6QifhJ4pSmCAkUswhVy7i8C9RpEX34UX9vd3qc8lE+PxZlvzRs549DQgb9zAjMNqs
         d0pMqA7nlOr1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50F95E7BB08;
        Sat, 19 Feb 2022 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: rmnet: Update email addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164524621732.9384.1040209812586107451.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 04:50:17 +0000
References: <1645174218-32632-1-git-send-email-quic_subashab@quicinc.com>
In-Reply-To: <1645174218-32632-1-git-send-email-quic_subashab@quicinc.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        quic_stranche@quicinc.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Feb 2022 01:50:18 -0700 you wrote:
> Switch to the quicinc.com ids.
> 
> Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
> Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] MAINTAINERS: rmnet: Update email addresses
    https://git.kernel.org/netdev/net/c/ba88b5533728

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


