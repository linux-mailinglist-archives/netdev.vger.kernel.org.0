Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C2D360BE6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhDOOfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:35:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53338 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDOOfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 10:35:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FEJGow079587;
        Thu, 15 Apr 2021 14:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CkWzQJq9qTXR/COElw+2nWhJygfpMk390eJBQixVWfk=;
 b=ejz+nbayBZTs6/DWzcb2fO1Kvs0JJdKB0ekXoRwFa/oZ1l9yX0+xBBvYQajdgJSvMhKd
 Oia8VCc8V3J5lm+bV5mVTfyR0Y72jbfULD1kwT1ef1o33YvCwz/A290iOJ0lc67tAyhA
 tOIks3zfDzb0frBB5IBkg346uvRAl/ApqRlwg0UBwwznpEYkqqjkC6ZJqgiEzgsaOaup
 6/w0sinwaZmUxA3o1/8TiJQIaZir86RloKC3BGH0vH1KrzmEppWvbpz7n8KvGFAnQBhj
 yG6/kq9P+FQOjmdJfOUNWLucK2x0uZmsNxok+NKFqDG/Vbhbzbm5ojeV1aSE3e+qHgQW 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnp29h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 14:34:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FEGXDo130989;
        Thu, 15 Apr 2021 14:34:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 37uny13ksw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 14:34:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13FEYJUM018811;
        Thu, 15 Apr 2021 14:34:23 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Apr 2021 07:34:18 -0700
Date:   Thu, 15 Apr 2021 17:34:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: stmmac: replace redundant comparison with true
Message-ID: <20210415143409.GC6021@kadam>
References: <20210415083757.1807538-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415083757.1807538-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150096
X-Proofpoint-ORIG-GUID: 54ZOchoRvgCtTE-6YcFYiYJqRlTKUTmH
X-Proofpoint-GUID: 54ZOchoRvgCtTE-6YcFYiYJqRlTKUTmH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 09:37:57AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u32 variable queue with <= zero is always true
> since an unsigned can never be negative. Replace the conditional
> check with the boolean true to simplify the code.  The while loop
> will terminate because of the zero check on queue before queue is
> decremented.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e3e22200a4fd..6e5b4c4b375c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1673,7 +1673,7 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
>  	return;
>  
>  err_reinit_rx_buffers:
> -	while (queue >= 0) {

This is an off by one from what the original developer was intending
because we're freeing the most recent queue that wasn't allocated.
In other words, we're freeing everything that we need to plus *one
more thing that we don't need to*.  But it's harmless in this case:

The better fix would be to make queue an int type and do:

	while (--queue >= 0)
		dma_free_rx_skbufs(priv, queue);

