Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF55179BA3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgCDWTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:19:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387931AbgCDWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:19:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68DB615AD78F9;
        Wed,  4 Mar 2020 14:19:46 -0800 (PST)
Date:   Wed, 04 Mar 2020 14:19:45 -0800 (PST)
Message-Id: <20200304.141945.1878221621159657674.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 0/2] Allow unknown unicast traffic to CPU
 for Felix DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200229145003.23751-1-olteanv@gmail.com>
References: <20200229145003.23751-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 14:19:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 29 Feb 2020 16:50:01 +0200

> This is the continuation of the previous "[PATCH net-next] net: mscc:
> ocelot: Workaround to allow traffic to CPU in standalone mode":
> 
> https://www.spinics.net/lists/netdev/msg631067.html
> 
> Following the feedback received from Allan Nielsen, the Ocelot and Felix
> drivers were made to use the CPU port module in the same way (patch 1),
> and Felix was made to additionally allow unknown unicast frames towards
> the CPU port module (patch 2).

Series applied, thanks.
