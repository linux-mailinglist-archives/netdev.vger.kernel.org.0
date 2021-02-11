Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27D3318CF7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhBKOG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:06:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhBKOEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 09:04:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lACZU-005aVH-BD; Thu, 11 Feb 2021 15:03:52 +0100
Date:   Thu, 11 Feb 2021 15:03:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <YCU5SCxePltSl2Oj@lunn.ch>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRkidArVGlesPfy@lunn.ch>
 <5176f496-facb-d7b0-9f4e-a9e4b8974178@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5176f496-facb-d7b0-9f4e-a9e4b8974178@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 10:21:03AM +0000, Jon Hunter wrote:
> 
> On 10/02/2021 22:56, Andrew Lunn wrote:
> > On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
> >> Hi,
> >>
> >> This email was triggered by this other email[1].
> > 
> > And it appears the Tegra194 Jetson Xavier uses the Marvell 88E1512
> > PHY. So ensure the Marvell driver is available, and it should get
> > probed in the usual way, the fallback driver will not be needed.
> 
> 
> Yes that is correct. Enabling the Marvell PHY does fix this indeed and
> so I can enable that as part of our testsuite. We were seeing the same
> warning on Tegra186 Jetson TX2 and enabling the BRCM PHY resolves that
> as well. I will ensure that these are enabled going forward.

Hi Jon

As an added bonus, you might of gained an additional HWMON temperature
sensor for the PHY, some PHY statistics, and maybe cable diagnostics.
Just by using the correct driver for the hardware.

	     Andrew
