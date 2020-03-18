Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074421897BC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgCRJQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:16:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59744 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgCRJQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:16:22 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jEUoC-0003IN-MM; Wed, 18 Mar 2020 09:16:16 +0000
Subject: Re: [PATCH] bnx2x: fix spelling mistake "pauseable" -> "pausable"
To:     Joe Perches <joe@perches.com>, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200317182921.482606-1-colin.king@canonical.com>
 <8d9544fe6d413cdd600504e48f301e023b99e17b.camel@perches.com>
From:   Colin Ian King <colin.king@canonical.com>
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 mQINBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazcICSjX06e
 fanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZOxbBCTvTitYOy3bjs
 +LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2NoaSEC8Ae8LSSyCMecd22d9Pn
 LR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyBP9GP65oPev39SmfAx9R92SYJygCy0pPv
 BMWKvEZS/7bpetPNx6l2xu9UvwoeEbpzUvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3oty
 dNTWkP6Wh3Q85m+AlifgKZudjZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2m
 uj83IeFQ1FZ65QAiCdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08y
 LGPLTf5wyAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
 zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaByVUv/NsyJ
 FQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQABtCVDb2xpbiBLaW5n
 IDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+iQI2BBMBCAAhBQJOkyQoAhsDBQsJCAcDBRUK
 CQgLBRYCAwEAAh4BAheAAAoJEGjCh9/GqAImsBcP9i6C/qLewfi7iVcOwqF9avfGzOPf7CVr
 n8CayQnlWQPchmGKk6W2qgnWI2YLIkADh53TS0VeSQ7Tetj8f1gV75eP0Sr/oT/9ovn38QZ2
 vN8hpZp0GxOUrzkvvPjpH+zdmKSaUsHGp8idfPpZX7XeBO0yojAs669+3BrnBcU5wW45SjSV
 nfmVj1ZZj3/yBunb+hgNH1QRcm8ZPICpjvSsGFClTdB4xu2AR28eMiL/TTg9k8Gt72mOvhf0
 fS0/BUwcP8qp1TdgOFyiYpI8CGyzbfwwuGANPSupGaqtIRVf+/KaOdYUM3dx/wFozZb93Kws
 gXR4z6tyvYCkEg3x0Xl9BoUUyn9Jp5e6FOph2t7TgUvv9dgQOsZ+V9jFJplMhN1HPhuSnkvP
 5/PrX8hNOIYuT/o1AC7K5KXQmr6hkkxasjx16PnCPLpbCF5pFwcXc907eQ4+b/42k+7E3fDA
 Erm9blEPINtt2yG2UeqEkL+qoebjFJxY9d4r8PFbEUWMT+t3+dmhr/62NfZxrB0nTHxDVIia
 u8xM+23iDRsymnI1w0R78yaa0Eea3+f79QsoRW27Kvu191cU7QdW1eZm05wO8QUvdFagVVdW
 Zg2DE63Fiin1AkGpaeZG9Dw8HL3pJAJiDe0KOpuq9lndHoGHs3MSa3iyQqpQKzxM6sBXWGfk
 EkK5Ag0ETpMkKAEQAMX6HP5zSoXRHnwPCIzwz8+inMW7mJ60GmXSNTOCVoqExkopbuUCvinN
 4Tg+AnhnBB3R1KTHreFGoz3rcV7fmJeut6CWnBnGBtsaW5Emmh6gZbO5SlcTpl7QDacgIUuT
 v1pgewVHCcrKiX0zQDJkcK8FeLUcB2PXuJd6sJg39kgsPlI7R0OJCXnvT/VGnd3XPSXXoO4K
 cr5fcjsZPxn0HdYCvooJGI/Qau+imPHCSPhnX3WY/9q5/WqlY9cQA8tUC+7mgzt2VMjFft1h
 rp/CVybW6htm+a1d4MS4cndORsWBEetnC6HnQYwuC4bVCOEg9eXMTv88FCzOHnMbE+PxxHzW
 3Gzor/QYZGcis+EIiU6hNTwv4F6fFkXfW6611JwfDUQCAHoCxF3B13xr0BH5d2EcbNB6XyQb
 IGngwDvnTyKHQv34wE+4KtKxxyPBX36Z+xOzOttmiwiFWkFp4c2tQymHAV70dsZTBB5Lq06v
 6nJs601Qd6InlpTc2mjd5mRZUZ48/Y7i+vyuNVDXFkwhYDXzFRotO9VJqtXv8iqMtvS4xPPo
 2DtJx6qOyDE7gnfmk84IbyDLzlOZ3k0p7jorXEaw0bbPN9dDpw2Sh9TJAUZVssK119DJZXv5
 2BSc6c+GtMqkV8nmWdakunN7Qt/JbTcKlbH3HjIyXBy8gXDaEto5ABEBAAGJAh8EGAEIAAkF
 Ak6TJCgCGwwACgkQaMKH38aoAiZ4lg/+N2mkx5vsBmcsZVd3ys3sIsG18w6RcJZo5SGMxEBj
 t1UgyIXWI9lzpKCKIxKx0bskmEyMy4tPEDSRfZno/T7p1mU7hsM4owi/ic0aGBKP025Iok9G
 LKJcooP/A2c9dUV0FmygecRcbIAUaeJ27gotQkiJKbi0cl2gyTRlolKbC3R23K24LUhYfx4h
 pWj8CHoXEJrOdHO8Y0XH7059xzv5oxnXl2SD1dqA66INnX+vpW4TD2i+eQNPgfkECzKzGj+r
 KRfhdDZFBJj8/e131Y0t5cu+3Vok1FzBwgQqBnkA7dhBsQm3V0R8JTtMAqJGmyOcL+JCJAca
 3Yi81yLyhmYzcRASLvJmoPTsDp2kZOdGr05Dt8aGPRJL33Jm+igfd8EgcDYtG6+F8MCBOult
 TTAu+QAijRPZv1KhEJXwUSke9HZvzo1tNTlY3h6plBsBufELu0mnqQvHZmfa5Ay99dF+dL1H
 WNp62+mTeHsX6v9EACH4S+Cw9Q1qJElFEu9/1vFNBmGY2vDv14gU2xEiS2eIvKiYl/b5Y85Q
 QLOHWV8up73KK5Qq/6bm4BqVd1rKGI9un8kezUQNGBKre2KKs6wquH8oynDP/baoYxEGMXBg
 GF/qjOC6OY+U7kNUW3N/A7J3M2VdOTLu3hVTzJMZdlMmmsg74azvZDV75dUigqXcwjE=
