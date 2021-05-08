Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68F37735D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhEHR0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 13:26:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhEHR0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 13:26:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfQhs-003Ho6-Pe; Sat, 08 May 2021 19:25:36 +0200
Date:   Sat, 8 May 2021 19:25:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix a crash if ->get_sset_count() fails
Message-ID: <YJbJkKi7/P5Xkz9v@lunn.ch>
References: <YJaSe3RPgn7gKxZv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJaSe3RPgn7gKxZv@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 04:30:35PM +0300, Dan Carpenter wrote:
> If ds->ops->get_sset_count() fails then it "count" is a negative error
> code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
> error code is type promoted to a very high value and the loop will
> corrupt memory until the system crashes.
> 
> Fix this by checking for error codes and changing the type of "i" to
> just int.
> 
> Fixes: badf3ada60ab ("net: dsa: Provide CPU port statistics to master netdev")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
