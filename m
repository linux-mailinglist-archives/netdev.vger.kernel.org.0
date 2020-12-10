Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1342D5066
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgLJBhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:37:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgLJBhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:37:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knAsm-00B99H-VQ; Thu, 10 Dec 2020 02:36:36 +0100
Date:   Thu, 10 Dec 2020 02:36:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/20] ethernet: ucc_geth: use qe_muram_free_addr()
Message-ID: <20201210013636.GC2638572@lunn.ch>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-8-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205191744.7847-8-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 08:17:30PM +0100, Rasmus Villemoes wrote:
> This removes the explicit NULL checks, and allows us to stop storing
> at least some of the _offset values separately.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

This seems to rely on one of the missing patches. Please don't split
patches like this, it makes review very difficult.

	Andrew
