Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9493E1A81D1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437771AbgDNPPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:15:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437266AbgDNPPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wb8f39hCjGcYV8+AHNSAescCyaLfOVyVKTEaqlWfHFA=; b=rXukUfJulQmi7iSIMYWiAq9QR6
        JXRXBujHbPtK1TQRqgGBlXbmwkIa5/8xprYf1whWGTnGar8OAbVX+Qel6l8H0iYPf4kpQGsFnCxYo
        F0NYB3fyVHQtiPMsP1pPBLoC+PP88zvzGx82OwcsQEXCaZWQT+LEw/Tpz5fT9Fv2a7ho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jONH8-002fp9-VA; Tue, 14 Apr 2020 17:14:58 +0200
Date:   Tue, 14 Apr 2020 17:14:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe ROULLIER <christophe.roullier@st.com>
Cc:     Alexandre TORGUE <alexandre.torgue@st.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCHv2 1/1] net: ethernet: stmmac: simplify phy modes
 management for stm32
Message-ID: <20200414151458.GA637127@lunn.ch>
References: <20200316090907.18488-1-christophe.roullier@st.com>
 <cb0a5dd3-02da-7d60-7069-a8ee080ad239@st.com>
 <ecbfd26c-8dcb-3763-c1aa-ccc4c110aefa@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecbfd26c-8dcb-3763-c1aa-ccc4c110aefa@st.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 03:10:26PM +0000, Christophe ROULLIER wrote:
> Hi,
> 
> Gentle reminder

Hi Christophe

You are more likely to have success if you repost.

    Andrew
