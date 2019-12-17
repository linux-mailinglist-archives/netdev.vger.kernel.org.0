Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52AF122FFE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLQPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:19:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfLQPTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x0tBjWTkEEptH8DLU+ypbOyVxnViHKO5btFKlu5EOBI=; b=rCel2fFho5IWcRSftdFqOdw0ZY
        B0qWQJCifklk6JBoK/HkOxDnF0nlAzm0VHYYmVJwP2iu711wM3mDcfwM6bcqA8rTVMu7EAJ6Rh7LT
        MZf7Fh7lz/prfHO1hCDYXqtCuMO7CvGFR9AqwaLvCt16kn5vBrBuzCNsNES+xVcN40+o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEdF-0002ME-UB; Tue, 17 Dec 2019 16:19:29 +0100
Date:   Tue, 17 Dec 2019 16:19:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 09/11] net: mdio: of: Register discovered MII
 time stampers.
Message-ID: <20191217151929.GG17965@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <4abb37f501cb51bf84cb5512f637747d73dcd3cc.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4abb37f501cb51bf84cb5512f637747d73dcd3cc.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:24AM -0800, Richard Cochran wrote:
> When parsing a PHY node, register its time stamper, if any, and attach
> the instance to the PHY device.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
