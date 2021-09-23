Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7794162BF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242397AbhIWQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:09:17 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:49066 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242417AbhIWQJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:09:16 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 617F420E63F9
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <e54aa4c9-9438-bd99-559a-6aaa3676d733@omp.ru>
Date:   Thu, 23 Sep 2021 19:07:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:07 PM, Biju Das wrote:

> Rename the variable "no_ptp_cfg_active" with "no_gptp" with inverted
> checks and "ptp_cfg_active" with "ccc_gac".

   That's not exactly rename, no? At least for the 1st case...

> There is no functional change.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  4 ++--
>  drivers/net/ethernet/renesas/ravb_main.c | 25 ++++++++++++------------
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 7363abae6e59..0ce0c13ef8cb 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1000,8 +1000,8 @@ struct ravb_hw_info {
>  	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
> -	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
> -	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */
> +	unsigned no_gptp:1;		/* AVB-DMAC does not support gPTP feature */

   Judging on the flag usage (which ensues using logical not in every case), I'd suggest to
invert this flag and call it 'gptp'...

[...]

MBR, Sergey
