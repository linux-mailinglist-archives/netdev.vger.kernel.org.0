Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C62C47AF96
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbhLTPPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:15:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239615AbhLTPNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 10:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RyB3+kF9jgGQv01+nZFU/Byy+c41V2RXJGRIwmyYPyw=; b=MTcAeLiJpPgyRUAU26XPT5nLtO
        +af6aTW7j+l+F+cj4m47z/FOpo1AxocK5bA3SkkF7nOAOfGiyl1xaAKW0ufSuqYZlOK0dawule1xL
        2M/TO3QYhWLz4gPS5ax/JWUSyWjWzgMvbj78GnSMNC/3BTfX0gT+1wm6ZZkXxcaRNSec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzKMD-00H3a5-UP; Mon, 20 Dec 2021 16:13:45 +0100
Date:   Mon, 20 Dec 2021 16:13:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuration
Message-ID: <YcCdqX1bq3nLGHlw@lunn.ch>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
 <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm0Bgclc0FP/Q3f@lunn.ch>
 <CO1PR11MB47715A9B7ADB8AF36066DCE6D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm7jVwNfj01b7S4@lunn.ch>
 <CO1PR11MB47710EE8587C6F4A4D40851ED5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <CO1PR11MB477197B3DACAF00CCF94631ED57B9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB477197B3DACAF00CCF94631ED57B9@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 11:11:32AM +0000, Ismail, Mohammad Athari wrote:
> Hi Andrew,
> 

> As the current genphy_loopback() is not applicable for Marvell
> 88E1510 PHY, should we implement Marvell specific PHY loopback
> function as below?

Yes, that is probably a good solution. We will have to see if other
PHY drivers need this as well. If they do, we might move this simple
implementation into the core. But for the moment, it can be in the
Marvell driver.

	Andrew
