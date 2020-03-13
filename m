Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28BB18443F
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 11:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCMKBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 06:01:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgCMKBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 06:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6yt4N6aS69xIX5Kbrw2cM1AnDJ8rQ7egHTUgXYLVIAM=; b=v7Cd0vhbgk73eUQFMe9nc6E9C7
        3ZojQM+yAeCEjn8jJ4KVEMXoRVLKVsTeb1lzpIBad8MEl2WK0FmKOV/fYCA6fxvN5WsPGb3GdCnIx
        XbnDeDQucnczXJF/nd1U6aFz3ZVh1PAJnLjNSplWa3kCXbdbmb3UgLNPE9cbnMj1QITg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jCh82-00049X-Ts; Fri, 13 Mar 2020 11:01:18 +0100
Date:   Fri, 13 Mar 2020 11:01:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 1/2] net: dsa: felix: allow the device to be disabled
Message-ID: <20200313100118.GF14553@lunn.ch>
References: <20200312164320.22349-1-michael@walle.cc>
 <CA+h21hoHMxtxUjHthx2ta9CzQbkF_08Svi7wLU99NqJmoEr36Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoHMxtxUjHthx2ta9CzQbkF_08Svi7wLU99NqJmoEr36Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e> IMHO since DSA is already dependent on device tree for PHY bindings,
> it would make more sense to move this there:

That is not really true. You can instantiate a marvell switch using a
platform device. So long any you only have C22 PHYs in a sane
configuration, it will just work. There are boards out there do this,
on x86 platforms without device tree.

	Andrew
