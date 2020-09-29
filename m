Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E122A27BC9F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgI2F4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:56:43 -0400
Received: from mail.intenta.de ([178.249.25.132]:27200 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgI2F4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 01:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=2pMj28T6Gnzme5ijvO2L3EUhNGLWzy7xk/Tfgk0DFuA=;
        b=E4T4vFjfZ4c73i5EgjlFdygr8nqy7rNoDnidcy/VX1njr6BnKcpN1JTowcXDC9mvP+sRlOKZxXKTJx8imNAH7eEeK/g6Nlil7PsurMzKCvLF9G9STXK/sg4Z92K8BK0kDyPLmdQIQn8LunDKMbIE5xOoCTMdSQlSZmpwIundp/KAC6Vn65IRM57VV48k4k83rMBkzlcbPJNqLam/36Ij4F1hj40bYX8eXYq9zSVW2aBolofBQNJpav3SLKihhibOt3SJIgANagPa46bVcPY6b6vbvDLBFMkHzxUfrp1SUsczO8hQA2cSCcGkdBbaP2z93DKLbQ7yQTjbeT5CazCUNA==;
Date:   Tue, 29 Sep 2020 07:56:30 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 08/29] net: dsa: microchip: look for phy-mode
 in port nodes
Message-ID: <20200929055630.GA9320@laureti-dev>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200929013027.2406344-8-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sascha,

On Tue, Sep 29, 2020 at 03:30:05AM +0200, Sasha Levin wrote:
> From: Helmut Grohne <helmut.grohne@intenta.de>
> 
> [ Upstream commit edecfa98f602a597666e3c5cab2677ada38d93c5 ]
> 
> Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
> property should be specified on port nodes. However, the microchip
> drivers read it from the switch node.
> 
> Let the driver use the per-port property and fall back to the old
> location with a warning.
> 
> Fix in-tree users.

I don't think this patch is useful for stable users. It corrects a
device tree layout issue. Any existing users of the functionality will
have an odd, but working device tree and that will continue working
(with a warning) after applying this patch. It just has a property on
the "wrong" node. I don't think I'd like to update my device tree in a
stable update.

If you apply it anyway, please also apply a fixup:
https://lore.kernel.org/netdev/20200924083746.GA9410@laureti-dev/

Helmut
