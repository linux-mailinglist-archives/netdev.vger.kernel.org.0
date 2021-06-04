Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB15739B98B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhFDNKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhFDNKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 09:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CECAE613DE;
        Fri,  4 Jun 2021 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622812123;
        bh=KI99+JpsSvrw/euAyvNNi9O6oeNyFP4qHjSyCwvSlsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cwDwX+tS8ztwlxFXP6nshZOawWQO8SbaFMCfrOyqsMPfUX1n8+J2G+RneHWflCh1a
         0zkWyZrvDvWeZK1vqjqeP+RkH700F0GLMFks1jb4ATAiivgkZfLSvYzCg1YCWapqJn
         myAZfGfHsRR2HCBeVxqGHuLG3Vw5n9gmeLe7IXNc=
Date:   Fri, 4 Jun 2021 15:08:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next v2 4/4] staging: mt7621-dts: enable MT7530
 interrupt controller
Message-ID: <YLol2QFW9XMG57m0@kroah.com>
References: <20210519033202.3245667-1-dqfext@gmail.com>
 <20210519033202.3245667-5-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033202.3245667-5-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 11:32:02AM +0800, DENG Qingfang wrote:
> Enable MT7530 interrupt controller in the MT7621 SoC.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> v1 -> v2:
> No changes.
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
