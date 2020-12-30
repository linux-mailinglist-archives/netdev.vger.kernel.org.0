Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61FC2E7A8E
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgL3PoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:44:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgL3PoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:44:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuddV-00F3Ab-E9; Wed, 30 Dec 2020 16:43:41 +0100
Date:   Wed, 30 Dec 2020 16:43:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 1/2] net: phy: micrel: Add KS8851 PHY support
Message-ID: <X+ygLXjVd3rr8Vbf@lunn.ch>
References: <20201230125358.1023502-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230125358.1023502-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 01:53:57PM +0100, Marek Vasut wrote:
> The KS8851 has a reduced internal PHY, which is accessible through its
> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> in Micrel switches, except the PHY ID Low/High registers are swapped.

Can you intercept the reads in the KS8851 driver and swap them back
again? The mv88e6xxx driver does something similar. The mv88e6393
family of switches have PHYs with the Marvell OUI but no device ID. So
the code traps these reads and provides an ID.

    Andrew