Message-ID: <7ce6d58f-a2d0-7173-0163-f1e3b5f93e65@canonical.com>
Date:   Wed, 18 Mar 2020 09:16:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8d9544fe6d413cdd600504e48f301e023b99e17b.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2020 03:37, Joe Perches wrote:
> On Tue, 2020-03-17 at 18:29 +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Bulk rename of variables and literal strings. No functional
>> changes.
> 
> I'm not sure either spelling is a "real" word and
> pauseable seems more intelligible and less likely
> to be intended to be a typo of "possible" to me.

It's indeed of marginal benefit. However..

https://www.yourdictionary.com/pausable

Colin

> 
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  .../net/ethernet/broadcom/bnx2x/bnx2x_dcb.c   | 84 +++++++++----------
>>  .../net/ethernet/broadcom/bnx2x/bnx2x_dcb.h   |  6 +-
>>  2 files changed, 45 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
>> index 2c6ba046d2a8..fc15a4864077 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
>> @@ -44,7 +44,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>>  				       struct pg_help_data *help_data,
>>  				       struct dcbx_ets_feature *ets,
>>  				       u32 *pg_pri_orginal_spread);
>> -static void bnx2x_dcbx_separate_pauseable_from_non(struct bnx2x *bp,
>> +static void bnx2x_dcbx_separate_pausable_from_non(struct bnx2x *bp,
>>  				struct cos_help_data *cos_data,
>>  				u32 *pg_pri_orginal_spread,
>>  				struct dcbx_ets_feature *ets);
>> @@ -80,7 +80,7 @@ static void bnx2x_pfc_set(struct bnx2x *bp)
>>  	/* Tx COS configuration */
>>  	for (i = 0; i < bp->dcbx_port_params.ets.num_of_cos; i++)
>>  		/*
>> -		 * We configure only the pauseable bits (non pauseable aren't
>> +		 * We configure only the pausable bits (non pausable aren't
>>  		 * configured at all) it's done to avoid false pauses from
>>  		 * network
>>  		 */
>> @@ -290,7 +290,7 @@ static void bnx2x_dcbx_get_ets_feature(struct bnx2x *bp,
>>  
>>  	/* Clean up old settings of ets on COS */
>>  	for (i = 0; i < ARRAY_SIZE(bp->dcbx_port_params.ets.cos_params) ; i++) {
>> -		cos_params[i].pauseable = false;
>> +		cos_params[i].pausable = false;
>>  		cos_params[i].strict = BNX2X_DCBX_STRICT_INVALID;
>>  		cos_params[i].bw_tbl = DCBX_INVALID_COS_BW;
>>  		cos_params[i].pri_bitmask = 0;
>> @@ -335,12 +335,12 @@ static void  bnx2x_dcbx_get_pfc_feature(struct bnx2x *bp,
>>  	   !GET_FLAGS(error, DCBX_LOCAL_PFC_ERROR | DCBX_LOCAL_PFC_MISMATCH |
>>  			     DCBX_REMOTE_PFC_TLV_NOT_FOUND)) {
>>  		bp->dcbx_port_params.pfc.enabled = true;
>> -		bp->dcbx_port_params.pfc.priority_non_pauseable_mask =
>> +		bp->dcbx_port_params.pfc.priority_non_pausable_mask =
>>  			~(pfc->pri_en_bitmap);
>>  	} else {
>>  		DP(BNX2X_MSG_DCB, "DCBX_LOCAL_PFC_DISABLED\n");
>>  		bp->dcbx_port_params.pfc.enabled = false;
>> -		bp->dcbx_port_params.pfc.priority_non_pauseable_mask = 0;
>> +		bp->dcbx_port_params.pfc.priority_non_pausable_mask = 0;
>>  	}
>>  }
>>  
>> @@ -1080,8 +1080,8 @@ bnx2x_dcbx_print_cos_params(struct bnx2x *bp,
>>  	DP(BNX2X_MSG_DCB,
>>  	   "pfc_fw_cfg->dcb_version %x\n", pfc_fw_cfg->dcb_version);
>>  	DP(BNX2X_MSG_DCB,
>> -	   "pdev->params.dcbx_port_params.pfc.priority_non_pauseable_mask %x\n",
>> -	   bp->dcbx_port_params.pfc.priority_non_pauseable_mask);
>> +	   "pdev->params.dcbx_port_params.pfc.priority_non_pausable_mask %x\n",
>> +	   bp->dcbx_port_params.pfc.priority_non_pausable_mask);
>>  
>>  	for (cos = 0 ; cos < bp->dcbx_port_params.ets.num_of_cos ; cos++) {
>>  		DP(BNX2X_MSG_DCB,
>> @@ -1097,8 +1097,8 @@ bnx2x_dcbx_print_cos_params(struct bnx2x *bp,
>>  		   cos, bp->dcbx_port_params.ets.cos_params[cos].strict);
>>  
>>  		DP(BNX2X_MSG_DCB,
>> -		   "pdev->params.dcbx_port_params.ets.cos_params[%d].pauseable %x\n",
>> -		   cos, bp->dcbx_port_params.ets.cos_params[cos].pauseable);
>> +		   "pdev->params.dcbx_port_params.ets.cos_params[%d].pausable %x\n",
>> +		   cos, bp->dcbx_port_params.ets.cos_params[cos].pausable);
>>  	}
>>  
>>  	for (pri = 0; pri < LLFC_DRIVER_TRAFFIC_TYPE_MAX; pri++) {
>> @@ -1182,7 +1182,7 @@ static inline void bnx2x_dcbx_add_to_cos_bw(struct bnx2x *bp,
>>  		data->cos_bw += pg_bw;
>>  }
>>  
>> -static void bnx2x_dcbx_separate_pauseable_from_non(struct bnx2x *bp,
>> +static void bnx2x_dcbx_separate_pausable_from_non(struct bnx2x *bp,
>>  			struct cos_help_data *cos_data,
>>  			u32 *pg_pri_orginal_spread,
>>  			struct dcbx_ets_feature *ets)
>> @@ -1247,14 +1247,14 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>>  	}
>>  	/* single priority group */
>>  	if (pg_help_data->data[0].pg < DCBX_MAX_NUM_PG_BW_ENTRIES) {
>> -		/* If there are both pauseable and non-pauseable priorities,
>> -		 * the pauseable priorities go to the first queue and
>> -		 * the non-pauseable priorities go to the second queue.
>> +		/* If there are both pausable and non-pausable priorities,
>> +		 * the pausable priorities go to the first queue and
>> +		 * the non-pausable priorities go to the second queue.
>>  		 */
>>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
>>  			/* Pauseable */
>>  			cos_data->data[0].pausable = true;
>> -			/* Non pauseable.*/
>> +			/* Non pausable.*/
>>  			cos_data->data[1].pausable = false;
>>  
>>  			if (2 == num_of_dif_pri) {
>> @@ -1274,7 +1274,7 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>>  			}
>>  
>>  		} else if (IS_DCBX_PFC_PRI_ONLY_PAUSE(bp, pri_join_mask)) {
>> -			/* If there are only pauseable priorities,
>> +			/* If there are only pausable priorities,
>>  			 * then one/two priorities go to the first queue
>>  			 * and one priority goes to the second queue.
>>  			 */
>> @@ -1294,7 +1294,7 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>>  			cos_data->data[1].pri_join_mask =
>>  				(1 << ttp[LLFC_TRAFFIC_TYPE_FCOE]);
>>  		} else
>> -			/* If there are only non-pauseable priorities,
>> +			/* If there are only non-pausable priorities,
>>  			 * they will all go to the same queue.
>>  			 */
>>  			bnx2x_dcbx_ets_disabled_entry_data(bp,
>> @@ -1302,9 +1302,9 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>>  	} else {
>>  		/* priority group which is not BW limited (PG#15):*/
>>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
>> -			/* If there are both pauseable and non-pauseable
>> -			 * priorities, the pauseable priorities go to the first
>> -			 * queue and the non-pauseable priorities
>> +			/* If there are both pausable and non-pausable
>> +			 * priorities, the pausable priorities go to the first
>> +			 * queue and the non-pausable priorities
>>  			 * go to the second queue.
>>  			 */
>>  			if (DCBX_PFC_PRI_GET_PAUSE(bp, pri_join_mask) >
>> @@ -1326,8 +1326,8 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>>  			/* Non pause-able.*/
>>  			cos_data->data[1].pausable = false;
>>  		} else {
>> -			/* If there are only pauseable priorities or
>> -			 * only non-pauseable,* the lower priorities go
>> +			/* If there are only pausable priorities or
>> +			 * only non-pausable,* the lower priorities go
>>  			 * to the first queue and the higher priorities go
>>  			 * to the second queue.
>>  			 */
>> @@ -1375,19 +1375,19 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>>  	u8 i = 0;
>>  	u8 pg[DCBX_COS_MAX_NUM_E2] = { 0 };
>>  
>> -	/* If there are both pauseable and non-pauseable priorities,
>> -	 * the pauseable priorities go to the first queue and
>> -	 * the non-pauseable priorities go to the second queue.
>> +	/* If there are both pausable and non-pausable priorities,
>> +	 * the pausable priorities go to the first queue and
>> +	 * the non-pausable priorities go to the second queue.
>>  	 */
>>  	if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
>>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp,
>>  					 pg_help_data->data[0].pg_priority) ||
>>  		    IS_DCBX_PFC_PRI_MIX_PAUSE(bp,
>>  					 pg_help_data->data[1].pg_priority)) {
>> -			/* If one PG contains both pauseable and
>> -			 * non-pauseable priorities then ETS is disabled.
>> +			/* If one PG contains both pausable and
>> +			 * non-pausable priorities then ETS is disabled.
>>  			 */
>> -			bnx2x_dcbx_separate_pauseable_from_non(bp, cos_data,
>> +			bnx2x_dcbx_separate_pausable_from_non(bp, cos_data,
>>  					pg_pri_orginal_spread, ets);
>>  			bp->dcbx_port_params.ets.enabled = false;
>>  			return;
>> @@ -1395,18 +1395,18 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>>  
>>  		/* Pauseable */
>>  		cos_data->data[0].pausable = true;
>> -		/* Non pauseable. */
>> +		/* Non pausable. */
>>  		cos_data->data[1].pausable = false;
>>  		if (IS_DCBX_PFC_PRI_ONLY_PAUSE(bp,
>>  				pg_help_data->data[0].pg_priority)) {
>> -			/* 0 is pauseable */
>> +			/* 0 is pausable */
>>  			cos_data->data[0].pri_join_mask =
>>  				pg_help_data->data[0].pg_priority;
>>  			pg[0] = pg_help_data->data[0].pg;
>>  			cos_data->data[1].pri_join_mask =
>>  				pg_help_data->data[1].pg_priority;
>>  			pg[1] = pg_help_data->data[1].pg;
>> -		} else {/* 1 is pauseable */
>> +		} else {/* 1 is pausable */
>>  			cos_data->data[0].pri_join_mask =
>>  				pg_help_data->data[1].pg_priority;
>>  			pg[0] = pg_help_data->data[1].pg;
>> @@ -1415,8 +1415,8 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>>  			pg[1] = pg_help_data->data[0].pg;
>>  		}
>>  	} else {
>> -		/* If there are only pauseable priorities or
>> -		 * only non-pauseable, each PG goes to a queue.
>> +		/* If there are only pausable priorities or
>> +		 * only non-pausable, each PG goes to a queue.
>>  		 */
>>  		cos_data->data[0].pausable = cos_data->data[1].pausable =
>>  			IS_DCBX_PFC_PRI_ONLY_PAUSE(bp, pri_join_mask);
>> @@ -1507,23 +1507,23 @@ static void bnx2x_dcbx_2cos_limit_cee_three_pg_to_cos_params(
>>  	u8 num_of_pri = LLFC_DRIVER_TRAFFIC_TYPE_MAX;
>>  
>>  	cos_data->data[0].pri_join_mask = cos_data->data[1].pri_join_mask = 0;
>> -	/* If there are both pauseable and non-pauseable priorities,
>> -	 * the pauseable priorities go to the first queue and the
>> -	 * non-pauseable priorities go to the second queue.
>> +	/* If there are both pausable and non-pausable priorities,
>> +	 * the pausable priorities go to the first queue and the
>> +	 * non-pausable priorities go to the second queue.
>>  	 */
>>  	if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask))
>> -		bnx2x_dcbx_separate_pauseable_from_non(bp,
>> +		bnx2x_dcbx_separate_pausable_from_non(bp,
>>  				cos_data, pg_pri_orginal_spread, ets);
>>  	else {
>>  		/* If two BW-limited PG-s were combined to one queue,
>>  		 * the BW is their sum.
>>  		 *
>> -		 * If there are only pauseable priorities or only non-pauseable,
>> +		 * If there are only pausable priorities or only non-pausable,
>>  		 * and there are both BW-limited and non-BW-limited PG-s,
>>  		 * the BW-limited PG/s go to one queue and the non-BW-limited
>>  		 * PG/s go to the second queue.
>>  		 *
>> -		 * If there are only pauseable priorities or only non-pauseable
>> +		 * If there are only pausable priorities or only non-pausable
>>  		 * and all are BW limited, then	two priorities go to the first
>>  		 * queue and one priority goes to the second queue.
>>  		 *
>> @@ -1796,7 +1796,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>>  		p->strict = cos_data.data[i].strict;
>>  		p->bw_tbl = cos_data.data[i].cos_bw;
>>  		p->pri_bitmask = cos_data.data[i].pri_join_mask;
>> -		p->pauseable = cos_data.data[i].pausable;
>> +		p->pausable = cos_data.data[i].pausable;
>>  
>>  		/* sanity */
>>  		if (p->bw_tbl != DCBX_INVALID_COS_BW ||
>> @@ -1806,13 +1806,13 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>>  
>>  			if (CHIP_IS_E2(bp) || CHIP_IS_E3A0(bp)) {
>>  
>> -				if (p->pauseable &&
>> +				if (p->pausable &&
>>  				    DCBX_PFC_PRI_GET_NON_PAUSE(bp,
>>  						p->pri_bitmask) != 0)
>>  					BNX2X_ERR("Inconsistent config for pausable COS %d\n",
>>  						  i);
>>  
>> -				if (!p->pauseable &&
>> +				if (!p->pausable &&
>>  				    DCBX_PFC_PRI_GET_PAUSE(bp,
>>  						p->pri_bitmask) != 0)
>>  					BNX2X_ERR("Inconsistent config for nonpausable COS %d\n",
>> @@ -1820,7 +1820,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>>  			}
>>  		}
>>  
>> -		if (p->pauseable)
>> +		if (p->pausable)
>>  			DP(BNX2X_MSG_DCB, "COS %d PAUSABLE prijoinmask 0x%x\n",
>>  				  i, cos_data.data[i].pri_join_mask);
>>  		else
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
>> index 9a9517c0f703..6cfe0d50bcd0 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
>> @@ -46,7 +46,7 @@ struct bnx2x_dcbx_cos_params {
>>  #define BNX2X_DCBX_STRICT_INVALID			DCBX_COS_MAX_NUM
>>  #define BNX2X_DCBX_STRICT_COS_HIGHEST			0
>>  #define BNX2X_DCBX_STRICT_COS_NEXT_LOWER_PRI(sp)	((sp) + 1)
>> -	u8	pauseable;
>> +	u8	pausable;
>>  };
>>  
>>  struct bnx2x_dcbx_pg_params {
>> @@ -57,7 +57,7 @@ struct bnx2x_dcbx_pg_params {
>>  
>>  struct bnx2x_dcbx_pfc_params {
>>  	u32 enabled;
>> -	u32 priority_non_pauseable_mask;
>> +	u32 priority_non_pausable_mask;
>>  };
>>  
>>  struct bnx2x_dcbx_port_params {
>> @@ -153,7 +153,7 @@ struct cos_help_data {
>>  #define DCBX_STRICT_PRIORITY			(15)
>>  #define DCBX_INVALID_COS_BW			(0xFFFFFFFF)
>>  #define DCBX_PFC_PRI_NON_PAUSE_MASK(bp)		\
>> -			((bp)->dcbx_port_params.pfc.priority_non_pauseable_mask)
>> +			((bp)->dcbx_port_params.pfc.priority_non_pausable_mask)
>>  #define DCBX_PFC_PRI_PAUSE_MASK(bp)		\
>>  					((u8)~DCBX_PFC_PRI_NON_PAUSE_MASK(bp))
>>  #define DCBX_PFC_PRI_GET_PAUSE(bp, pg_pri)	\
> 

