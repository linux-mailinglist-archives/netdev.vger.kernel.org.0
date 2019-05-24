Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFD299D6
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404095AbfEXONP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:13:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403917AbfEXONP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 10:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/9dmYJZulcMPLnnMVDuzzMs5fmFA6/ZM62RgXCFhBYI=; b=FxI/equ1rCcR7ROW74hmHaIN8W
        a3sMPajtJWiA9+njTVE56NWYyVBEAiP0AYgQfgUHhsbDXbc2nLFQbR8vfrF2QUNbzUOlJpW9ir5Iq
        hedicBAbYCafl5/aPprnxcMjGEFL+21IjzSCp7ToryTa8nCwo8qQCdBpaK4OlT9YcOZ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUAwZ-0001Uf-L4; Fri, 24 May 2019 16:13:11 +0200
Date:   Fri, 24 May 2019 16:13:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Message-ID: <20190524141311.GJ2979@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524085921.11108-2-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 09:00:24AM +0000, Rasmus Villemoes wrote:
> The 88e6250 (as well as 6220, 6071, 6070, 6020) do not support
> multi-chip (indirect) addressing. However, one can still have two of
> them on the same mdio bus, since the device only uses 16 of the 32
> possible addresses, either addresses 0x00-0x0F or 0x10-0x1F depending
> on the ADDR4 pin at reset [since ADDR4 is internally pulled high, the
> latter is the default].
> 
> In order to prepare for supporting the 88e6250 and friends, introduce
> mv88e6xxx_info::dual_chip to allow having a non-zero sw_addr while
> still using direct addressing.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
