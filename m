Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1619C1AC
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbgDBNHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:07:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48762 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388322AbgDBNHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:07:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032D3YoG195959;
        Thu, 2 Apr 2020 13:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=oW8EUs27voZDgUzLsb6d6q3EuFOz24ejqeKT2dTfZOA=;
 b=I8vVgLzqdQAz1IIYt3+SEnRZu1bVXicIN7Wgz3nL1S/ofQjEf0KV1kEwqHkf9Sw7YQ0l
 8lzfA+K7uSmvdB5BewIrxxnZAFzYmSmeFAm1ZiQhe24y+yoTXVKfWGLz64by5kR7aYSg
 I7PxRODynHvrpx/Vt/f2OG1IFrZURfQI3pIo/xYqdzbk2H9cVJt4hYI2QeyrxxA38jC2
 iIF/J8QUvu/kCVSj+xSnmU1MDjMRz2yrqSz49Y69HdZ6Niiil8TBOjY6ROYhNFu6OkFC
 8mxKwry3nL0n64tx/4LLPa+iIxKpOgokn+kv74DerIxS30XnYFsBguoFTJbT9nNCJlv3 kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 303cevb9bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 13:07:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032CwKj4054938;
        Thu, 2 Apr 2020 13:05:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 302g4vgwvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 13:05:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032D5YVo018468;
        Thu, 2 Apr 2020 13:05:34 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 06:05:33 -0700
Date:   Thu, 2 Apr 2020 16:05:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 04/32] staging: wfx: remove "burst" mechanism
Message-ID: <20200402130526.GR2001@kadam>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-5-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401110405.80282-5-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 01:03:37PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> In the old days, the driver tried to reorder frames in order to send
> frames from the same queue grouped to the firmware. However, the
> firmware is able to do the job internally for a long time. There is no
> reasons to keep this mechanism.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/queue.c | 23 -----------------------
>  drivers/staging/wfx/sta.c   |  2 --
>  drivers/staging/wfx/wfx.h   |  1 -
>  3 files changed, 26 deletions(-)
> 
> diff --git a/drivers/staging/wfx/queue.c b/drivers/staging/wfx/queue.c
> index e3aa1e346c70..712ac783514b 100644
> --- a/drivers/staging/wfx/queue.c
> +++ b/drivers/staging/wfx/queue.c
> @@ -363,8 +363,6 @@ static bool hif_handle_tx_data(struct wfx_vif *wvif, struct sk_buff *skb,
>  static int wfx_get_prio_queue(struct wfx_vif *wvif,
>  				 u32 tx_allowed_mask, int *total)
>  {
> -	static const int urgent = BIT(WFX_LINK_ID_AFTER_DTIM) |
> -		BIT(WFX_LINK_ID_UAPSD);
>  	const struct ieee80211_tx_queue_params *edca;
>  	unsigned int score, best = -1;
                            ^^^^^^^^^
Not related to this this patch but this confused me initially.  UINT_MAX
would be more readable.

The other unrelated question I had about this function was:

   402          /* search for a winner using edca params */
   403          for (i = 0; i < IEEE80211_NUM_ACS; ++i) {
                                ^^^^^^^^^^^^^^^^^
IEEE80211_NUM_ACS is 4.

   404                  int queued;
   405  
   406                  edca = &wvif->edca_params[i];
   407                  queued = wfx_tx_queue_get_num_queued(&wvif->wdev->tx_queue[i],
   408                                  tx_allowed_mask);
   409                  if (!queued)
   410                          continue;
   411                  *total += queued;
   412                  score = ((edca->aifs + edca->cw_min) << 16) +
   413                          ((edca->cw_max - edca->cw_min) *
   414                           (get_random_int() & 0xFFFF));
   415                  if (score < best && (winner < 0 || i != 3)) {
                                                           ^^^^^^

Why do we not want winner to be 3?  It's unrelated to the patch but
there should be a comment next to that code probably.

   416                          best = score;
   417                          winner = i;
   418                  }
   419          }

regards,
dan carpenter

