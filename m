Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB78AC3C9D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbfJAQw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:52:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389331AbfJAQw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FX5jf20eacmB/0gFXEhbZpatqYKCnwg235wY4yTy5I8=; b=ZaDS95R+qKbRGCSKbOtuDkKVkt
        /C/hkhascHZ5lWv9IFuRxtzt2/pOybQ0vbmd7SmvBukkhoPdpz691km29114XSaqO9j/geTyTDrqU
        2RjCogdwSyQJEKXMJsarWOGVkqEDvUu6l3PoKFZzHIaFAzrFPMgAJmAgkQmCeG60SaJg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iFLOJ-0001ii-4j; Tue, 01 Oct 2019 18:52:47 +0200
Date:   Tue, 1 Oct 2019 18:52:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
Message-ID: <20191001165247.GE2031@lunn.ch>
References: <20191001082912.12905-1-icenowy@aosc.io>
 <3ef60a0c-5cfd-420b-6cad-2c16eb2a6c01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ef60a0c-5cfd-420b-6cad-2c16eb2a6c01@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 09:47:08AM -0700, Florian Fainelli wrote:
> On 10/1/19 1:29 AM, Icenowy Zheng wrote:
> > There're some Pine64+ boards known to have broken RTL8211E chips, and
> > a hack is given by Pine64+, which is said to be from Realtek.
> > 
> > This patchset adds the hack.
> > 
> > The hack is taken from U-Boot, and it contains magic numbers without
> > any document.
> 
> Such hacks are the very reason why PHY fixups exists, please investigate
> working with Realtek first to understand how to make this hack less of a
> hack so it is understood what it does and you can either add proper
> infrastructure to the realtek PHY driver to perform that hack, or if
> that is not an option, register a board specific fixup.

Hi Icenowy

It would also be nice to know if only Pine64 has these bad PHYs, or if
they were in the general distribution chain and other boards might
have them as well.

     Andrew
