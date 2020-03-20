Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3C18C63D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCTEDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:03:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTEDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:03:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5E3A158F9845;
        Thu, 19 Mar 2020 21:03:29 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:03:29 -0700 (PDT)
Message-Id: <20200319.210329.1045324274739014303.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mscc: add missing check on a
 phy_write return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319124819.369431-1-antoine.tenart@bootlin.com>
References: <20200319124819.369431-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:03:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Thu, 19 Mar 2020 13:48:19 +0100

> Commit a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
> introduced a call to 'phy_write' storing its return value to a variable
> called 'ret'. But 'ret' never was checked for a possible error being
> returned, and hence was not used at all. Fix this by checking the return
> value and exiting the function if an error was returned.
> 
> As this does not fix a known bug, this commit is mostly cosmetic and not
> sent as a fix.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thanks.
