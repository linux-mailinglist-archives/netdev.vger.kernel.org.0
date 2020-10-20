Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D65293297
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 03:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389782AbgJTBHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 21:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbgJTBHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 21:07:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C98BB2173E;
        Tue, 20 Oct 2020 01:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603156020;
        bh=at6Y9hv889MHiPxrZ2LUU1UCIBBF4ILC49V0of/CPrk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrxwzGAXa2YYiyvYM6k8AC8aNuJXxkcITw0zQlS1/kx3kahE3yIQi8kQhAAdPIZf7
         e1B6hNFoCpPjCNN15OaS1zAIRGgjVLEvhglIjwDqSY1ayzj5UEDeGzrYPlqRQ0ncyL
         ei+5Imid6QFbjEA40nIL4wIA457OalPNAp3lP62E=
Date:   Mon, 19 Oct 2020 18:06:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4] net: dsa: seville: the packet buffer is 2 megabits,
 not megabytes
Message-ID: <20201019180657.07c2682e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019050625.21533-1-fido_max@inbox.ru>
References: <20201019050625.21533-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 08:06:25 +0300 Maxim Kochetkov wrote:
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
> 2 megabits is (2048 / 8) * 1024 = 256 * 1024.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")

Applied, thank you!
