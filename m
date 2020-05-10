Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B16A1CCB9B
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgEJOox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:44:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgEJOow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nWBu9EfRK92bWu4L6NcmkllAgp/afCH3vUgEI7xeS6k=; b=WL2UJNwUmIezKnjo+nlrmh9pxl
        jIA/WtMcoULkXswDXCZYbPgdqG3DsC99oi/HQR3MIuxFvYFQT8SdOweqnGyHGii+iNzU1fxRCZ2Tv
        MkTFB4Zx0w7sLWONTPWUSXZlrrTcLPkBK3MUJ1owPSQbtqrQZQB9kyk8Va+4c2CxCUz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXnCF-001iBj-AP; Sun, 10 May 2020 16:44:51 +0200
Date:   Sun, 10 May 2020 16:44:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 4/4] net: phy: bcm54140: add cable diagnostics
 support
Message-ID: <20200510144451.GJ362499@lunn.ch>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509223714.30855-5-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 12:37:14AM +0200, Michael Walle wrote:
> Use the generic cable tester functions from bcm-phy-lib to add cable
> tester support.
> 
> 100m cable, A/B/C/D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: Open Circuit
>   Pair: Pair B, result: Open Circuit
>   Pair: Pair C, result: Open Circuit
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair A, fault length: 106.60m
>   Pair: Pair B, fault length: 103.32m
>   Pair: Pair C, fault length: 104.96m
>   Pair: Pair D, fault length: 106.60m
> 
> 1m cable, A/B connected, pair C shorted, D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short within Pair
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair C, fault length: 0.82m
>   Pair: Pair D, fault length: 1.64m
> 
> 1m cable, A/B connected, pair C shorted with D:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short to another pair
>   Pair: Pair D, result: Short to another pair
>   Pair: Pair C, fault length: 1.64m
>   Pair: Pair D, fault length: 1.64m
> 
> The granularity of the length measurement seems to be 82cm.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
