Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CBA21AAEF
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgGIWsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:48:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIWsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 18:48:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtfKo-004OMI-WA; Fri, 10 Jul 2020 00:48:06 +0200
Date:   Fri, 10 Jul 2020 00:48:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709224806.GD1014141@lunn.ch>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
 <20200709221800.yqnvepm3p57gfxym@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709221800.yqnvepm3p57gfxym@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And, while we're at it: context switches from a VM to a host are
> expensive. And the PHY library polls around 5 MDIO registers per PHY
> every second.

Just wire up the interrupt. That stops all polling.

It would however be good to have details of what QEMU wants.

	Andrew
