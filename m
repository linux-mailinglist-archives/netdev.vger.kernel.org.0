Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887934230BD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJET2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:28:17 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:49120 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhJET2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:28:16 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru DE5662084023
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 12/12] ravb: Update/Add comments
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-13-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <983e7d02-ae9e-0c30-a7b8-f94855e7927b@omp.ru>
Date:   Tue, 5 Oct 2021 22:26:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-13-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

> This patch update/add the following comments
> 
> 1) Fix the typo AVB->DMAC in comment, as the code following the comment
>    is for GbEthernet DMAC in ravb_dmac_init_gbeth()

   ; not needed at the end of the comment. :-)

> 
> 2) Update the comment "PAUSE prohibition"-> "EMAC Mode: PAUSE
>    prohibition; Duplex; TX; RX;" in ravb_emac_init_gbeth()
> 
> 3) Document PFRI register bit, as it is only supported for
>    R-Car Gen3 and RZ/G2L.

   Not a good idea to do 3 different things in 1 patch... I know I said that (2) isn't worth
a separate patch but I meant that it shouldbe done as a part of a lrger ravb_emac_init_gbeth()
change. Sorry for not being clear enough...

> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> RFC changes:
>  * New patch.
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 2 +-
>  drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index dfbbda3681f8..4a057005a470 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
>  	/* Receive frame limit set register */
>  	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
>  
> -	/* PAUSE prohibition */
> +	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; */

   No need for ; after RX.

[...]

MBR, Sergey
