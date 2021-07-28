Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616983D9701
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhG1UrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:47:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhG1UrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 16:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DSvv8LIPRr9ug5P+a+r+gNRgiQTXUee1sTAcpCWmlKU=; b=FZ4YirmSQiz5Tse6WjHNLfePyk
        7ghIj+W6MxSoZsPQFgRHle3NmvKc9T7o7hgQb2C1ySlvpHFyzM3KsINI47TUBFnff0mHBEGQk/Zrw
        BhJm9ZLgYoQyBDc0MwJDiLeD1jCe0Z6eYgM3zaVdOHjagFG/oKQ6PUsjt24NYeZWVSV0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8qSJ-00FESH-Bw; Wed, 28 Jul 2021 22:47:07 +0200
Date:   Wed, 28 Jul 2021 22:47:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQHCSxgraGsXsz0J@lunn.ch>
References: <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
 <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
 <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
 <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Many thanks for the link; I will build and install it on the target. Hope it
> will work with the older kernel (5.4.114) we're using.

Probably not. You need

commit b71a8d60252111d89dccba92ded7470faef16460
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Sun Oct 4 18:12:57 2020 +0200

    net: dsa: mv88e6xxx: Add per port devlink regions
    
    Add a devlink region to return the per port registers.
    
    Signed-off-by: Andrew Lunn <andrew@lunn.ch>
    Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
    Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

5.4 we released in 2019-11-24.

When debugging issues like this, you really should be using a modern
kernel. At minimum 5.13, better still, net-next.

	Andrew
