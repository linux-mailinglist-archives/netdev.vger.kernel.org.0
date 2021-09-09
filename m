Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C690F405C69
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 19:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbhIIR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 13:56:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237254AbhIIR4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 13:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1UWlNkIF4/UMRB1ZyeAZe5VS1c7OZjo4kDlZHIcxZoQ=; b=DuLHRghbg6cQ0z9uqyjy2SwKh1
        RdMn1VMSB9aolUNTsdIIya54TuNOSvXh5fObFlroiLQ1nuYxY2w66h9egToVCZZQJtpaVio89+2e9
        S6G2Dq7qyxeDo2Jcd6821Lp48VsNfIwKb7JkntUBHY9NjkjlitLHNuVeYibmwouHOQ6A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOOGL-005wn8-KZ; Thu, 09 Sep 2021 19:55:01 +0200
Date:   Thu, 9 Sep 2021 19:55:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <YTpKddrZVDsGlhRn@lunn.ch>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <YTokNsh6mohaWvH0@lunn.ch>
 <8d168388-4388-c0ec-7cfa-5757bf5b0c24@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d168388-4388-c0ec-7cfa-5757bf5b0c24@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 06:46:49PM +0200, Lino Sanfilippo wrote:
> On 09.09.21 at 17:11, Andrew Lunn wrote:
> >> Andrew: the switch is not on a hat, the device tree part I use is:
> >
> > And this is not an overlay. It is all there at boot?
> >
> 
> Well actually we DO use an overlay. The dev tree snipped I posted was an excerpt form
> fdtdump. The concerning fragment looks like this in the overlay file:

Thanks for the information. Good to know somebody is using DSA like
this. The device tree description can be quite complex, especially for
some of the other switches.

> But probably this does not matter any more now that Vladimir was
> able to reproduce the issue.

Agreed.

	Andrew
