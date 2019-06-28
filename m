Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E637C5A0E2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfF1Qbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:31:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1Qbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:31:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F49E14E038E1;
        Fri, 28 Jun 2019 09:31:46 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:31:45 -0700 (PDT)
Message-Id: <20190628.093145.147690081871250387.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/3] Better PHYLINK compliance for SJA1105
 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628100542.hmzqnp4bsnkikcvv@shell.armlinux.org.uk>
References: <20190627214637.22366-1-olteanv@gmail.com>
        <20190628100542.hmzqnp4bsnkikcvv@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:31:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 28 Jun 2019 11:05:42 +0100

> On Fri, Jun 28, 2019 at 12:46:34AM +0300, Vladimir Oltean wrote:
>> After discussing with Russell King, it appears this driver is making a
>> few confusions and not performing some checks for consistent operation.
>> 
>> Changes in v2:
>> - Removed redundant print in the phylink_validate callback (in 2/3).
>> 
>> Vladimir Oltean (3):
>>   net: dsa: sja1105: Don't check state->link in phylink_mac_config
>>   net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK
>>     reports
>>   net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK
>> 
>>  drivers/net/dsa/sja1105/sja1105_main.c | 56 +++++++++++++++++++++++++-
>>  1 file changed, 54 insertions(+), 2 deletions(-)
> 
> Thanks.  For the whole series:
> 
> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Series applied, thanks all.
