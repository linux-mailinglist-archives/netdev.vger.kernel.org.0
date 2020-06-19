Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D55200ACB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbgFSN5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:57:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgFSN5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 09:57:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmHVp-001HVO-8s; Fri, 19 Jun 2020 15:56:57 +0200
Date:   Fri, 19 Jun 2020 15:56:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200619135657.GF304147@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-10-kurt@linutronix.de>
 <20200618134704.GQ249144@lunn.ch>
 <87zh8zphlc.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8zphlc.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do you
> > need some properties in the port@0 node to tell the switch to only use
> > 100Mbps? I would expect it to default to 1G. Not looked at the code
> > yet...
> 
> No, that is not needed. That is a hardware configuration and AFAIK
> cannot be changed at run time.

I was wondering about that in general. I did not spot any code in the
driver dealing with results from the PHY auto-neg. So you are saying
the CPU is fixed speed, by strapping? But what about the other ports?
Does the MAC need to know the PHY has negotiated 10Half, not 1G? Would
that not make a difference to your TSN?

     Andrew
