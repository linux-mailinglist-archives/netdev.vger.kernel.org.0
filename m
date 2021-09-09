Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A49405A09
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 17:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbhIIPNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 11:13:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232656AbhIIPNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 11:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=niaeqZaNsF+3HiF9vj5OJbvnbel2Bcw/8LJY/TM97Mo=; b=n/9bsXn5UrMsSlpqZim60OFYTg
        nCzPCJN1rFfv6IFskGvfUIb/5S817wgn94vMa+ULN9O2wiro8N6uc9x9M+w2+FZdJDeA8Mlataoi4
        iuMUFr8oYon9PNauEi+pLgr6GtSF4HcdbOnQaxe8o6NVIIAeKheu2kKKptqEv79xFask=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOLiQ-005w1r-En; Thu, 09 Sep 2021 17:11:50 +0200
Date:   Thu, 9 Sep 2021 17:11:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <YTokNsh6mohaWvH0@lunn.ch>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew: the switch is not on a hat, the device tree part I use is:

And this is not an overlay. It is all there at boot?

I was just thinking that maybe the Ethernet interface gets opened at
boot, and overlay is loaded, and the interface is opened a second
time. I don't know of anybody using DSA with overlays, so that could
of been the key difference which breaks it for you.

Your decompiled DT blob looks O.K.

    Andrew
