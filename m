Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A24C3E0D89
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhHEFJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:09:51 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:53147 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhHEFJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 01:09:50 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GgGr01Wbyz9sX3;
        Thu,  5 Aug 2021 07:09:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kTNZBjq_5kT6; Thu,  5 Aug 2021 07:09:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GgGr00ZZWz9sX2;
        Thu,  5 Aug 2021 07:09:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DEF4E8B7AE;
        Thu,  5 Aug 2021 07:09:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Qzm1XvzM1lJv; Thu,  5 Aug 2021 07:09:35 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7912D8B76A;
        Thu,  5 Aug 2021 07:09:35 +0200 (CEST)
Subject: Re: [PATCH v4 08/10] net/ps3_gelic: Rename no to descr_count
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1627068552.git.geoff@infradead.org>
 <07e42ec30037d514c1d63f33efe4642364d89802.1627068552.git.geoff@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b0782290-02d6-7f97-0ed3-c5e2a2c70450@csgroup.eu>
Date:   Thu, 5 Aug 2021 07:09:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <07e42ec30037d514c1d63f33efe4642364d89802.1627068552.git.geoff@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/07/2021 à 22:31, Geoff Levand a écrit :
> In an effort to make the PS3 gelic driver easier to maintain, rename
> the gelic_card_init_chain parameter 'no' to 'descr_count'.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

CHECK:SPACING: spaces preferred around that '*' (ctx:WxV)
#40: FILE: drivers/net/ethernet/toshiba/ps3_gelic_net.c:344:
+	memset(descr, 0, sizeof(*descr) *descr_count);
  	                                ^


NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit fdbd3f08a0b1 ("net/ps3_gelic: Rename no to descr_count") has style problems, please review.


> ---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index e55aa9fecfeb..60fcca5d20dd 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -325,7 +325,7 @@ static void gelic_card_free_chain(struct gelic_card *card,
>    * @card: card structure
>    * @chain: address of chain
>    * @start_descr: address of descriptor array
> - * @no: number of descriptors
> + * @descr_count: number of descriptors
>    *
>    * we manage a circular list that mirrors the hardware structure,
>    * except that the hardware uses bus addresses.
> @@ -334,16 +334,16 @@ static void gelic_card_free_chain(struct gelic_card *card,
>    */
>   static int gelic_card_init_chain(struct gelic_card *card,
>   	struct gelic_descr_chain *chain, struct gelic_descr *start_descr,
> -	int no)
> +	int descr_count)
>   {
>   	int i;
>   	struct gelic_descr *descr;
>   	struct device *dev = ctodev(card);
>   
>   	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(descr, 0, sizeof(*descr) *descr_count);
>   
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0; i < descr_count; i++, descr++) {
>   		descr->link.size = sizeof(struct gelic_hw_regs);
>   		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>   		descr->link.cpu_addr =
> @@ -361,7 +361,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>   	start_descr->prev = (descr - 1);
>   
>   	descr = start_descr;
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0; i < descr_count; i++, descr++) {
>   		descr->hw_regs.next_descr_addr =
>   			cpu_to_be32(descr->next->link.cpu_addr);
>   	}
> 
