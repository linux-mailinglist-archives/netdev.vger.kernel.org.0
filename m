Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3992F16AE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbhAKN4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbhAKN4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:56:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A21DC061786;
        Mon, 11 Jan 2021 05:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4EFw0oAHCpZpwVi8T4aoUbYDN24+hywjYSLIVVld9J8=; b=1tDsVBAhI42EDyWVShCkITD09
        5gsmbTgQIYURjcVuc1Isfmu68ZdyDspCYKlGDC5fDQWsyGNE/gCiHjpJ5Dcant/EvaOMcKpu9DjRG
        2bAhhvy9q82+Of3Plq46F0ZUZMYK8aKjc/59aMgueg+FX4lc6QiBRUVZ5yvy725VQGQVwsI16OHtI
        rsusLQLXigiKXDEqIIwnK6pDhrwG06Uh7wSE47s6Dx1Ct5FE85TSq6EAX9JdiZ6AtN0gFPl2rKv3y
        zAk3/yZva5xb/yMSWWCMz+6g080Vc/w9dUq4vC6Fybu48pULyvHfEuEWqotb7JJCE+x1Wwm0qRBK9
        wsykURg5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46612)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyxf7-00076T-Or; Mon, 11 Jan 2021 13:55:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyxf3-0005Hw-AD; Mon, 11 Jan 2021 13:55:09 +0000
Date:   Mon, 11 Jan 2021 13:55:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next 2/2] drivers: net: dsa: mt7530: MT7530 optional
 GPIO support
Message-ID: <20210111135509.GT1551@shell.armlinux.org.uk>
References: <20210111054428.3273-1-dqfext@gmail.com>
 <20210111054428.3273-3-dqfext@gmail.com>
 <20210111110407.GR1551@shell.armlinux.org.uk>
 <CALW65jaqciOiRxJxzPiEADgpmKa7-q2QfQnBdaVMcOa5YDHjRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jaqciOiRxJxzPiEADgpmKa7-q2QfQnBdaVMcOa5YDHjRA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 09:40:00PM +0800, DENG Qingfang wrote:
> On Mon, Jan 11, 2021 at 7:04 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > FYI, Documentation/driver-api/gpio/consumer.rst says:
> >
> >   For output GPIOs, the value provided becomes the initial output value.
> >   This helps avoid signal glitching during system startup.
> >
> > Setting the pin to be an output, and then setting its initial value
> > does not avoid the glitch. You may wish to investigate whether you
> > can set the value before setting the pin as an output to avoid this
> > issue.
> >
> 
> So, setting the Output Enable bit _after_ setting the direction and
> initial value should avoid this issue. Right?

It depends on the hardware. I don't know how your hardware works, so
I can't say whether doing anything will result in correct behaviour,
or even work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
