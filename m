Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B36D0CA
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 17:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390698AbfGRPN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 11:13:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390302AbfGRPNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 11:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/e4qJAHtJXmwYKF013t3QPS6FfQWdbnnFMctkcP7TX4=; b=OPXu0I/6Un6hwESiN4Tk81h5Ev
        NvO3HRiepBJc3RHkhtUjjA7r2mvrSy4mIn4XwNWoasMk6TlHF9BeD3PEwKGw/x290iCo/wJdN3B8i
        gM1qaA8v94GyP3eroP2vjZ4IHb+4CY9S1neUlaccB5VnMg+uJEJTYwoWen2I6TVDa5ug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ho85m-0007ZX-M3; Thu, 18 Jul 2019 17:13:10 +0200
Date:   Thu, 18 Jul 2019 17:13:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        piotrs@cadence.com, aniljoy@cadence.com, arthurm@cadence.com,
        stevenh@cadence.com, mparab@cadence.com
Subject: Re: [PATCH v6 0/5] net: macb: cover letter
Message-ID: <20190718151310.GE25635@lunn.ch>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 03:36:31PM +0100, Parshuram Thombare wrote:
> Hello !
> 
> This is 6th version of patch set containing following patches
> for Cadence ethernet controller driver.

Hi Parshuram

One thing which was never clear is how you are testing the features
you are adding. Please could you describe your test setup and how each
new feature is tested using that hardware. I'm particularly interested
in what C45 device are you using? But i expect Russell would like to
know more about SFP modules you are using. Do you have any which
require 1000BaseX, 2500BaseX, or provide copper 1G?

Thanks
	Andrew
