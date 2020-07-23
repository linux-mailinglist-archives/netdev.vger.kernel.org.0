Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191EF22B091
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgGWNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:34:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGWNej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 09:34:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jybMm-006WGL-FO; Thu, 23 Jul 2020 15:34:32 +0200
Date:   Thu, 23 Jul 2020 15:34:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: Use chip-wide max frame size
 for MTU
Message-ID: <20200723133432.GE1553578@lunn.ch>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-5-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723035942.23988-5-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:59:42PM +1200, Chris Packham wrote:
> Some of the chips in the mv88e6xxx family don't support jumbo
> configuration per port. But they do have a chip-wide max frame size that
> can be used. Use this to approximate the behaviour of configuring a port
> based MTU.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Hi Chris

This patch will need a bit of rework for net-next, but the basic idea
is O.K.

   Andrew
