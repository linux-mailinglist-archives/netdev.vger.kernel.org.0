Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95D546DE72
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhLHWiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:38:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhLHWio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:38:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KT8zihdhKAoV1XZHQDmGAQKcIuF9X+UsZXF7WKzRG7c=; b=MibhDPlGDyp+WF8lD9n10iVNSB
        QEyajOFaBY00chgdCGZQzCysXiUgS46loBeaAIWa/7uZv/9EPdfTVVu9aLo8gAeizVrL+ATPQQZKR
        YAipF81B3m7duBJpVTWVoUBYcpVXVUDJRO0A3N3SdyWYeTrgQE/61xRIRRmiJlfukJjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv5WY-00FvVJ-UM; Wed, 08 Dec 2021 23:34:54 +0100
Date:   Wed, 8 Dec 2021 23:34:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 3/3] udp6: Use Segment Routing Header for
 dest address if present
Message-ID: <YbEzDrDR1uTCT4Xo@lunn.ch>
References: <20211208173831.3791157-1-andrew@lunn.ch>
 <20211208173831.3791157-4-andrew@lunn.ch>
 <CA+FuTScYqNfFmuYXJZHi24gs-Vyx8AJW8tPuehW75wdO4arPgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScYqNfFmuYXJZHi24gs-Vyx8AJW8tPuehW75wdO4arPgw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* If the packet which invoked an ICMP error contains an SRH return
> > + * the true destination address from within the SRH, otherwise use the
> > + * destination address in the IP header.
> > + */
> 
> nit: the above describes the behavior of the caller, not the function.
> The function returns NULL if no SRH is found.

Yes, i will fix that.

Thanks
	Andrew
