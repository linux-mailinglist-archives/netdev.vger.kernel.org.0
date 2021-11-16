Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E82453CC7
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 00:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhKPXoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 18:44:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhKPXoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 18:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7705HG4ZlrbNLiEXh/P6zNUSAQ7e6Y+XWcknyhkXF3w=; b=qJCczi+weTYxTCM4oCVyEvXQKz
        RhT4QP9CdyAsxs0lgTJmoxkiG+7KzUgs3FAHS/bDlzhgzG7gNe/s5ZA5yg0kxVzwNUSTWl3lx/Eyv
        QrZkmSk6chDw+d6k7ayUy44bzE+zkLCAA67C1vUvbp6bUTsltBFj4wDWTdkZS+ZQ+tCw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mn84W-00DkMc-QV; Wed, 17 Nov 2021 00:41:04 +0100
Date:   Wed, 17 Nov 2021 00:41:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
Message-ID: <YZRBkMsOhKB7nFW1@lunn.ch>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-4-gerhard@engleder-embedded.com>
 <YZLnhOUg7A66AL5p@lunn.ch>
 <CANr-f5y339dz5Q2Qazw_6-q81dXma=fEPQMm2Qfk78AjvhG=7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5y339dz5Q2Qazw_6-q81dXma=fEPQMm2Qfk78AjvhG=7Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > diff --git a/drivers/net/ethernet/engleder/tsnep_test.c b/drivers/net/ethernet/engleder/tsnep_test.c
> >
> > You have quite a lot of code in this file. Could it either be
> >
> > 1) A loadable module which extends the base driver?
> > 2) A build time configuration option?
> >
> > What percentage of the overall driver binary does this test code take
> > up?
> 
> Driver is 484kB with test code and 396kB without. So test code is roughly
> 20% currently. In my opinion a configuration option makes more sense,

Yes, that is good, please add one.

     Andrew
