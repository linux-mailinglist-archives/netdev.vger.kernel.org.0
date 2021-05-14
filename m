Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B798E380E79
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhENQ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:56:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhENQ45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=w3keSl2B5HgY8u/QNhVAdBWXdaZChxL4GYwk3d3Bt/I=; b=pkPGNdFp0/TinMHDFJvi2VQDog
        Yz85B3/d08OvpdpjI1I4DUA2tuANT3hJN52PRpGayMnACKys0xpHzS8hocv1oF19CAvy6jht9Cq3G
        ZeLaAGp60RyIOQHXodiItqEhHcEzHfchQaeoCSiQnc8lfoIcmPYK2zWO1IAsGCUgtatE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhb6C-004DCm-RJ; Fri, 14 May 2021 18:55:40 +0200
Date:   Fri, 14 May 2021 18:55:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next v5 16/25] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJ6rjPqVEnyuOS9Q@lunn.ch>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-17-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 04:04:51AM +0200, Ansuel Smith wrote:
> The legacy qsdk code used a different delay instead of the max value.
> Qsdk use 1 ms for rx and 2 ms for tx. Make these values configurable

More likely to be ns not ms.

> using the standard rx/tx-internal-delay-ps ethernet binding and apply
> qsdk values by default. The connected gmac doesn't add any delay so no
> additional delay is added to tx/rx.
> On this switch the delay is actually in ms so value should be in the
> 1000 order. Any value converted from ps to ms by deviding it by 1000
> as the switch max value for delay is 3ms.

dividing.

And more ms that should be ns. 

    Andrew
