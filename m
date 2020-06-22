Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56B4203910
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgFVOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:24:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52410 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgFVOYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 10:24:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnNN9-001fvo-09; Mon, 22 Jun 2020 16:24:31 +0200
Date:   Mon, 22 Jun 2020 16:24:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/7] net: phy: add backplane kr driver support
Message-ID: <20200622142430.GP279339@lunn.ch>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 04:35:21PM +0300, Florinel Iordache wrote:
> Add support for backplane kr generic driver including link training
> (ieee802.3ap/ba) and fixed equalization algorithm

Hi Florinel

This is still a PHY device. I don't remember any discussions which
resolved the issues of if at the end of the backplane there is another
PHY.

It makes little sense to repost this code until we have this problem
discussed and a way forward decided on. It fits into the discussion
Russell and Ioana are having about representing PCS drivers. Please
contribute to that.

	Andrew
