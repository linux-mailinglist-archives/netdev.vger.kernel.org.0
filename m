Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2583B35C2
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhFXScg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232671AbhFXScY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 465FE613CA;
        Thu, 24 Jun 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624559405;
        bh=UMTLdBRRTHt6zFsJxYYBaOzNMFisozJB6p2McLlu19Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ckom5Zsyuq4H7BUTCOMeJWh4iUX785tXRdtw+8ePrPFWIX3LPsGIsBmBum2xLTk3a
         BIk8xfMfutcfl7eo5thYH2qwlVPa61WXALj5VZbTmg1FY/xlhh/rIvc74qhLaRoxNZ
         CQu0eftMVQ2kA/h0kSZGlJ2w5QKbfGAZKRLy50iUxfb1TSic9bxO3oLBJC3+HbRtA7
         IWLmKuJtiMCnYVnGIRAIADtDsXLJPADv0kLMiuD5uMwxmDdkC2o3X4pum+TUrzPyus
         AVQU+1Tq8Mvnk4Oq4u9SkVXyrcMiCN/Yxnf/IBaZB6foADXO8h7zwqAhO6CfBKF/EF
         WK5TNKjiDPrSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C9AD60BFB;
        Thu, 24 Jun 2021 18:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/2] can: j1939: j1939_sk_setsockopt(): prevent allocation of
 j1939 filter for optlen == 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162455940517.3292.6011951304218982459.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:30:05 +0000
References: <20210624064200.2998085-2-mkl@pengutronix.de>
In-Reply-To: <20210624064200.2998085-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        nslusarek@gmx.net, o.rempel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 08:41:59 +0200 you wrote:
> From: Norbert Slusarek <nslusarek@gmx.net>
> 
> If optval != NULL and optlen == 0 are specified for SO_J1939_FILTER in
> j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0
> size allocation. The new filter will be mistakenly assigned ZERO_PTR.
> This patch checks for optlen != 0 and filter will be assigned NULL in
> case of optlen == 0.
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0
    https://git.kernel.org/netdev/net/c/aaf473d0100f
  - [net,2/2] can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path
    https://git.kernel.org/netdev/net/c/b17233d385d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


