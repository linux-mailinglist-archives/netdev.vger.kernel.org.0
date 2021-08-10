Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074B33E5083
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhHJBIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:08:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233980AbhHJBIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 21:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bvmo5UfwiQpHA6brdftMr04aULt0QksCI0h/EbuT6FU=; b=c3m1HjJ7xG9lDa2reQbJIb2kQY
        1wx4wWN+Ks2muBcNELCr8uBfgeYs93Ek8tnk9O/gc4wRpLUhZpXKVpmgQkLUkngtN3cR1Vwm2JjmT
        RYcfPEpKVrd4ORepnxaFND+JrGB96ZX239YdWVJY2UKcssbaHk/KtzSb/Af13tZeaFsI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDGFD-00Go8O-Fq; Tue, 10 Aug 2021 03:07:51 +0200
Date:   Tue, 10 Aug 2021 03:07:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: create a helper for locating
 EtherType DSA headers on TX
Message-ID: <YRHRZ0rLWPfSnzWt@lunn.ch>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809115722.351383-5-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 02:57:22PM +0300, Vladimir Oltean wrote:
> Create a similar helper for locating the offset to the DSA header
> relative to skb->data, and make the existing EtherType header taggers to
> use it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
