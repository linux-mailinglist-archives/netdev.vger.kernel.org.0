Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDCC3490
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbfJAMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:42:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387859AbfJAMmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 08:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n9SwtzBQLDaKOFpGqdCfpbjlJzYPV55cZxw6ACX85V8=; b=tMR7C0VFFtvrM97u3rSLb+tudh
        9r7oghvLWphuntDvlNJ8IlMl0Wyi5SVbhuOzF3nWZ8Fozhnp0m0f5+rHoKKJT15DCZHW+JwVelUYZ
        vZwN2qH3c+t2N8j92zoECtQkAdLFLw+IMpcXuTdBRIjGyjL3rxVrNR0+cEr6N6Lk/2/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iFHTi-0000P7-Eq; Tue, 01 Oct 2019 14:42:06 +0200
Date:   Tue, 1 Oct 2019 14:42:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rene van Dorst <opensource@vdorst.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 1/2] net: ethernet: mediatek: Fix MT7629 missing GMII
 mode support
Message-ID: <20191001124206.GC869@lunn.ch>
References: <20191001123150.23135-1-Mark-MC.Lee@mediatek.com>
 <20191001123150.23135-2-Mark-MC.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001123150.23135-2-Mark-MC.Lee@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 08:31:49PM +0800, MarkLee wrote:
> Add missing configuration for mt7629 gmii mode support
> 
> Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>

Hi Mark

Since this is for net, it should have a Fixes: tag.

Thanks
	Andrew
