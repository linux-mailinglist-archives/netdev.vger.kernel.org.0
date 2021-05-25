Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8B39019B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhEYNFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:05:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhEYNFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NutMlFJ/fmTgqJowgK0BEqirQCjnyHyDPGr2qQythGw=; b=lZL1cVsdLFJko9BsCdyoQWd3l5
        5a/QtqQDoRbjL203srzoB4IaxMhj0OCVtZQaraZhd/yJFQjPEOrDCqWJ9VUCW9wqC/Pwg4HKMwGWQ
        Xy+9x/2vW7ueyVv8ajWZshKc0Z9pgOy7sFau0o63u6UbOYl0tgJ+tYUZ/DM6s7u7vde8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llWir-006Aha-3r; Tue, 25 May 2021 15:03:49 +0200
Date:   Tue, 25 May 2021 15:03:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 2/2] net: phy: abort loading yt8511 driver in unsupported
 modes
Message-ID: <YKz1teE92Q3/+JMj@lunn.ch>
References: <20210525122615.3972574-1-pgwipeout@gmail.com>
 <20210525122615.3972574-3-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525122615.3972574-3-pgwipeout@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 08:26:15AM -0400, Peter Geis wrote:
> While investigating the clang `ge` uninitialized variable report, it was
> discovered the default switch would have unintended consequences. Due to
> the switch to __phy_modify, the driver would modify the ID values in the
> default scenario.
> 
> Fix this by promoting the interface mode switch and aborting when the
> mode is not a supported RGMII mode.
> 
> This prevents the `ge` and `fe` variables from ever being used
> uninitialized.
> 
> Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Peter Geis <pgwipeout@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
