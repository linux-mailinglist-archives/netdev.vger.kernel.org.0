Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F024528F70A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389960AbgJOQoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgJOQoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:44:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0160E22240;
        Thu, 15 Oct 2020 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602780259;
        bh=5vgZni9l7jILHj80pz8LaCEK1pBkY9yF/Orn9QTDyYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fe/dVPT35f97V6Jzpk11TNcG9z3zo37AOOQKtXlyQRab0ulfUHdrEf+Yi8S/JRWeb
         +PmCBIQhqyRi+hZKEjGJCXoXjnrTiUeiPjZFYLr6J8j2hPXJY4nfV//h0hJYTEv+T4
         b/9q3hfc65zdYigrdyQH+kRUzSWZPipQWcAW8v+8=
Date:   Thu, 15 Oct 2020 09:44:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/1] net: dsa: seville: the packet buffer is 2
 megabits, not megabytes
Message-ID: <20201015094417.3bf2c324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014132743.277619-1-fido_max@inbox.ru>
References: <20201014132743.277619-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 16:27:43 +0300 Maxim Kochetkov wrote:
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
> 2 megabits is (2048 / 8) * 1024 = 256 * 1024.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")

Maxim, did you hand-edit this patch?  It's mangled.

Please resend.
