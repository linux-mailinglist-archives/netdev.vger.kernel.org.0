Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F690F81CB
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKKU7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:59:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbfKKU7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:59:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95292153D7B23;
        Mon, 11 Nov 2019 12:59:45 -0800 (PST)
Date:   Mon, 11 Nov 2019 12:59:45 -0800 (PST)
Message-Id: <20191111.125945.258530262181023464.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 12:59:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  9 Nov 2019 15:02:46 +0200

> After the nice "change-my-mind" discussion about Ocelot, Felix and
> LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
> we have decided to take the route of reworking the Ocelot implementation
> in a way that is DSA-compatible.
 ...

I'm going to apply this series as-is.

But please address Andrew's feedback about port naming and such.

Thank you.
