Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022EF55784
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbfFYTDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:03:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfFYTDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 15:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VAXht7vpZuAtpiuMA19JMP15bLrWIbv+G89yEKvdZCM=; b=WagtcMv/lSZC1/MxFghk1R0tXc
        vgwh1rTNfxElOekqfSxQJeuoYML7U6sdn7W9UhE2zW6TBpcSEVkTqHKfrog6Zpo9lz7cYWOoKjvSI
        IbiXK1tROWFfLWemwiWR4YTnCdTiInasFh5MIdISoQkTLoc4KVrhDPl9CPtMEyDFKgYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfqiM-0000Bg-C3; Tue, 25 Jun 2019 21:02:46 +0200
Date:   Tue, 25 Jun 2019 21:02:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190625190246.GA27733@lunn.ch>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But will there still be a mechanism to ignore link partner's advertising
> and force these parameters?

From man 1 ethtool:

       -a --show-pause
              Queries the specified Ethernet device for pause parameter information.

       -A --pause
              Changes the pause parameters of the specified Ethernet device.

           autoneg on|off
                  Specifies whether pause autonegotiation should be enabled.

           rx on|off
                  Specifies whether RX pause should be enabled.

           tx on|off
                  Specifies whether TX pause should be enabled.

You need to check the driver to see if it actually implements this
ethtool call, but that is how it should be configured.

	Andrew
