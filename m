Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DD86C43B
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 03:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGRBbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 21:31:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfGRBbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 21:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4wErmAY4zUKJSvpR2R2+UnKAN/+PII1YmLV60iUy0K0=; b=feAQqClO/uTtYlhjOXWIWpEm0W
        O8CbZldGibng/pHu50IoNXHDN043e9j6+jvKUsJX3m6tqz5OKF4WgJLvoHlGSpEIifEYk92Cjy5qC
        jkHMWjTOU9e1kolt0X8BGmYr8fcCiYHyFdbkC1qUfbeqhsFpTJXO0LtcsWg/tGUuLnK4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hnvG8-0001zA-1M; Thu, 18 Jul 2019 03:31:00 +0200
Date:   Thu, 18 Jul 2019 03:31:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     josua@solid-run.com, netdev <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
Message-ID: <20190718013100.GB6962@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-2-josua@solid-run.com>
 <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com>
 <20190709024143.GD5835@lunn.ch>
 <CAL_JsqK=qpCi6whqmjW2L8O=3u4oZemH=czm60q9QnC09Gr_ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK=qpCi6whqmjW2L8O=3u4oZemH=czm60q9QnC09Gr_ig@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 04:03:28PM -0600, Rob Herring wrote:
> On Mon, Jul 8, 2019 at 8:41 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > >  Optional properties:
> > > >  - interrupts: interrupt line number for the SMI error/done interrupt
> > > > -- clocks: phandle for up to three required clocks for the MDIO instance
> > > > +- clocks: phandle for up to four required clocks for the MDIO instance
> > >
> > > This needs to enumerate exactly what the clocks are. Shouldn't there
> > > be an additional clock-names value too?
> >
> > Hi Rob
> >
> > The driver does not care what they are called. It just turns them all
> > on, and turns them off again when removed.
> 
> That's fine for the driver to do, but this is the hardware description.
> 
> It's not just what they are called, but how many too. Is 1 clock in
> the DT valid? 0? It would be unusual for a given piece of h/w to
> function with a variable number of clocks.

Hi Rob

The orion5x has 0 clocks. kirkwood, dove, Armada XP, 370 375, 380
has 1 clock. Armada 37xx has 4.

So yes, 1 clock is valid. 0 clocks is also valid. The piece of
hardware itself does not care how many clocks are feeding it, so long
as they are all turned on.

   Andrew 
