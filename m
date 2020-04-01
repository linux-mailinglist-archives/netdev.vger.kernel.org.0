Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8619AD2D
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgDANyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:54:01 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58218 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732234AbgDANyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 09:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KFhV2UZ1QUeqQAPCpDDLL0+91AMfXaoyijKaEXgGzIY=; b=fnDcE6abKzVxhl9ZGBMpXssli
        ri2oaCkFt+nCgH287oWa8apOr+xksbpkGFfxlzcPkpeHxINJFOY9t42B8es8Dx/oEdrxfNQgfndVN
        uaP82cf/A+5a7ptHJSv5x+hFALd9BSrkQ+QGfEKOvgZnKCvQk3N4+zTQHVxXgTaxRO9JrEQGMBw13
        cKHOidL5ttYwpxxGsp/XB+kuNzrKOD7fqmXefFFsUAhi6wvXrrEKquyK9vH66IUbe3V8HBqTvswjU
        wzRn3J+9TDaYLQ64JrRFQbYzneOd11I6eEq3QV+XMdhoKexDJvnTXBEwS4a4oDw0m5Q1Ts+8EHFs7
        9wyDXLRIQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:40122)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJdoX-0006Fp-NP; Wed, 01 Apr 2020 14:53:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJdoU-0000kO-Uc; Wed, 01 Apr 2020 14:53:50 +0100
Date:   Wed, 1 Apr 2020 14:53:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Baruch Siach <baruch@tkos.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shmuel Hazan <sh@tkos.co.il>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
Message-ID: <20200401135350.GT25745@shell.armlinux.org.uk>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
 <DB8PR04MB6828927ED67036524362F369E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200401130321.GA71179@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401130321.GA71179@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 03:03:21PM +0200, Andrew Lunn wrote:
> For a general purpose OS like Linux, this will have to change before
> we support firmware upload. We need generic firmware, which is the
> same everywhere, and then PHY specific blobs for things like the eye
> configuration. This basic idea has been around a long time in the WiFi
> world. The Atheros WiFi chipsets needed a board specific blod which
> contains calibration data, path losses on the board, in order that the
> transmit power could be tuned to prevent it sending too much power out
> the aerial.

The reality of that approach is that people scratch around on the
Internet trying to find the board specific data file, and end up
using anything they can get their hands on just to have something
that works - irrespective of whether or not it is the correct one.

It's a total usability failure to have board specific blobs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
