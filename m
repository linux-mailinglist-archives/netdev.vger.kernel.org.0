Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26811C8BE0
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEGNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:16:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgEGNQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vk41FiGE7OzvR4Ex8ve/e7chOhsCEpaO414K5RXlxrY=; b=tTp2bzTIB3i1MnLPqrNbuPXcsY
        WfQt9FVPRWRBztAkewuKACD/1WAg2q6auQUsYJkw/msyPR0OQHQUOfsrFWcF1lafu47rbBSjN6NPB
        Qbfxri/uC9wv8/ac2eZpekCVKVOOnEnfoIX3VyRlq9uVhbKjNL/MKC3Cpp8aRITHl6Jo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jWgOL-001E3q-DR; Thu, 07 May 2020 15:16:45 +0200
Date:   Thu, 7 May 2020 15:16:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     "Mark-MC.Lee" <Mark-MC.Lee@mediatek.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, Arnd Bergmann <arnd@arndb.de>,
        netdev <netdev@vger.kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sean Wang <sean.wang@mediatek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        arm-soc <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
Message-ID: <20200507131645.GM208718@lunn.ch>
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-7-brgl@bgdev.pl>
 <1588844771.5921.27.camel@mtksdccf07>
 <CAMpxmJW4qZ_Wnp_oRa=j=YnvTzVa3HZ13Hgwy71jS6L3Bd3oMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMpxmJW4qZ_Wnp_oRa=j=YnvTzVa3HZ13Hgwy71jS6L3Bd3oMQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 12:50:15PM +0200, Bartosz Golaszewski wrote:
> czw., 7 maj 2020 o 11:46 Mark-MC.Lee <Mark-MC.Lee@mediatek.com> napisał(a):
> >
> > Hi Bartosz:
> >  I think the naming of this driver and its Kconfig option is too generic
> > that will confuse with current mediatek SoCs eth driver architecture(for
> > all mt7xxx SoCs).
> >   Since mtk_eth_mac.c is not a common MAC part for all mediatek SoC but
> > only a specific eth driver for mt85xx, it will be more reasonable to
> > name it as mt85xx_eth.c and change NET_MEDIATEK_MAC to
> > NET_MEDIATEK_MT85XX. How do you think?
> >
> 
> Hi Mark,
> 
> I actually consulted this with MediaTek and the name is their idea.
> Many drivers in drivers/net/ethernet have very vague names. I guess
> this isn't a problem.

They have vague names, but they tend to be not confusing.

NET_MEDIATEK_MAC vs NET_MEDIATEK_SOC is confusing.

I think the proposed name, mt85xx_eth.c and NET_MEDIATEK_MT85XX is
good. Or some variant on this, mt8xxx?

    Andrew
