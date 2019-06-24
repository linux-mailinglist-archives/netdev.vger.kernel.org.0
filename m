Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8650DE8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfFXO0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:26:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbfFXO0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N5N6f9ldaRZVCwiVvBP9WWU3rYbAdzLFROiOxUyweJg=; b=v79fJ+CGdaLUV1/cBB/sRLTk9L
        4rfzsWfmoOX/OPvFugF8ZIDfiLiCFEc7W2S+tcAbv1bwlwuBbZU1zL+Erwq+xQIxzc3YqhAAOOrjS
        YHfzlIW7yPBmE2yKC6l1g1MdgFbQyLLtlTk/rb/mX01M9qJC2ru3PDYVb1ToXrk1lsmw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfPvN-0005nr-N6; Mon, 24 Jun 2019 16:26:25 +0200
Date:   Mon, 24 Jun 2019 16:26:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Message-ID: <20190624142625.GR31306@lunn.ch>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624115558.GA5690@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Yeah, there are 2 ethernet controller ports (managed by the enetc driver) 
> > connected inside the SoC via SGMII links to 2 of the switch ports, one of
> > these switch ports can be configured as CPU port (with follow-up patches).
> > 
> > This configuration may look prettier on DSA, but the main restriction here
> > is that the entire functionality is provided by the ocelot driver which is a
> > switchdev driver.  I don't think it would be a good idea to copy-paste code
> > from ocelot to a separate dsa driver.
> > 
> 
> We should probably make the ocelot driver a DSA driver then...

Hi Claudiu, Alexandre

An important part of DSA is being able to direct frames out specific
ports when they ingress via the CPU port. Does the silicon support
this? At the moment, i think it is using polled IO.

      Andrew
