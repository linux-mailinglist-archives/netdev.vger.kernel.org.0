Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F672F18A9
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388857AbhAKOsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:48:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbhAKOsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 09:48:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyyTt-00HXxb-Mc; Mon, 11 Jan 2021 15:47:41 +0100
Date:   Mon, 11 Jan 2021 15:47:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the
 internal PHY
Message-ID: <X/xlDTUQTLgVoaUE@lunn.ch>
References: <20210111125337.36513-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111125337.36513-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 01:53:37PM +0100, Marek Vasut wrote:
> Unless the internal PHY is connected and started, the phylib will not
> poll the PHY for state and produce state updates. Connect the PHY and
> start/stop it.

Hi Marek

Please continue the conversion and remove all mii_calls.

ks8851_set_link_ksettings() calling mii_ethtool_set_link_ksettings()
is not good, phylib will not know about changes which we made to the
PHY etc.

    Andrew
