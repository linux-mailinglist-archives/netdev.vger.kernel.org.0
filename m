Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93A929795E
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757759AbgJWWjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 18:39:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S461743AbgJWWjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 18:39:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW5ig-003BXL-AQ; Sat, 24 Oct 2020 00:39:34 +0200
Date:   Sat, 24 Oct 2020 00:39:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: Handle error in serdes_get_regs
Message-ID: <20201023223934.GD745568@lunn.ch>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
 <20201022012516.18720-4-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022012516.18720-4-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 02:25:14PM +1300, Chris Packham wrote:
> If the underlying read operation failed we would end up writing stale
> data to the supplied buffer. This would end up with the last
> successfully read value repeating. Fix this by only writing the data
> when we know the read was good. This will mean that failed values will
> return 0xffff.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
