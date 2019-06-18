Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8782F4972A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 03:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFRBxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 21:53:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfFRBxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 21:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=npsIcZKfycgIAiEwGdw9g2XfI8tUu7kcKJPmBU4VaZQ=; b=NgwBf+r/5H6byWz8hbuUd9nSdM
        oCAimxT1hX7C7ZIwwIFzDTAVO7no2f9SGd2RuelhO0hUZxu4UnJ9F4lNHBr0Ox2ghd2DJveWRgfv4
        C6+7dIhY9j+kA6738Np5DXCIdE4g4+ODvhUuqxBSPLoua4Ko1qjgMa9izRJdLeMkB4kQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hd3J7-0005Pp-3s; Tue, 18 Jun 2019 03:53:09 +0200
Date:   Tue, 18 Jun 2019 03:53:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
Message-ID: <20190618015309.GA18088@lunn.ch>
References: <20190616182010.18778-1-opensource@vdorst.com>
 <20190617140223.GC25211@lunn.ch>
 <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
 <20190617214428.GO17551@lunn.ch>
 <20190617232004.Horde.mAVymZdeb9Jjf29W2PeOggU@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190617232004.Horde.mAVymZdeb9Jjf29W2PeOggU@www.vdorst.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> By adding some extra speed states in the code it seems to work.
> 
> +               if (state->speed == 1200)
> +                       mcr |= PMCR_FORCE_SPEED_1000;

Hi René

Is TRGMII always 1.2G? Or can you set it to 1000 or 1200? This
PMCR_FORCE_SPEED_1000 feels wrong.

> >We could consider adding 1200BaseT/Full?
> 
> I don't have any opinion about this.
> It is great that it shows nicely in ethtool but I think supporting more
> speeds in phy_speed_to_str() is enough.
> 
> Also you may want to add other SOCs trgmii ranges too:
> - 1200BaseT/Full for mt7621 only
> - 2000BaseT/Full for mt7623 and mt7683
> - 2600BaseT/Full for mt7623 only

Are these standardised in any way? Or MTK proprietary?  Also, is the T
in BaseT correct? These speeds work over copper cables? Or should we
be talking about 1200BaseKX?

   Thanks
	Andrew
