Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41433481C7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhCXTUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237659AbhCXTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14CA961A07;
        Wed, 24 Mar 2021 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616613608;
        bh=a+DnYSO2BWXBtiyUIXobzaUUYSHRHqxZKBFJ/bHb/Ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iMQ2m2S/EbtO00OUebMaN5hiD7ROyhSBjAi9oXMfG+S79eNi0k9tGb7hzh1+7N/74
         1+ozTIoLq5ujWRYJbr1vplaEQsF3y6BoXZLhYzIV5p7DlfnciDfgJjPxu2YDnc/dbI
         7phEeHi/5GssMEqLX2Jv+FSDkC8IJ7tFMjarjAOWfhKyzXrhA34+2yOZCpdsYqfAxk
         Lq62AvSgnl9vHiWl2tpPdWyH7fqYYhyx9d/YKwnyuOsJLa4JeznXVyTkzMBuz2OLHq
         R9cfS6MBFK0scSbrdvlOntCGy3rnw+6Q1MYrpr5XQNNTB2OtYKY/jxif6nyNCVSVxD
         LW1lJSur1gtGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02FB260A3E;
        Wed, 24 Mar 2021 19:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64
 calcalation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161661360800.12280.1702538516592660744.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 19:20:08 +0000
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
In-Reply-To: <20210323080229.28283-1-yangbo.lu@nxp.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Mar 2021 16:02:29 +0800 you wrote:
> Current calculation for diff of TMR_ADD register value may have
> 64-bit overflow in this code line, when long type scaled_ppm is
> large.
> 
> adj *= scaled_ppm;
> 
> This patch is to resolve it by using mul_u64_u64_div_u64().
> 
> [...]

Here is the summary with links:
  - ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation
    https://git.kernel.org/netdev/net/c/f51d7bf1dbe5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


