Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520252A0DC2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgJ3Srk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:47:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3Srj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 14:47:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYZQz-004Orv-Cz; Fri, 30 Oct 2020 19:47:33 +0100
Date:   Fri, 30 Oct 2020 19:47:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: qca8k: Fix port MTU setting
Message-ID: <20201030184733.GB1042051@lunn.ch>
References: <20201030183315.GA6736@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030183315.GA6736@earth.li>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 06:33:15PM +0000, Jonathan McDowell wrote:
> The qca8k only supports a switch-wide MTU setting, and the code to take
> the max of all ports was only looking at the port currently being set.
> Fix to examine all ports.
> 
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
