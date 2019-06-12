Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC81142E3E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfFLSBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:01:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfFLSBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:01:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90FD71527F8C9;
        Wed, 12 Jun 2019 11:01:42 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:01:42 -0700 (PDT)
Message-Id: <20190612.110142.1987648912531453321.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Deal with non-existing
 PHY/fixed-link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610193150.22231-1-f.fainelli@gmail.com>
References: <20190610193150.22231-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:01:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 10 Jun 2019 12:31:49 -0700

> We need to specifically deal with phylink_of_phy_connect() returning
> -ENODEV, because this can happen when a CPU/DSA port does connect
> neither to a PHY, nor has a fixed-link property. This is a valid use
> case that is permitted by the binding and indicates to the switch:
> auto-configure port with maximum capabilities.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
