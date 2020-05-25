Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11DD1E1254
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391177AbgEYQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:05:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388432AbgEYQFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YzvAZSrosvDChzEiaS5Q8/ZPHohPgNhgyWrALTj4cbk=; b=YnWReJ+pz5Wv+yAdbJI1vI/HIt
        zmFOj2+wvqxTgmTWj0O3+YcLkAjXAY7sBcMqVSsHrlhJmTBssvpAtH5nT22YR1jChwCqNCex1xO+F
        TwBWtUCF+tlOl/FAWZG3LzhUs3lb1PpbB4ib+2ml/1osHSqh4368Ic/zuphKIfx0hljU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdFbd-003CcN-Co; Mon, 25 May 2020 18:05:37 +0200
Date:   Mon, 25 May 2020 18:05:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH] stmmac: platform: add "snps,dwmac-5.10a" IP
 compatible string
Message-ID: <20200525160537.GD762220@lunn.ch>
References: <1590394945-5571-1-git-send-email-fugang.duan@nxp.com>
 <20200525141048.GF752669@lunn.ch>
 <AM6PR0402MB3607312E97B14B09C398B586FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR0402MB3607312E97B14B09C398B586FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 04:00:29PM +0000, Andy Duan wrote:
> From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, May 25, 2020 10:11 PM
> > On Mon, May 25, 2020 at 04:22:25PM +0800, Fugang Duan wrote:
> > > Add "snps,dwmac-5.10a" compatible string for 5.10a version that can
> > > avoid to define some plat data in glue layer.
> > 
> > Documentation/devicetree/bindings/net/snps,dwmac.yaml ?
> > 
> >       Andrew
> 
> Here, we don't want to use generic driver "dwmac-generic.c" for 5.10a version
> since it requires platform specific code to be functional, like the we implement
> glue layer driver "dwmac-imx.c" to support 5.10a on i.MX platform.
> 
> So I think it doesn't require to add the compatible string into dwmac.yaml. 

Hi Andy

It needs to be documented somewhere. If not
Documentation/devicetree/bindings/net/snps,dwmac.yaml it needs to be
in an NXP specific document.

   Andrew
