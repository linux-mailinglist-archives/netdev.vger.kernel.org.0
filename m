Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263EE291832
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgJRQBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:01:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgJRQBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:01:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUB74-002JoV-EZ; Sun, 18 Oct 2020 18:00:50 +0200
Date:   Sun, 18 Oct 2020 18:00:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201018160050.GC456889@lunn.ch>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-2-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013021858.20530-2-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 03:18:57PM +1300, Chris Packham wrote:
> When a port is configured with 'managed = "in-band-status"' don't force
> the link up, the switch MAC will detect the link status correctly.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
