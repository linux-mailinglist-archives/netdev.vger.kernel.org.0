Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6A2DF0EC
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgLSSAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbgLSR77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 12:59:59 -0500
Date:   Sat, 19 Dec 2020 09:59:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608400758;
        bh=pdO7yN27dVbxPgRegNWOCdEQpv/5y8Wa0WcvQGFzoF0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=holaY5/ZCCy1tufiJqgn51KOF2wx6Aj5L6gpdupdp1Aef7D3Qz+DFS+1NsIWj5dI6
         4Y+bmaLuRfbn+jJzt71J8teHp8fKi8Fue6d4IHYtCOo3DCAPxFoAosOqoG6ryJWC8r
         nj9LVLzSlpiAkHHG+gMXCSSekXcFU6DRuilthVueCPRd5rUQrtqshhm7oxpQN3Y7se
         fRu6yNjjXZdvvsqcv2rNY+383gExHrktmnsZe7rMcIKcHvSuGfiqLtBQpifnpvhhHg
         5MfeDGukiurVImv2FKWdjJKjDQREOanCavrUmQ7Fam0n/k6Z4YFMuFzPu8KOpvBqY6
         xgocci6UgjGUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <stable@vger.kernel.org>
Subject: Re: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking Complex
 Control configurations
Message-ID: <20201219095917.67401234@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608208648-13710-1-git-send-email-stefanc@marvell.com>
References: <1608208648-13710-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 14:37:28 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> During GoP port 2 Networking Complex Control mode of operation configurations,
> also GoP port 3 mode of operation was wrongly set.
> Patch removes these configurations.
> GENCONF_CTRL0_PORTX naming also fixed.

Testing the stable backport it looks like this addition change will be
problematic. Not to mention it goes against the "fixes should be
minimal" rule.

Could you please send just a one liner which removes the offending
ORing in of the bad bit?

We can do the rename soon after in net-next, the trees are merged
pretty much every week so it won't be a long wait.

> Cc: stable@vger.kernel.org
> Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
