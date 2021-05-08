Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BA37738F
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEHSNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:13:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:13:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfRRC-003IAa-QQ; Sat, 08 May 2021 20:12:26 +0200
Date:   Sat, 8 May 2021 20:12:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJbUignEbuthTguo@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-19-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-19-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +
> +	/* Assume only one port with rgmii-id mode */

Since this is only valid for the RGMII port, please look in that
specific node for these properties.

	 Andrew
