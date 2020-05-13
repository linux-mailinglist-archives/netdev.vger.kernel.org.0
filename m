Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60F1D1E1B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390246AbgEMSzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMSzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:55:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F556C061A0C;
        Wed, 13 May 2020 11:55:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BB54127D484C;
        Wed, 13 May 2020 11:55:12 -0700 (PDT)
Date:   Wed, 13 May 2020 11:55:08 -0700 (PDT)
Message-Id: <20200513.115508.257148925010604442.davem@davemloft.net>
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
Subject: Re: [PATCH v2 net-next 0/3] net: dsa: felix: tc taprio and CBS
 offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
References: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 11:55:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date: Wed, 13 May 2020 10:25:07 +0800

> This patch series support tc taprio and CBS hardware offload according
> to IEEE 802.1Qbv and IEEE-802.1Qav on VSC9959.
> 
> v1->v2 changes:
>  - Move port_qos_map_init() function to be common felix codes.
>  - Keep const for dsa_switch_ops structs, add felix_port_setup_tc
>    function to call port_setup_tc of felix.info.
>  - fix code style for cbs_set, rename variables.

Series applied, thank you.
