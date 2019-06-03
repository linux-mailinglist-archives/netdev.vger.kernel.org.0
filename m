Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12AF3334C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfFCPRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:17:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50796 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfFCPRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 11:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xFwBYG7SdqXKgZZYEMf08gs6wnoE+RwPrCR4htN2Jjk=; b=TxMXepwwRNInWvxV/IqZlkzP7L
        CGMhYoDa2BT8bwOu7fDiTtjM2hkdVn1KpHBxZ8qZXZG526+H0AaWmuEVzmi08p7kOW1woRXb+LkDy
        4T2ghfc0/QIzqz56yO8QVdjAnzc+5F88F+vAiba4+mAQESWmJBwTYFZx+QrewTWnhExw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXohs-000662-AG; Mon, 03 Jun 2019 17:17:04 +0200
Date:   Mon, 3 Jun 2019 17:17:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 09/10] dt-bindings: net: dsa: marvell: add
 "marvell,mv88e6250" compatible string
Message-ID: <20190603151704.GH19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-10-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-10-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:23PM +0000, Rasmus Villemoes wrote:
> The mv88e6250 has port_base_addr 0x8 or 0x18 (depending on
> configuration pins), so it constitutes a new family and hence needs
> its own compatible string.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
