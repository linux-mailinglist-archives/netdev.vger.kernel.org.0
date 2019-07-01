Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0645C4D3
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAVJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:09:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfGAVJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 17:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FS3zYKTfBQ7R4y1qqZSwORo7QgLWjEnpO+Ly/y1JU2M=; b=ATUYRVdJ0TirIyX8MylR5qrsnz
        6YH5mWLYJEZAMBPjQyFeVPahNq938hS11OP7jm4VYwrrVQm8LCvFYbD1ljAfKnwk0g3hJkgpdrKAI
        A3EjlBVImAyeVHEaUU/+VVK/R5m65jfeKtvRM5lEqb4QAzNcS6qYs4shoqF3Oztf1+Qc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hi3Xq-0001t5-9g; Mon, 01 Jul 2019 23:09:02 +0200
Date:   Mon, 1 Jul 2019 23:09:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190701210902.GL30468@lunn.ch>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org>
 <20190701200248.GJ30468@lunn.ch>
 <35db1bff-f48e-5372-06b7-3140cb7cbb71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35db1bff-f48e-5372-06b7-3140cb7cbb71@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:37:16PM +0200, Heiner Kallweit wrote:
> On 01.07.2019 22:02, Andrew Lunn wrote:
> > On Mon, Jul 01, 2019 at 12:52:24PM -0700, Matthias Kaehlcke wrote:
> >> The RTL8211E has extension pages, which can be accessed after
> >> selecting a page through a custom method. Add a function to
> >> modify bits in a register of an extension page and a few
> >> helpers for dealing with ext pages.
> >>
> >> rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
> >> inspired by their counterparts phy_modify_paged() and
> >> phy_restore_page().
> > 
> > Hi Matthias
> > 
> > While an extended page is selected, what happens to the normal
> > registers in the range 0-0x1c? Are they still accessible?
> > 
> AFAIK: no

This it would be better to make use of the core paged access support,
so that locking is done correctly.

   Andrew
