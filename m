Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00621B166E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgDTT7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:59:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgDTT7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IenJLzSXfljqUnwI6f2LmOPl098dU4FmnNGkgxIKLtQ=; b=Fpq5Iyq9c5gyEsLnX3LwmYMS6V
        Yc/7ycCap5ByvRA2zbnwfEBJh7ih8qu3IUCtTsF8eW7kLMWUhLNqa1OVyHdUMFfwNCkzOxLBJEc+I
        5sHK4+mbCbudNvaHikm6xYfF2DHQCj2t6DcP4042z+UNyToKSqXaR8C+Z8uQV6r337hI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQcZo-003tS9-Te; Mon, 20 Apr 2020 21:59:32 +0200
Date:   Mon, 20 Apr 2020 21:59:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/3] dt-bindings: net: mdio: Document common
 properties
Message-ID: <20200420195932.GJ917792@lunn.ch>
References: <20200420180723.27936-1-f.fainelli@gmail.com>
 <20200420180723.27936-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420180723.27936-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:07:22AM -0700, Florian Fainelli wrote:
> Some of the properties pertaining to the broken turn around or resets
> were only documented in ethernet-phy.yaml while they are applicable
> across all MDIO devices and not Ethernet PHYs specifically which are a
> superset.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
