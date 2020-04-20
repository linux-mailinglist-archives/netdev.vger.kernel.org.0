Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB41B1603
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDTTiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725550AbgDTTiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:38:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F49C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:38:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CCA7127FA79C;
        Mon, 20 Apr 2020 12:38:12 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:38:11 -0700 (PDT)
Message-Id: <20200420.123811.752936042291126076.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [EXT] [PATCH net-next v3 0/3] FEC MDIO speedups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <HE1PR0402MB2745765C4F546A8395FC09E8FFD40@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200419220402.883493-1-andrew@lunn.ch>
        <HE1PR0402MB2745765C4F546A8395FC09E8FFD40@HE1PR0402MB2745.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:38:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Mon, 20 Apr 2020 01:42:47 +0000

> From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, April 20, 2020 6:04 AM
>> This patchset gives a number of speedups for MDIO with the FEC.
>> Replacing interrupt driven with polled IO brings a big speedup due to the
>> overheads of interrupts compared to the short time interval.
>> Clocking the bus faster, when the MDIO targets supports it, can double the
>> transfer rate. And suppressing the preamble, if devices support it, makes each
>> transaction faster.
>> 
>> By default the MDIO clock remains 2.5MHz and preables are used. But these
>> can now be controlled from the device tree. Since these are generic
>> properties applicable to more than just FEC, these have been added to the
>> generic MDIO binding documentation.
>> 
>> v2:
>> readl_poll_timeout()
>> Add patches to set bus frequency and preamble disable
>> 
>> v3:
>> Add Reviewed tags
>> uS->us
>> readl_poll_timeout_atomic()
>> Extend DT binding documentation
>> 
>> Andrew Lunn (3):
>>   net: ethernet: fec: Replace interrupt driven MDIO with polled IO
>>   net: ethernet: fec: Allow configuration of MDIO bus speed
>>   net: ethernet: fec: Allow the MDIO preamble to be disabled
> 
> The v3 version seems good.
> Thanks, Andrew.
> 
> Acked-by: Fugang Duan <fugang.duan@nxp.com>

Series applied, thanks everyone.
