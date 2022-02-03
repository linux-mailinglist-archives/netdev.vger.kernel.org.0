Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3304A8592
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbiBCNyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:54:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350918AbiBCNyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 08:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=M0AwtJ6X+21Ku/MswUd5r7r3/EB9NBXlsTNRVMaSpX0=; b=RU
        rRNysWeVCXO1QisPnOkeHqcWDdWofe6HH/X3ze+EuUT0diTTf0IkVYgAPdGgVcqHiiDWoeZwYtwtL
        tlp+LLICrKawpmjNGJRzWnFzJDhxcjTZR5uzeFTO3tDYkjAVHutAJK+Qr6BsAVKIgNg/cUfn1uspz
        W3MfXZaHhCOvo/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFcYg-0047Oz-Tp; Thu, 03 Feb 2022 14:53:58 +0100
Date:   Thu, 3 Feb 2022 14:53:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: mv88e6xxx: improve 88e6352 serdes
 statistics detection
Message-ID: <YfveduCCD+n8vf1g@lunn.ch>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
 <E1nFcCK-006WN0-Do@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1nFcCK-006WN0-Do@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 01:30:52PM +0000, Russell King (Oracle) wrote:
> The decision whether to report serdes statistics currently depends on
> the cached C_Mode value for the port, read at probe time or updated by
> configuration. However, port 4 can be in "automedia" mode when it is
> used as a serdes port, meaning it switches between the internal PHY and
> the serdes, changing the read-only C_Mode value depending on which
> first gains link. Consequently, the C_Mode value read at probe does not
> accurately reflect whether the port has the serdes associated with it.
> 
> In "net: dsa: mv88e6xxx: add mv88e6352_g2_scratch_port_has_serdes()",
> we added a way to read the hardware configuration to determine which
> port has the serdes associated with it. Use this to determine which
> port reports the serdes statistics.
> 
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
