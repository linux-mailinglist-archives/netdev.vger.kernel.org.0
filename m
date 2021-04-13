Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37A35E0B6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhDMN6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:58:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhDMN6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:58:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWJXv-00GTsG-JC; Tue, 13 Apr 2021 15:57:39 +0200
Date:   Tue, 13 Apr 2021 15:57:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@oss.nxp.com>
Cc:     "Radu-nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHWjU2LEXTqEYCmZ@lunn.ch>
References: <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch>
 <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
 <YHWc/afcY3OXyhAo@lunn.ch>
 <b4f05b61-34f5-e6bf-4373-fa907fc7da4d@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f05b61-34f5-e6bf-4373-fa907fc7da4d@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, we can agree that there will not be a perfect naming. Would it be a
> possibility to rename the existing TJA11xx driver to TJA1100-1-2 or is that
> unwanted?

It is generally a bad idea. It makes back porting fixing harder if the
file changes name.

> If nxp-c45.c is to generic (I take from your comments that' your
> conclusion), we could at least lean towards nxp-c45-bt1.c? Unfortunately,
> the product naming schemes are not sufficiently methodical to have a a good
> driver name based on product names.

And what does bt1 stand for?

How about nxp-c45-tja11xx.c. It is not ideal, but it does at least
give an indication of what devices it does cover, even if there is a
big overlap with nxp-tja11xx.c, in terms of pattern matching. And if
you do decide to have a major change of registers, your can call the
device tja1201 and have a new driver nxp-c45-tja12xx.

       Andrew
