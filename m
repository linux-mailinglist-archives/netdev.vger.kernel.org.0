Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7362ADF32
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgKJTXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:23:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgKJTXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 14:23:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcZEq-006KQd-Rk; Tue, 10 Nov 2020 20:23:32 +0100
Date:   Tue, 10 Nov 2020 20:23:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add helper to get a chip's
 max_vid
Message-ID: <20201110192332.GI1456319@lunn.ch>
References: <20201110185720.18228-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110185720.18228-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 07:57:20PM +0100, Tobias Waldekranz wrote:
> Most of the other chip info constants have helpers to get at them; add
> one for max_vid to keep things consistent.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

