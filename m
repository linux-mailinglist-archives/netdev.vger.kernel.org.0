Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2022B08E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgGWNca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:32:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGWNc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 09:32:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jybKi-006WF2-Nz; Thu, 23 Jul 2020 15:32:24 +0200
Date:   Thu, 23 Jul 2020 15:32:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: dsa: mv88e6xxx: Support jumbo configuration on
 6190/6190X
Message-ID: <20200723133224.GD1553578@lunn.ch>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-3-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723035942.23988-3-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:59:40PM +1200, Chris Packham wrote:
> The MV88E6190 and MV88E6190X both support per port jumbo configuration
> just like the other GE switches. Install the appropriate ops.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
