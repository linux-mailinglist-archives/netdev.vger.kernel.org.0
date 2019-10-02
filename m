Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5FC89C6
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfJBNeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:34:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfJBNeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 09:34:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92DY1N9045984;
        Wed, 2 Oct 2019 13:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HWWR1Ldaoc3EnxA5FU/XGgpQ8+k9EqAvpinvMisHgDQ=;
 b=eZhUeSqIq1nEOJpUn6I3yY3HehLrZxSC4M1DqNk0giG54TOt2zM9+/NpU3/bCxnl2igi
 XGiioFp8PlJrZOx+0lerTkO5RZ6t6i08RPWtdW+FGYKFfwqJTqX4jb0mDgWOw9oAIVfO
 50i+htMn7yya/FjGvAKBxgMVZ4GP82WueBqRxoNmHtYDJsVpv0NnYlN7ciTPueQFZxwV
 uvgLy1nsPVbBVOHawrR375jWYo6/sj1Q0/EstZzfXRUIN136W/W/2wWceLz5DI1xQ5F9
 i1lZiQK2FDsIajFLebLi107vutpBY8DSGXhhSlvEKk8tChTOCfzyyDlxNRDLWrzkxcjz Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxuw019-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 13:34:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92DWmwF110887;
        Wed, 2 Oct 2019 13:34:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vckynxf8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 13:34:07 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x92DY5Y0013776;
        Wed, 2 Oct 2019 13:34:05 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 06:34:04 -0700
Date:   Wed, 2 Oct 2019 16:33:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: xgmac: add missing parentheses to fix
 precendence error
Message-ID: <20191002133356.GP22609@kadam>
References: <20191002110849.13405-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002110849.13405-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 12:08:49PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The expression !(hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10 is always zero, so
> the masking operation is incorrect. Fix this by adding the missing
> parentheses to correctly bind the negate operator on the entire expression.
> 
> Addresses-Coverity: ("Operands don't affect result")
> Fixes: c2b69474d63b ("net: stmmac: xgmac: Correct RAVSEL field interpretation")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> index 965cbe3e6f51..2e814aa64a5c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> @@ -369,7 +369,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
>  	dma_cap->eee = (hw_cap & XGMAC_HWFEAT_EEESEL) >> 13;
>  	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
>  	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
> -	dma_cap->av &= !(hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
> +	dma_cap->av &= !((hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10);

There is no point to the shift at all.

regards,
dan carpenter

