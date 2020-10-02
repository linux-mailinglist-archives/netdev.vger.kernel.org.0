Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFF281E85
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJBWks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:40:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA4C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:40:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F72111E48E47;
        Fri,  2 Oct 2020 15:23:59 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:40:46 -0700 (PDT)
Message-Id: <20201002.154046.1512763172573450468.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/9] Offload tc-flower to mscc_ocelot switch
 using VCAP chains
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:24:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri,  2 Oct 2020 15:02:19 +0300

> The purpose of this patch is to add more comprehensive support for flow
> offloading in the mscc_ocelot library and switch drivers.
> 
> The design (with chains) is the result of this discussion:
> https://lkml.org/lkml/2020/6/2/203
> 
> I have tested it on Seville VSC9953 and Felix VSC9959, but it should
> also work on Ocelot-1 VSC7514.

Series applied, thank you.
