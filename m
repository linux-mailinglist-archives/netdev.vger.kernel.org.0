Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1288366AAB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbhDUMYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:24:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239814AbhDUMYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:24:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZBtB-000JLX-5P; Wed, 21 Apr 2021 14:23:29 +0200
Date:   Wed, 21 Apr 2021 14:23:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: Fix off-by-one in VTU
 devlink region size
Message-ID: <YIAZQS0pk8OUGrKU@lunn.ch>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
 <20210421120454.1541240-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421120454.1541240-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 02:04:53PM +0200, Tobias Waldekranz wrote:
> In the unlikely event of the VTU being loaded to the brim with 4k
> entries, the last one was placed in the buffer, but the size reported
> to devlink was off-by-one. Make sure that the final entry is available
> to the caller.
> 
> Fixes: ca4d632aef03 ("net: dsa: mv88e6xxx: Export VTU as devlink region")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

The snapshot code gets it right, but not this :-(

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
