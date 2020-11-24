Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680102C1A7E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgKXBAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgKXBAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606179606;
        bh=bd0l1PSEPO38a7uwAXy+Q+w+HSKiaXQuYHdvfAYEELw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CSDB1YK+vNfHwVBC0EH/+9EkL3pFpDnuTq4lTrWu5Wij/jSB5l8EfZXntFHkzcrb/
         BQEDXHiZkN69MPOxmOKnK/g00ooPvZWjp0svskH2WDpN8DJ0ngRh35ouvayEyaor3F
         ej65Vu74mR9w+nzxsDLNysf2E2OrnXpj8qX7ewcc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: hellcreek: Minor cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160617960633.25502.4860248883818219651.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 01:00:06 +0000
References: <20201121114455.22422-1-kurt@linutronix.de>
In-Reply-To: <20201121114455.22422-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 21 Nov 2020 12:44:53 +0100 you wrote:
> Hi,
> 
> fix two minor issues in the hellcreek driver.
> 
> Thanks,
> Kurt
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: tag_hellcreek: Cleanup includes
    https://git.kernel.org/netdev/net-next/c/8551fad63cd3
  - [net-next,2/2] net: dsa: hellcreek: Don't print error message on defer
    https://git.kernel.org/netdev/net-next/c/ed5ef9fb2023

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


