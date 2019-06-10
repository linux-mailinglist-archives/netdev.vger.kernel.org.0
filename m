Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B040C3AD6A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfFJDHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:07:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFJDHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:07:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69B1D14EAF65C;
        Sun,  9 Jun 2019 20:07:08 -0700 (PDT)
Date:   Sun, 09 Jun 2019 20:07:07 -0700 (PDT)
Message-Id: <20190609.200707.2055560566669687911.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] RGMII delays for SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608161228.5730-1-olteanv@gmail.com>
References: <20190608161228.5730-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 20:07:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  8 Jun 2019 19:12:26 +0300

> This patchset configures the Tunable Delay Lines of the SJA1105 P/Q/R/S
> switches. These add a programmable phase offset on the RGMII RX and TX
> clock signals and get used by the driver for fixed-link interfaces that
> use the rgmii-id, rgmii-txid or rgmii-rxid phy-modes.
> 
> Tested on a board where RGMII delays were already set up, by adding
> MAC-side delays on the RGMII interface towards a BCM5464R PHY and
> noticing that the MAC now reports SFD, preamble, FCS etc. errors.
> 
> Conflicts trivially in drivers/net/dsa/sja1105/sja1105_spi.c with
> https://patchwork.ozlabs.org/project/netdev/list/?series=112614&state=*
> which must be applied first.

Series applied, thanks.
