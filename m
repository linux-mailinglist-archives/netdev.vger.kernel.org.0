Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB72646A4C0
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346172AbhLFSlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:41:18 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53988 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbhLFSlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:41:17 -0500
Received: from [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984] (unknown [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 1A7EA1F44BDB;
        Mon,  6 Dec 2021 18:37:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638815867; bh=UJ4dzG2H92zS8UAj3Ao2G6J/BUSYnW5zk7rraGi3LaQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UiiCqymEBKMmzi63PmNRXoCdwDbobSuZgmgYbbWY3VNuYrzm24EYuqMxMq+zepNkX
         4XMMyt0cECRabtJkkEY4MQ9k2Hw2/3ZxncY/QIJmFTvXiHslNBTfMYyTJEQyoe6IdE
         9vQq7S329OuchUQ3t0C0GM/czhXukIVJLQvhQ54yTh86W6mj0UudXPTdhZ+/9tfPcB
         Yu76uOd544gxqA5VVAiTaKjUo5ao3Neo8t1qEElg7mzA7p7uBnTswoKgLYUdYvgXN0
         mxsT3Ruy04n8pE1WMbafD2tldtRezduuk9XPpSmZXM/vla1HXQFS30j9BABwGeZhpN
         SdD71+f8wsdNw==
Message-ID: <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
Subject: Re: mv88e6240 configuration broken for B850v3
From:   Martyn Welch <martyn.welch@collabora.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Date:   Mon, 06 Dec 2021 18:37:44 +0000
In-Reply-To: <20211206183147.km7nxcsadtdenfnp@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
         <YapE3I0K4s1Vzs3w@lunn.ch>
         <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
         <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
         <20211206183147.km7nxcsadtdenfnp@skbuf>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-06 at 20:31 +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 06:26:25PM +0000, Martyn Welch wrote:
> > On Mon, 2021-12-06 at 17:44 +0000, Martyn Welch wrote:
> > > On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > > > > Hi Andrew,
> > > > 
> > > > Adding Russell to Cc:
> > > > 
> > > > > I'm currently in the process of updating the GE B850v3 [1] to
> > > > > run
> > > > > a
> > > > > newer kernel than the one it's currently running. 
> > > > 
> > > > Which kernel exactly. We like bug reports against net-next, or
> > > > at
> > > > least the last -rc.
> > > > 
> > > 
> > > I tested using v5.15-rc3 and that was also affected.
> > > 
> > 
> > I've just tested v5.16-rc4 (sorry - just realised I previously
> > wrote
> > v5.15-rc3, it was v5.16-rc3...) and that was exactly the same.
> 
> Just to clarify: you're saying that you're on v5.16-rc4 and that if
> you
> revert commit 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink
> will
> control"), the link works again?
> 

Correct

> It is a bit strange that the external ports negotiate at 10Mbps/Full,
> is that the link speed you intend the ports to work at?

Yes, that's 100% intentional due to what's connected to to those ports
and the environment it works in.

Martyn
