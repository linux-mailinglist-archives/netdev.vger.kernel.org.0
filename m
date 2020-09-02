Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9580825B4E8
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgIBT6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:58:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgIBT6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 15:58:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDYtr-00Cvub-8f; Wed, 02 Sep 2020 21:58:31 +0200
Date:   Wed, 2 Sep 2020 21:58:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dp83867: Fix WoL SecureOn password
Message-ID: <20200902195831.GH3050651@lunn.ch>
References: <20200902192704.9220-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902192704.9220-1-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 02:27:04PM -0500, Dan Murphy wrote:
> Fix the registers being written to as the values were being over written
> when writing the same registers.
> 
> Fixes: caabee5b53f5 ("net: phy: dp83867: support Wake on LAN")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
