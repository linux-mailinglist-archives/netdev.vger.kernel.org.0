Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE42CDA15
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLCPYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:24:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgLCPYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:24:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkqSQ-00A3ZL-1W; Thu, 03 Dec 2020 16:23:46 +0100
Date:   Thu, 3 Dec 2020 16:23:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        mcroce@microsoft.com, sven.auhagen@voleatech.de,
        atenart@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Fix error return code in mvpp2_open()
Message-ID: <20201203152346.GP2324545@lunn.ch>
References: <20201203141806.37966-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203141806.37966-1-wanghai38@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:18:06PM +0800, Wang Hai wrote:
> Fix to return negative error code -ENOENT from invalid configuration
> error handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 4bb043262878 ("net: mvpp2: phylink support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
