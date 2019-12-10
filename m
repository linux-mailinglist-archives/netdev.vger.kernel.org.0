Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD16119A88
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLJWCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:02:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLJWCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oNrhFWA1lMqgOP0XHTa3xdZ+GV9N7jCyBqMVj23yRHs=; b=xZWRhz+CFM5NfZoAhdE/Gf5Ate
        jwkCAm8gpKDWE3b5P9ajfLkTLdVB6mq5zla3yoyBXTl7B6q88/vbXgqargSm/6APZB/TKAoXevZv4
        oTGN3doiai+QIEhx1FqEk3Fa7u7QZwAndwta5kY3sotOnTY49pV6t4NxXfpKEYe8xkuI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ienaR-0007qA-JO; Tue, 10 Dec 2019 23:02:31 +0100
Date:   Tue, 10 Dec 2019 23:02:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Landen Chao <landen.chao@mediatek.com>, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of MT7531
 switch
Message-ID: <20191210220231.GA30053@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
 <20191210163557.GC27714@lunn.ch>
 <20191210213351.2df6acbf@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210213351.2df6acbf@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:33:51PM +0100, Marek Behun wrote:
> On Tue, 10 Dec 2019 17:35:57 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Tue, Dec 10, 2019 at 04:14:40PM +0800, Landen Chao wrote:
> > > Add new support for MT7531:
> > > 
> > > MT7531 is the next generation of MT7530. It is also a 7-ports switch with
> > > 5 giga embedded phys, 2 cpu ports, and the same MAC logic of MT7530. Cpu
> > > port 6 only supports HSGMII interface. Cpu port 5 supports either RGMII
> > > or HSGMII in different HW sku.  
> > 
> > Hi Landen
> > 
> > Looking at the code, you seem to treat HSGMII as 2500Base-X. Is this
> > correct? Or is it SGMII over clocked to 2.5Gbps?
> > 
> > 	 Andrew
> 
> How would that work? Would 10 and 100 be overclocked to 25 and 250?

No. SGMII clocked up to 2.5G does not support any of the lower
speeds. And inband signalling does not make much sense, the control
word is all wrong.

     Andrew
