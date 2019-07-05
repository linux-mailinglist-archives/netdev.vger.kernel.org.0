Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE660047
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 06:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfGEEws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 00:52:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfGEEws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 00:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2/8NsHw+WdiDMD8ptg8/Nx7NB/BaQOAu8VwhBkB5PmU=; b=Fvra9DoyTtUVjinl3O27K1jzw5
        P3gsszlIqwL5yC9UlO+E7UzCn6+eWLaxJpAH0xFki7VhhSM0AMkCcUJOSkuUb0psOMm6HV31kSd9S
        IQ/9mccNU7Lo1mAE7gqOTEQVAoOyl1NN8eaSMYMqNJ6DHUbWikKRebjajbB/02ITe0Ig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjGDC-0007xS-Lg; Fri, 05 Jul 2019 06:52:42 +0200
Date:   Fri, 5 Jul 2019 06:52:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Message-ID: <20190705045242.GB30115@lunn.ch>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
 <20190704135420.GD13859@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147388E0@PGSMSX103.gar.corp.intel.com>
 <20190704155217.GI18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814738B36@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC814738B36@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If the community prefers readability

Readability nearly always comes first. There is nothing performance
critical here, MDIO is a slow bus. So the code should be readable,
simple to understand.


, I will suggest to do the c45 setup in
> both stmmac_mdio_read() and stmmac_mdio_write() 's if(C45) condition rather
> than splitting into 2 new c45_read() and c45_write() functions.     

Fine.

	Andrew
