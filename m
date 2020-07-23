Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8085822B08A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGWNcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:32:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGWNb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 09:31:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jybKF-006WER-3Q; Thu, 23 Jul 2020 15:31:55 +0200
Date:   Thu, 23 Jul 2020 15:31:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: dsa: mv88e6xxx: MV88E6097 does not support
 jumbo configuration
Message-ID: <20200723133155.GC1553578@lunn.ch>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-2-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723035942.23988-2-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:59:39PM +1200, Chris Packham wrote:
> The MV88E6097 chip does not support configuring jumbo frames. Prior to
> commit 5f4366660d65 only the 6352, 6351, 6165 and 6320 chips configured
> jumbo mode. The refactor accidentally added the function for the 6097.
> Remove the erroneous function pointer assignment.
> 
> Fixes: 5f4366660d65 ("net: dsa: mv88e6xxx: Refactor setting of jumbo frames")
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
