Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF65278E75
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgIYQaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:30:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYQaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 12:30:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLqbm-00GBRf-Ev; Fri, 25 Sep 2020 18:30:06 +0200
Date:   Fri, 25 Sep 2020 18:30:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        alexander.sverdlin@nokia.com, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ikhoronz@cisco.com>
Subject: Re: [PATCH] net: ethernet: cavium: octeon_mgmt: use phy_start and
 phy_stop
Message-ID: <20200925163006.GB3856392@lunn.ch>
References: <20200925124439.19946-1-ikhoronz@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925124439.19946-1-ikhoronz@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 03:44:39PM +0300, Ivan Khoronzhuk wrote:
> To start also "phy state machine", with UP state as it should be,
> the phy_start() has to be used, in another case machine even is not
> triggered. After this change negotiation is supposed to be triggered
> by SM workqueue.
> 
> It's not correct usage, but it appears after the following patch,
> so add it as a fix.
> 
> Fixes: 74a992b3598a ("net: phy: add phy_check_link_status")
> Signed-off-by: Ivan Khoronzhuk <ikhoronz@cisco.com>
> ---
> 
> Based on net/master

Hi Ivan

In the future, please make the patch subject [PATCH net] to make it
clear which tree it is for.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
