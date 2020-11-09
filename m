Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A42ABF20
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgKIOrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:47:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgKIOrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 09:47:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kc8Rd-0066BU-T1; Mon, 09 Nov 2020 15:46:57 +0100
Date:   Mon, 9 Nov 2020 15:46:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhangxiaoxu <zhangxiaoxu5@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix memleak in
 mv88e6xxx_region_atu_snapshot
Message-ID: <20201109144657.GH1258576@lunn.ch>
References: <20201109144416.1540867-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109144416.1540867-1-zhangxiaoxu5@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 09:44:16AM -0500, zhangxiaoxu wrote:
> When mv88e6xxx_fid_map return error, we lost free the table.
> 
> Fix it.
> 
> Fixes: bfb255428966 ("net: dsa: mv88e6xxx: Add devlink regions")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhangxiaoxu <zhangxiaoxu5@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
