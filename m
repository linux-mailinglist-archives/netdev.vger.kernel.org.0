Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491D533467A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhCJSSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:18:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhCJSSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 13:18:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lK3Pf-00ADWA-Vx; Wed, 10 Mar 2021 19:18:27 +0100
Date:   Wed, 10 Mar 2021 19:18:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: Re: [EXT] Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Message-ID: <YEkNc5ZsiJsy0GfZ@lunn.ch>
References: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
 <YEjq1eehhA+8MYwH@lunn.ch>
 <CO6PR18MB3873813B7C30F2BE0095C061B0919@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873813B7C30F2BE0095C061B0919@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Make it patch series? I can split it to 2/3 patches.

I don't think that will be needed. The helpers should be pretty
obvious.

	Andrew
