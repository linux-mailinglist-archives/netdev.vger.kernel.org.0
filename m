Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98AD11411B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 13:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfLEM7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 07:59:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLEM7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 07:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/0aTrAYFDCdx3wtof9edhAMQ2FL2u0uO/LRSKah6g6c=; b=OQmnRFj/HL0ufNSTVpFIwkQTn5
        eHCSUAzOxu/tzYVrw0M3m2yw8wfi3m3/cNrUnAGMDjZQP8zx3/ebo8dMj6YLDIV7k1wOEWgXStnnW
        kE31rgT1+SdAUFe35ZryhR3Y2MLRKiprxeNWyaU+pacjxrZR6d4FwCsIIR+uDikppE3Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icqim-0007PD-Pq; Thu, 05 Dec 2019 13:59:04 +0100
Date:   Thu, 5 Dec 2019 13:59:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mian Yousaf Kaukab <ykaukab@suse.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tharvey@gateworks.com,
        davem@davemloft.net, rric@kernel.org, sgoutham@cavium.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net v2] net: thunderx: start phy before starting
 autonegotiation
Message-ID: <20191205125904.GB28269@lunn.ch>
References: <20191205094116.4904-1-ykaukab@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205094116.4904-1-ykaukab@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 10:41:16AM +0100, Mian Yousaf Kaukab wrote:
> Since commit 2b3e88ea6528 ("net: phy: improve phy state checking")
> phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
> before calling phy_start_aneg() during probe so that autonegotiation
> is initiated.
> 
> As phy_start() takes care of calling phy_start_aneg(), drop the explicit
> call to phy_start_aneg().
> 
> Network fails without this patch on Octeon TX.
> 
> Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
> Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
