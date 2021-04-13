Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04A535E0E9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbhDMOFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:05:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237440AbhDMOFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:05:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWJex-00GTwZ-Ph; Tue, 13 Apr 2021 16:04:55 +0200
Date:   Tue, 13 Apr 2021 16:04:55 +0200
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
Message-ID: <YHWlB5ncfPcbLKg7@lunn.ch>
References: <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch>
 <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
 <YHWc/afcY3OXyhAo@lunn.ch>
 <b4f05b61-34f5-e6bf-4373-fa907fc7da4d@oss.nxp.com>
 <YHWjU2LEXTqEYCmZ@lunn.ch>
 <d8910e5f-bdbb-f127-2acb-a6277c53b568@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8910e5f-bdbb-f127-2acb-a6277c53b568@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> nxp-c45-tja11xx is acceptable from my point of view.

Great. Enough bike shedding, nxp-c45-tja11xx it is.

       Andrew
