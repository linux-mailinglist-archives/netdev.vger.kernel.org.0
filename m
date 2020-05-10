Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974AA1CCC1F
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEJQIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:08:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgEJQIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 12:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=25CJzCpD/SFUATTJstuVWs3jSPHR0Di0fsyXH7mfFqE=; b=NGr7+C1mxZ+pFW9c8TA4MDJuNN
        rdm+aQowc5xnh3tyjgR7AH/S7uce+U3scUSWruMOVJlBlZmyTnbnIVDylpJDdogy+mm4iU8Mtp7B/
        KjueHXOg1ku2tXLpCsiEtp3eL0jBHaYTMWaW8Tz6uXz/Krj+HXR9lj45CPDfPGXHtv3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXoUg-001ibI-0j; Sun, 10 May 2020 18:07:58 +0200
Date:   Sun, 10 May 2020 18:07:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200510160758.GN362499@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
 <20200509162851.362346-7-andrew@lunn.ch>
 <20200510151226.GI30711@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510151226.GI30711@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 05:12:26PM +0200, Michal Kubecek wrote:
> On Sat, May 09, 2020 at 06:28:47PM +0200, Andrew Lunn wrote:
> > Provide infrastructure for PHY drivers to report the cable test
> > results.  A netlink skb is associated to the phydev. Helpers will be
> > added which can add results to this skb. Once the test has finished
> > the results are sent to user space.
> > 
> > When netlink ethtool is not part of the kernel configuration stubs are
> > provided. It is also impossible to trigger a cable test, so the error
> > code returned by the alloc function is of no consequence.
> > 
> > v2:
> > Include the status complete in the netlink notification message
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> It seems you applied the changes to ethnl_cable_test_alloc() suggested
> in v2 review as part of patch 7 rather than here. I don't think it's
> necessary to fix that unless there is some actual problem that would
> require a resubmit.

Hi Michal

Yes, squashed it into the wrong patch. But since all it does it change
one errno for another, it is unlikely to break bisect. As i agree, we
can live with this.

    Andrew
