Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4C294E22
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442212AbgJUN6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 09:58:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404241AbgJUN6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 09:58:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVEcs-002pEL-Ns; Wed, 21 Oct 2020 15:58:02 +0200
Date:   Wed, 21 Oct 2020 15:58:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexaundru.ardelean@analog.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, ardeleanalex@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH 1/2] net: phy: adin: clear the diag clock and set
 LINKING_EN during autoneg
Message-ID: <20201021135802.GM139700@lunn.ch>
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021135140.51300-1-alexandru.ardelean@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 04:51:39PM +0300, Alexandru Ardelean wrote:
> The LINKING_EN bit is always cleared during reset. Initially it was set
> during the downshift setup, because it's in the same register as the
> downshift retry count (PHY_CTRL1).

Hi Alexandru

For those of us how have not read the datasheet, could you give a
brief explanation what LINKING_EN does?
 
> This change moves the handling of LINKING_EN from the downshift handler to
> the autonegotiation handler. Also, during autonegotiation setup, the
> diagnostics clock is cleared.

And what is the diagnostics clock used for?

    Andrew
