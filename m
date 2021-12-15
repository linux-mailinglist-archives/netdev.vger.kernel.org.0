Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3F475512
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhLOJXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:23:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241129AbhLOJXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 04:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+zVtvNYbXivg34WLxycg7O1rtuc4e8poX+c0u7FpMkY=; b=irXRlSt+hiag+XSrNj+AzxWMmB
        MPa8lb4Wknhjdh3DOKMVwpwywL5O1rA+CsfCIQr4KUPp2+PuUzjyQJKnBbZcr1L0I5dTjGOYF6mp2
        pzjeP4014czJ0E3dyZZwv+gnnjPY+X+HuhL4hj+K2M4wXqn7wHmfX0BKRX8i9Jqha4+Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxQVK-00GcsB-G8; Wed, 15 Dec 2021 10:23:18 +0100
Date:   Wed, 15 Dec 2021 10:23:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuration
Message-ID: <Ybm0Bgclc0FP/Q3f@lunn.ch>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
 <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the suggestion. The proposed solution also doesn't work. Still get -110 error.

Please can you trace where this -110 comes from. Am i looking at the
wrong poll call?

Thanks
	Andrew
