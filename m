Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5420377388
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhEHSDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:03:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:03:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfRHd-003I5V-Ip; Sat, 08 May 2021 20:02:33 +0200
Date:   Sat, 8 May 2021 20:02:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <YJbSOYBxskVdqGm5@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> Fix mixed whitespace and tab for define spacing.

Please add a patch [0/28] which describes the big picture of what
these changes are doing.

Also, this series is getting big. You might want to split it into two,
One containing the cleanup, and the second adding support for the new
switch.

	Andrew
