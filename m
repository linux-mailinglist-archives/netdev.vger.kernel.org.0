Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F47478705
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhLQJ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:26:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232507AbhLQJ0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 04:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H09SgEI5trgueTlzLEhCh59O4QiNQQV7tkm5RLuLI+w=; b=1UI0zGlj/ZsfEvW5qXYdjqRxDa
        xDMjgcns3UHC8S7DJnspLB0vqxTrBmRyIdDPJ8TNtUfymHniqbG/PDi79dm7Obva86A7FQAQZv/nB
        5nM+4f/OEdJhENvnX4usoTYn2QNzWEQ6PRA/hoIovNo8WpRen2xG9bRolVEVs4hOGyUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1my9VH-00GogW-Am; Fri, 17 Dec 2021 10:26:15 +0100
Date:   Fri, 17 Dec 2021 10:26:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linus.walleij@linaro.org, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>, olteanv@gmail.com,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and
 RTL8367S
Message-ID: <YbxXt/qQ5CudjkX6@lunn.ch>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216162557.7e279ff6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJq09z4P6fGe6Og4tHAg0qZZ1eR609ytCZj3h_+yp=UD_czh1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z4P6fGe6Og4tHAg0qZZ1eR609ytCZj3h_+yp=UD_czh1Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 05:53:49AM -0300, Luiz Angelo Daros de Luca wrote:
> > On Thu, 16 Dec 2021 17:13:29 -0300 luizluca@gmail.com wrote:
> > > This series refactors the current Realtek DSA driver to support MDIO
> > > connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
> > > switch, with one of those 2 external ports supporting SGMII/High-SGMII.
> >
> > nit: plenty of warnings in patch 3 and patch 8, please try building
> > patch-by-patch with C=1 and W=1. Also some checkpatch warnings that
> > should be fixed (scripts/checkpatch.pl).
> 
> Yes, I got those problems fixed. I'll resend as soon as the
> rtl8365mb/rtl8367c name discussion settles.
> Or should I already send the patches before that one?
> 
> For now, here is my repo:
> https://github.com/luizluca/linux/commits/realtek_mdio_refactor

Please give people time to comment on the patches. Don't do a resend
in less than 24 hours. It is really annoying to do a review on v1 and
then find lower down in your mailbox v2. Also, comments made to v1
sometimes get lost and never make it into v3.

	  Andrew
