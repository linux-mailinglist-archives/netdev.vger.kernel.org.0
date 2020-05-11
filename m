Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CDE1CE95C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgEKXxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728095AbgEKXxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:53:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42667C061A0C;
        Mon, 11 May 2020 16:53:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC934120ED551;
        Mon, 11 May 2020 16:52:59 -0700 (PDT)
Date:   Mon, 11 May 2020 16:52:58 -0700 (PDT)
Message-Id: <20200511.165258.1371001598940636146.davem@davemloft.net>
To:     xiaoliang.yang_1@nxp.com
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH v1 net-next 2/3] net: dsa: felix: Configure Time-Aware
 Scheduler via taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511054332.37690-3-xiaoliang.yang_1@nxp.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
        <20200511054332.37690-3-xiaoliang.yang_1@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 16:53:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date: Mon, 11 May 2020 13:43:31 +0800

> @@ -710,7 +714,7 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
>  	ocelot_port_policer_del(ocelot, port);
>  }
>  
> -static const struct dsa_switch_ops felix_switch_ops = {
> +static struct dsa_switch_ops felix_switch_ops = {
>  	.get_tag_protocol	= felix_get_tag_protocol,
>  	.setup			= felix_setup,
>  	.teardown		= felix_teardown,

There has to be a better way to do this, removing const for operation
structs is very undesirable.
