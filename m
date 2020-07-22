Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2E22A066
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgGVT7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgGVT7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:59:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42592C0619DC;
        Wed, 22 Jul 2020 12:59:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF56611FFC80E;
        Wed, 22 Jul 2020 12:43:07 -0700 (PDT)
Date:   Wed, 22 Jul 2020 12:59:52 -0700 (PDT)
Message-Id: <20200722.125952.2002253965644109632.davem@davemloft.net>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH] net: dsa: ocelot: Add support for QinQ Operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722055048.6129-1-hongbo.wang@nxp.com>
References: <20200722055048.6129-1-hongbo.wang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 12:43:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hongbo.wang@nxp.com
Date: Wed, 22 Jul 2020 13:50:48 +0800

> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index c69d9592a2b7..12b46cb6549c 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -132,9 +132,13 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
>  {
>  	struct ocelot *ocelot = ds->priv;
>  	u16 flags = vlan->flags;
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u16 vid;
>  	int err;

Please use reverse christmas tree ordering for local variables.
