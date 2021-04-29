Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5C436F24F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhD2Vvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:51:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232441AbhD2Vve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 17:51:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcEYW-001iUv-TS; Thu, 29 Apr 2021 23:50:44 +0200
Date:   Thu, 29 Apr 2021 23:50:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/1] net: phy: marvell: enable downshift by default
Message-ID: <YIsqNMYKD0gsg/q5@lunn.ch>
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

Hi Maxim

Please expand the commit message. It does not explain enough, which is
why i asked the odd question. Maybe something like:

A number of PHYs support the PHY tunable to set and get
downshift. However, only 88E1116R enables downshift by default. Extend
this default enabled to all the PHYs that support the downshift
tunable.

     Andrew
