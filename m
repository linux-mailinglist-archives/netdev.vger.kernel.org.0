Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBEE28004
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfEWOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:42:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbfEWOmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 10:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oe0GIDHTZ2hjKY163zBRnNo0jGG1opp88uh5+/y+h7o=; b=CbpAzPlFGvlp5rI0S6srpIYsZK
        bu7DUcdO975IKQ5EjySFuo7UeUxwuDBD9uu2On077lOKnW0f2+eoai89nsWoF3XTSj0k0ndY34jfW
        8vRBDf/DEDlriwcoX+FB8TNNBPFXrJzUwFOLiBqw1393psHPtmv4dbs4Mw7sp5tNRo5Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTov9-0005hY-Pl; Thu, 23 May 2019 16:42:15 +0200
Date:   Thu, 23 May 2019 16:42:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8] dt-bindings: net: Add YAML schemas for the generic
 Ethernet options
Message-ID: <20190523144215.GC19369@lunn.ch>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +            link-gpios:
> > +              description:
> > +                GPIO to determine if the link is up
> 
> Only 1?

Hi Rob

Yes, only one.

	Andrew
