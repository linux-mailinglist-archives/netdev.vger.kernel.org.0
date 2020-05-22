Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82D31DEC18
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730726AbgEVPh3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 May 2020 11:37:29 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:36321 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgEVPh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:37:29 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 0C8B040008;
        Fri, 22 May 2020 15:37:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200521.173105.157572657643183117.davem@davemloft.net>
References: <20200520100355.587686-1-antoine.tenart@bootlin.com> <20200521.173105.157572657643183117.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next] net: phy: mscc: fix initialization of the MACsec protocol mode
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <159016184520.3358.1393218293274400010@kwain>
Date:   Fri, 22 May 2020 17:37:25 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting David Miller (2020-05-22 02:31:05)
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Date: Wed, 20 May 2020 12:03:55 +0200
> 
> > What's the best way to handle this? I can provide all the patches.
> 
> Resubmit this against 'net' please, then I'll deal with the fallout
> when I merge net into net-next.

OK, I'll resubmit against net.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
