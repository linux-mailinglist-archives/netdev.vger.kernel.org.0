Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60B62E46
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGIClt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:41:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIClt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 22:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EH71sYqDv6NdaTmNd15cw9qcQxPlCKm6HN9YqAorv90=; b=GAIrOdKT2PU7OmSCF/MKuypksi
        c9GPZ5XPrClm6BO+tbMV7xe02Wegsinw+4n8ecMks6am1C+ieCYoDtOM8wQS6SL9ItjzNx3wRAhZ3
        EfZ5kZXRz27Q9OqTEzIvHrefEW6dwUGMFHP2DJ5hzsS8roIuSPqXJdEoc+toTnaxLfYM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkg4d-0006i2-Mw; Tue, 09 Jul 2019 04:41:43 +0200
Date:   Tue, 9 Jul 2019 04:41:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     josua@solid-run.com, netdev <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4] dt-bindings: allow up to four clocks for orion-mdio
Message-ID: <20190709024143.GD5835@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-2-josua@solid-run.com>
 <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJJA6=2b=VzDzS1ipOatpRuVBUmReYoOMf-9p39=jyF8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  Optional properties:
> >  - interrupts: interrupt line number for the SMI error/done interrupt
> > -- clocks: phandle for up to three required clocks for the MDIO instance
> > +- clocks: phandle for up to four required clocks for the MDIO instance
> 
> This needs to enumerate exactly what the clocks are. Shouldn't there
> be an additional clock-names value too?

Hi Rob

The driver does not care what they are called. It just turns them all
on, and turns them off again when removed.

    Andrew
