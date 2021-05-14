Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE18380E85
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhENQ7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:59:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhENQ7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=skB8FOzbhvQvufWUzW63XRlh1hW+g9TPFkTho/bPVwk=; b=wjgmefZ4JoxuBAkEfJsORkh5ZK
        lU/uLsVOL4GEL6h49X5uTwgW15AGd4AdgUiGGp7uf4hyuEIYG6GeW8FMm1Un72Ofm9SrJMuLNHX1R
        1PZhOOYDcZB86knq7depKfFRvmFp+D79k8Pg1bRParZG8ufWoQAWWZCfG+W0XfYmFBY8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhb8x-004DEL-Kv; Fri, 14 May 2021 18:58:31 +0200
Date:   Fri, 14 May 2021 18:58:31 +0200
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
Subject: Re: [RFC PATCH net-next v5 18/25] net: dsa: qca8k: dsa: qca8k:
 protect MASTER busy_wait with mdio mutex
Message-ID: <YJ6sNxsSyK9BNaLt@lunn.ch>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-19-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-19-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 04:04:53AM +0200, Ansuel Smith wrote:
> MDIO_MASTER operation have a dedicated busy wait that is not protected
> by the mdio mutex. This can cause situation where the MASTER operation
> is done and a normal operation is executed between the MASTER read/write
> and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
> address this issue by binding the lock for the whole MASTER operation
> and not only the mdio read/write common operation.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
