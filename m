Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2032F4FE43B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbiDLPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244097AbiDLPAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:00:30 -0400
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180B953723
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:58:12 -0700 (PDT)
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 3824D1F4B;
        Tue, 12 Apr 2022 14:58:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 72E3B20018;
        Tue, 12 Apr 2022 14:58:08 +0000 (UTC)
Message-ID: <070642693caa4c18282b08714a21026d814cd1a0.camel@perches.com>
Subject: Re: [Patch net-next 3/3] MAINTAINERS: Add maintainers for Microchip
 T1 Phy driver
From:   Joe Perches <joe@perches.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com
Date:   Tue, 12 Apr 2022 07:58:07 -0700
In-Reply-To: <20220412063317.4173-4-arun.ramadoss@microchip.com>
References: <20220412063317.4173-1-arun.ramadoss@microchip.com>
         <20220412063317.4173-4-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 72E3B20018
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: m1xco8uidj5thif6k37k4gprddjjjqq4
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18c+GKq6R78PY4V+EkUEYA/ONBnFdTa+zw=
X-HE-Tag: 1649775488-399066
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 12:03 +0530, Arun Ramadoss wrote:
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fd768d43e048..cede8ccf19b2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12903,6 +12903,12 @@ F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
>  
> +MICROCHIP LAN87xx/LAN937x T1 PHY DRIVER
> +M:	UNGLinuxDriver@microchip.com

Individual people are maintainers.
Random exploder addresses are not maintainers.

Please use an actual person and maybe add something like

M:	Actual name <actual_email@domain.tld>
R:	UNGLinuxDriver@microchip.com

instead

> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/phy/microchip_t1.c
> +
>  MICROCHIP LAN743X ETHERNET DRIVER
>  M:	Bryan Whitehead <bryan.whitehead@microchip.com>
>  M:	UNGLinuxDriver@microchip.com


