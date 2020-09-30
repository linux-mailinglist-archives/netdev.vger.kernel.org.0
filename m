Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A981127DDBA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgI3B1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgI3B1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:27:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798AAC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 18:27:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD5FD128032A3;
        Tue, 29 Sep 2020 18:10:11 -0700 (PDT)
Date:   Tue, 29 Sep 2020 18:26:58 -0700 (PDT)
Message-Id: <20200929.182658.204585143707913502.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 00/13] HW support for VCAP IS1 and ES0 in
 mscc_ocelot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 18:10:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 30 Sep 2020 01:27:20 +0300

> The patches from RFC series "Offload tc-flower to mscc_ocelot switch
> using VCAP chains" have been split into 2:
> https://patchwork.ozlabs.org/project/netdev/list/?series=204810&state=*
> 
> This is the boring part, that deals with the prerequisites, and not with
> tc-flower integration. Apart from the initialization of some hardware
> blocks, which at this point still don't do anything, no new
> functionality is introduced.
> 
> - Key and action field offsets are defined for the supported switches.
> - VCAP properties are added to the driver for the new TCAM blocks. But
>   instead of adding them manually as was done for IS2, which is error
>   prone, the driver is refactored to read these parameters from
>   hardware, which is possible.
> - Some improvements regarding the processing of struct ocelot_vcap_filter.
> - Extending the code to be compatible with full and quarter keys.
> 
> This series was tested, along with other patches not yet submitted, on
> the Felix and Seville switches.

Series applied, thanks.
