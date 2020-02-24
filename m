Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B54916B500
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBXXVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:21:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXXVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:21:09 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7C2812491B83;
        Mon, 24 Feb 2020 15:21:07 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:21:07 -0800 (PST)
Message-Id: <20200224.152107.301328957100855074.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: Re: [PATCH net-next 05/10] net: mscc: ocelot: don't rely on
 preprocessor for vcap key/action packing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224130831.25347-6-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
        <20200224130831.25347-6-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:21:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 24 Feb 2020 15:08:26 +0200

> +static void vcap_key_set(struct vcap_data *data,
> +			 enum vcap_is2_half_key_field field,
> +			 u32 value, u32 mask)
> +{
> +	struct ocelot *ocelot = data->ocelot;
> +	u32 offset = ocelot->vcap_is2_keys[field].offset;
> +	u32 length = ocelot->vcap_is2_keys[field].length;

I know it is a pain in dependency chains of variables like this, but
please use reverse christmas tree ordering.

And likewise for the rest of your submission.

Thank you.
