Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF05E2E8EC4
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 00:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbhACXKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 18:10:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbhACXKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 18:10:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwCVQ-00FrAN-Dp; Mon, 04 Jan 2021 00:09:48 +0100
Date:   Mon, 4 Jan 2021 00:09:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan =?iso-8859-1?Q?S=F8rensen?= 
        <stefan.sorensen@spectralink.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] phy: dp83640: select CONFIG_CRC32
Message-ID: <X/JOvC8ImrU+GG8D@lunn.ch>
References: <20210103213645.1994783-1-arnd@kernel.org>
 <20210103213645.1994783-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103213645.1994783-2-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 10:36:18PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without crc32, this driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/phy/dp83640.o: in function `match':
> dp83640.c:(.text+0x476c): undefined reference to `crc32_le'
> 
> Fixes: 539e44d26855 ("dp83640: Include hash in timestamp/packet matching")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
