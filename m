Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAC233096
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfFCNG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:06:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfFCNG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 09:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fypb0A6OA46EoyKfK6f76wA+kx+ipWKp3Lwp1Yf8N04=; b=Y8qgTAkt1xsqb6Yi9BDBfBTrCI
        edtdDLNgff7T/Qk4vB6NDxvPcZWm138KLF2z4n3GZarRX5M+dA/6gXBrdqu5FBh4quOo+bz023HKc
        LR5leZidv6qKXKJNjd7fAH9HIkwI4kgx7y/eAFz321geiTGycl916L+8W6AFHpOQAtfE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXmfu-0004wr-9Y; Mon, 03 Jun 2019 15:06:54 +0200
Date:   Mon, 3 Jun 2019 15:06:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net 1/1] net: dsa: sja1105: Fix link speed not working
 at 100 Mbps and below
Message-ID: <20190603130654.GF17267@lunn.ch>
References: <20190602233137.17930-1-olteanv@gmail.com>
 <20190602233137.17930-2-olteanv@gmail.com>
 <20190603005053.GH19081@lunn.ch>
 <CA+h21hoaOLassrEjHGoOortesCBkTUamCw8Efoc=vobwgwH25w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoaOLassrEjHGoOortesCBkTUamCw8Efoc=vobwgwH25w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> If I made the change you're suggesting, I would need to replace 0 with
> SPEED_UNKNOWN and thus I would conflict with this net-next change:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=af7cd0366ee994e8b35985d407261dc0ed9dfb4d
> 
> I think it's simpler to wait until Dave merges net into net-next and
> then submit this 1000 -> SPEED_1000 change as a net-next one, and let
> the fix itself go into net.
> Sounds ok?

Fine.

	Andrew
