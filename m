Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F3110D1BE
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 08:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfK2HNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 02:13:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfK2HNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 02:13:15 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9420146D0E8E;
        Thu, 28 Nov 2019 23:13:14 -0800 (PST)
Date:   Thu, 28 Nov 2019 23:13:14 -0800 (PST)
Message-Id: <20191128.231314.78069224750097408.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net] net: mscc: ocelot: unregister the PTP clock on
 deinit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128112342.2547-1-olteanv@gmail.com>
References: <20191128112342.2547-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 23:13:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 28 Nov 2019 13:23:42 +0200

> +static void ocelot_deinit_timestamp(struct ocelot *ocelot)
> +{
> +	if (ocelot->ptp_clock)
> +		ptp_clock_unregister(ocelot->ptp_clock);
> +}

No need for a helper function, you're calling this in only _one_ place.
