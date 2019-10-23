Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C90E0F43
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfJWAhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:37:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbfJWAht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 20:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TU819J1nYAJT7kXIeVDc4iBUayH385+8drZ5l+1iewo=; b=Z1eW3Hlw+GinkSu3zrkfDCrqEr
        8R160A9D9Lyb2q9CNTXCNuSqYAmHMA919m5P0tWfrafSdHR/D/ISocQ0GW1lkgUokk9nthAOO9K1K
        6VGx/4v4csarXG/1eSCm2R1rHx7s6Bank6AVSULV3EUM1SBGRFCNRP3nBsHM7SflFAAI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN4ej-0004JK-2g; Wed, 23 Oct 2019 02:37:41 +0200
Date:   Wed, 23 Oct 2019 02:37:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4 4/5] net: dsa: add support for Atheros AR9331 TAG
 format
Message-ID: <20191023003741.GF5707@lunn.ch>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022055743.6832-5-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 07:57:42AM +0200, Oleksij Rempel wrote:
> Add support for tag format used in Atheros AR9331 build-in switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
