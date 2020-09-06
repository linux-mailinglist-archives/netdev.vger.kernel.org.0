Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD78E25F03F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIFTey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgIFTex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:34:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B83A2080A;
        Sun,  6 Sep 2020 19:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599420893;
        bh=kNSWg5ml9f8BCpyLU0jDgp5KmkbvgDfUFDHlg08Zsz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LqiPNfGBYmqfucaPza5XGNssrMi7hALx4S0fQzQ22egLBmZSg0hPSem9RLC1iQQ9m
         j8BxJ4UsXI7e9PLUP6pk4HfBS9P24MSW9G00lvFgF2RBMaQCOSRlkjiqhUcobGhlCd
         1XdmGxWJNt9TDnl655PPn+K1XvdLp2aSTB2tRgq4=
Date:   Sun, 6 Sep 2020 12:34:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH] net: dsa: rtl8366: Properly clear member
 config
Message-ID: <20200906123451.4ab26ee5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACRpkdYyaQtptvaTUieEsSyHCB+PYHvgmzNfvhuaJ-Lc9dreFA@mail.gmail.com>
References: <20200905103233.16922-1-linus.walleij@linaro.org>
        <20200906104058.1b0ac9bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACRpkdYyaQtptvaTUieEsSyHCB+PYHvgmzNfvhuaJ-Lc9dreFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 21:23:37 +0200 Linus Walleij wrote:
> On Sun, Sep 6, 2020 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat,  5 Sep 2020 12:32:33 +0200 Linus Walleij wrote:  
> > > When removing a port from a VLAN we are just erasing the
> > > member config for the VLAN, which is wrong: other ports
> > > can be using it.
> > >
> > > Just mask off the port and only zero out the rest of the
> > > member config once ports using of the VLAN are removed
> > > from it.
> > >
> > > Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>  
> >
> > I see you labeled this for net-net, but it reads like a fix, is it not?
> >
> > Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> >
> > Like commit 15ab7906cc92 ("net: dsa: rtl8366: Fix VLAN semantics") had?  
> 
> Yes you're right, also it is pretty separate from the other patches to
> this driver so there shouldn't be any annoying conflicts.
> 
> If you're applying the patch could you add it
> in the process, or do you want me to resend?

Done & applied to net, thank you!
