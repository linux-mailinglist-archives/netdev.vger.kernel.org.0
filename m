Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46D3377383
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhEHSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:00:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:00:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfREw-003I3q-9R; Sat, 08 May 2021 19:59:46 +0200
Date:   Sat, 8 May 2021 19:59:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 11/28] net: dsa: qca8k: handle error from
 qca8k_busy_wait
Message-ID: <YJbRkmmyyELryutv@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 02:29:01AM +0200, Ansuel Smith wrote:
> Propagate errors from qca8k_busy_wait instead of hardcoding return
> value.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
