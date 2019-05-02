Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553321201E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEBQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:27:08 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49587 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEBQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:27:07 -0400
X-Originating-IP: 90.66.53.80
Received: from localhost (lfbn-1-3034-80.w90-66.abo.wanadoo.fr [90.66.53.80])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id F196BE000A;
        Thu,  2 May 2019 16:27:00 +0000 (UTC)
Date:   Thu, 2 May 2019 18:27:00 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] MIPS: generic: Add police related options
 to ocelot_defconfig
Message-ID: <20190502162700.GC22550@piout.net>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-4-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502094029.22526-4-joergen.andreasen@microchip.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joergen,

On 02/05/2019 11:40:29+0200, Joergen Andreasen wrote:
> Add default support for ingress qdisc, matchall classification
> and police action on MSCC Ocelot.
> 

This patch should be separated from the series as this doesn't have any
dependencies and should go through the MIPS tree.

> Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>
> ---
>  arch/mips/configs/generic/board-ocelot.config | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/mips/configs/generic/board-ocelot.config b/arch/mips/configs/generic/board-ocelot.config
> index 5e53b4bc47f1..5c7360dd819c 100644
> --- a/arch/mips/configs/generic/board-ocelot.config
> +++ b/arch/mips/configs/generic/board-ocelot.config
> @@ -25,6 +25,13 @@ CONFIG_SERIAL_OF_PLATFORM=y
>  CONFIG_NETDEVICES=y
>  CONFIG_NET_SWITCHDEV=y
>  CONFIG_NET_DSA=y
> +CONFIG_NET_SCHED=y
> +CONFIG_NET_SCH_INGRESS=y
> +CONFIG_NET_CLS_MATCHALL=y
> +CONFIG_NET_CLS_ACT=y
> +CONFIG_NET_ACT_POLICE=y
> +CONFIG_NET_ACT_GACT=y
> +
>  CONFIG_MSCC_OCELOT_SWITCH=y
>  CONFIG_MSCC_OCELOT_SWITCH_OCELOT=y
>  CONFIG_MDIO_MSCC_MIIM=y
> -- 
> 2.17.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
