Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614693BD785
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhGFNRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 09:17:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231446AbhGFNRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 09:17:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FgSwl+vt6yhOhFcOgOIsTSsug1bfQPQBGC4dSbjBr3k=; b=wTsQlNVpwwK2kk939IfezTvalz
        H8ULy8ZEECblZSpZNeUv31cquuP5FHQFI8H4+JGNu7HzvRsFK/3pPM2XLcEgvtLKGMrgh5zRCss5d
        8UgURlfBM7qCzOHFq2Y7fUcZMtlkZyV3C7N8Ixffj57BaAMm3/Xzmsfr95q95rl4zxK0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m0ku9-00CNzP-7C; Tue, 06 Jul 2021 15:14:25 +0200
Date:   Tue, 6 Jul 2021 15:14:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        mohammad.athari.ismail@intel.com
Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is
 enabled in shutdown
Message-ID: <YORXMSmvqwYg7QA9@lunn.ch>
References: <20210706090209.1897027-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706090209.1897027-1-pei.lee.ling@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 05:02:09PM +0800, Ling Pei Lee wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> PHY WOL requires WOL interrupt event to trigger the WOL signal
> in order to wake up the system. Hence, the PHY driver should not
> disable the interrupt during shutdown if PHY WOL is enabled.

If the device is being used to wake the system up, why is it being
shutdown?

	Andrew
