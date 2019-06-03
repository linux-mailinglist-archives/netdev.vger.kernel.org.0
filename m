Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC47332FE
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfFCPBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:01:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729038AbfFCPBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 11:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=alJ1LnKHdTrSERDEsnCav6Cl9EFgdbgEAHodmjMaerw=; b=RBLl4e3b4qaAknaEE/9kgU17EQ
        eiDB8AGRAF4E2p85V5dW0xTKmFGrBQ2JBrwj2swrhf9ZRD+1HPHMhbcik5TBjKueQaSlccq79Rr4K
        yKyC1HT3nezO+EKIbaNcBFbtbrhbaiaN6JGH9/KJ3726yBAqfzGw4LxL1YvjABoTYEBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXoSk-0005yA-1l; Mon, 03 Jun 2019 17:01:26 +0200
Date:   Mon, 3 Jun 2019 17:01:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 06/10] net: dsa: mv88e6xxx: implement
 port_set_speed for mv88e6250
Message-ID: <20190603150126.GE19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-7-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-7-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:19PM +0000, Rasmus Villemoes wrote:
> The data sheet also mentions the possibility of selecting 200 Mbps for
> the MII ports (ports 5 and 6) by setting the ForceSpd field to
> 0x2 (aka MV88E6065_PORT_MAC_CTL_SPEED_200). However, there's a note
> that "actual speed is determined by bit 8 above", and flipping back a
> page, one finds that bits 13:8 are reserved...
> 
> So without further information on what bit 8 means, let's stick to
> supporting just 10 and 100 Mbps on all ports.

200Mbps is also somewhat Marvell Proprietary. I've not seen any other
vendors interfaces supporting it. So i don't think anybody will really
miss it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
