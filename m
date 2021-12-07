Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9887346B06F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhLGCK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:10:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhLGCK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S1ypNV3PAjRlec8TgdBzeu4Up/p1CJYpi3xitOE/STY=; b=PSYvbVQZbKwcTe3e8p1i9MRclL
        4zWrMaAaNCfWArahxIBDcrZMTqDynefYn36UTgeFYf+5BFl+8oEAM6GnnCog8hg8RThKtcZTUgHie
        Ur8V7oxdQyk3ddZK/b6vhwjKxKbE163cu1VF3+amJFSqVzJUx0HAVx9C7JtF8+rKk9J0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muPsd-00FjSm-Im; Tue, 07 Dec 2021 03:06:55 +0100
Date:   Tue, 7 Dec 2021 03:06:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya7BvzxrpJT9dvDA@lunn.ch>
References: <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <20211206215139.fv7xzqbnupk7pxfx@skbuf>
 <Ya6NF9OxSmLO9hv+@shell.armlinux.org.uk>
 <20211206234443.ar567ocqvmudpckj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206234443.ar567ocqvmudpckj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > mv88e6xxx_software_reset() does not fully reinitialise the switch.
> > To quote one switch manual for the SWReset bit "Register values are not
> > modified." That means if the link was forced down previously by writing
> > to the port control register, the port remains forced down until
> > software changes that register to unforce the link, or to force the
> > link up.
> 
> Ouch, this is pretty unfortunate if true.

Come on. Do you really think Russell is making this up?

     Andrew
