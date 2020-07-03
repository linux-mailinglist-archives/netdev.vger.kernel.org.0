Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF81213B61
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGCNxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:53:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgGCNxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 09:53:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jrM7q-003TFk-DH; Fri, 03 Jul 2020 15:53:10 +0200
Date:   Fri, 3 Jul 2020 15:53:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     trix@redhat.com
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sky2: initialize return of gm_phy_read
Message-ID: <20200703135310.GD807334@lunn.ch>
References: <20200703133359.22723-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703133359.22723-1-trix@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 06:33:59AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this garbage return
> 
> drivers/net/ethernet/marvell/sky2.c:208:2: warning: Undefined or garbage value returned to caller [core.uninitialized.UndefReturn]
>         return v;
>         ^~~~~~~~
> 
> static inline u16 gm_phy_read( ...
> {
> 	u16 v;
> 	__gm_phy_read(hw, port, reg, &v);
> 	return v;
> }
> 
> __gm_phy_read can return without setting v.
> 
> So handle similar to skge.c's gm_phy_read, initialize v.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
