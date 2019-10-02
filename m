Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BF5C4A7C
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 11:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfJBJVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 05:21:07 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:37007 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725848AbfJBJVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 05:21:06 -0400
X-UUID: cad4ec74a3ec43fe91e54ad52e15926c-20191002
X-UUID: cad4ec74a3ec43fe91e54ad52e15926c-20191002
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 38700965; Wed, 02 Oct 2019 17:21:01 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 2 Oct 2019 17:20:59 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 2 Oct 2019 17:20:58 +0800
Message-ID: <1570008060.13954.12.camel@mtksdccf07>
Subject: Re: [PATCH net 1/2] net: ethernet: mediatek: Fix MT7629 missing
 GMII mode support
From:   mtk15127 <Mark-MC.Lee@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Date:   Wed, 2 Oct 2019 17:21:00 +0800
In-Reply-To: <20191001124206.GC869@lunn.ch>
References: <20191001123150.23135-1-Mark-MC.Lee@mediatek.com>
         <20191001123150.23135-2-Mark-MC.Lee@mediatek.com>
         <20191001124206.GC869@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-01 at 14:42 +0200, Andrew Lunn wrote:
> On Tue, Oct 01, 2019 at 08:31:49PM +0800, MarkLee wrote:
> > Add missing configuration for mt7629 gmii mode support
> > 
> > Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
> 
> Hi Mark
> 
> Since this is for net, it should have a Fixes: tag.
> 
> Thanks
> 	Andrew
Hi Andrew,
  Thanks for your reminder,will add a Fixes tag in the next patch.

Mark

