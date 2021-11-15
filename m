Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9070450946
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbhKOQLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhKOQLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 11:11:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72CCF61163;
        Mon, 15 Nov 2021 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636992516;
        bh=th+We+JaR452ukTxF51pUJTiqEWf+OWXEifIo8JSBfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PLL+V937Mj31jltZVQL/EVOM2+Sz+WDeYzIl7JVAnNRcAwcObWLNjeEToKwhwPTT8
         k6fwdkB2JGgI/4fwBzkwPBisPEDf+ifcn1lF4NXXOpWDgN9sX0m90kRRem0sODNVVb
         o+DaasGxQa5ph1NkvvJ1Ne+y8f76LKpLkX1ZiVHlo7Ci/zV7cfx0ZBqb62quGQyNrR
         +9hNPXXYfKi5PLUq8JmPjjS7XYEWiBM/8pHe0KAhryNa2Sb/DlKPD5YeaHo+XWLmPK
         XNGuChs8K7M1VbuCH2vN3srSaVBY1YMtIDDYpmBFzrFoEg3asegryCS+C+04K5UW/g
         td6RZc6Aczhow==
Date:   Mon, 15 Nov 2021 08:08:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        zev@bewilderbeest.net, robh+dt@kernel.org, davem@davemloft.net,
        brendanhiggins@google.com, benh@kernel.crashing.org,
        joel@jms.id.au, andrew@aj.id.au, avifishman70@gmail.com,
        tmaimon77@gmail.com, tali.perry1@gmail.com, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
Message-ID: <20211115080834.0b238ccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZJ9H4eM/M7OXVN0@shikoro>
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
        <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
        <YZJ9H4eM/M7OXVN0@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 16:30:39 +0100 Wolfram Sang wrote:
> > This series was applied to netdev/net-next.git (master)
> > by David S. Miller <davem@davemloft.net>:  
> 
> NACK. Please revert. Besides the driver in net, it modifies the I2C core
> code. This has not been acked by the I2C maintainer (in this case me).
> So, please don't pull this in via the net tree. The question raised here
> (extending SMBus calls to 255 byte) is complicated because we need ABI
> backwards compatibility.

Done, sorry: 2f6a470d6545 ("Revert "Merge branch 'mctp-i2c-driver'"")
