Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96B36DFA5
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbhD1Tcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:32:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243800AbhD1TcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 15:32:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbpth-001YO9-G1; Wed, 28 Apr 2021 21:30:57 +0200
Date:   Wed, 28 Apr 2021 21:30:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/1] net: phy: marvell: enable downshift by default
Message-ID: <YIm38VYp2CKGdppy@lunn.ch>
References: <20210428124853.926179-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428124853.926179-1-fido_max@inbox.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 03:48:53PM +0300, Maxim Kochetkov wrote:
> Enable downshift for all supported PHYs by default like 88E1116R does.

There are two different mechanisms to set to downshift. And i think
some of the older PHYs don't support it at all. How did you decide on
which method to use for each PHY?

      Andrew
