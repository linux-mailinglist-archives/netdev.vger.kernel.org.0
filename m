Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8BC8A93
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfJBOIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:08:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfJBOIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:08:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92E3uep070461;
        Wed, 2 Oct 2019 14:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+FGGI5TvFktU0/JRb3dnLjz/7hh1wncwHFnR3J2FD1U=;
 b=YMj7eUT/xa6f248L9zN5raJaaIPi2upRO7Tba4zBrhB/FFYYDkLKPeAcFy5TFSfP5k9I
 1TmW52eOj6+7BwliM/xSp+aXKkD9Aw8fOFaJQV7NEYzXst+1zeAP0vEdAKLSu90leQQr
 Ax38400CmkNxEGa3batH2Nvg7Ye3yBx1oVsfqbK75h5gN8BXYyvdPJimVWUXhgBDzAJX
 6DAEn+5GvMsY51gaBich2d7ikokUg6Umcvq2MrHBJrGhMLi52DIvpgACn/6+7omszspn
 A6FoQP/JZkDXPVa+b9YpiKu4IwnWPi+XIZdJ5387AKPtoX42DwvVV9jwP9XLrNXmKxv+ EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05rw3pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 14:07:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92E3SKB024837;
        Wed, 2 Oct 2019 14:07:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vc9dkju5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 14:07:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x92E7pgg001505;
        Wed, 2 Oct 2019 14:07:51 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 07:07:50 -0700
Date:   Wed, 2 Oct 2019 17:07:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
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
Message-ID: <20191002140733.GQ29696@kadam>
References: <20191002110849.13405-1-colin.king@canonical.com>
 <20191002133356.GP22609@kadam>
 <20191002134238.GP29696@kadam>
 <a995eee6-5b26-f9a9-4d6a-5533da050a3b@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a995eee6-5b26-f9a9-4d6a-5533da050a3b@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 02:53:17PM +0100, Colin Ian King wrote:
> On 02/10/2019 14:42, Dan Carpenter wrote:
> > On Wed, Oct 02, 2019 at 04:33:57PM +0300, Dan Carpenter wrote:
> >> On Wed, Oct 02, 2019 at 12:08:49PM +0100, Colin King wrote:
> >>> From: Colin Ian King <colin.king@canonical.com>
> >>>
> >>> The expression !(hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10 is always zero, so
> >>> the masking operation is incorrect. Fix this by adding the missing
> >>> parentheses to correctly bind the negate operator on the entire expression.
> >>>
> >>> Addresses-Coverity: ("Operands don't affect result")
> >>> Fixes: c2b69474d63b ("net: stmmac: xgmac: Correct RAVSEL field interpretation")
> >>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>> ---
> >>>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> >>> index 965cbe3e6f51..2e814aa64a5c 100644
> >>> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
> >>> @@ -369,7 +369,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
> >>>  	dma_cap->eee = (hw_cap & XGMAC_HWFEAT_EEESEL) >> 13;
> >>>  	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
> >>>  	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
> >>> -	dma_cap->av &= !(hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
> >>> +	dma_cap->av &= !((hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10);
> >>
> >> There is no point to the shift at all.
> > 
> > Sorry I meant to say it should be a bitwise NOT, right?  I was just
> > looking at some other dma_cap stuff that did this same thing...  I can't
> > find it now...
> 
> In drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c it is being used like
> a boolean and not a bitmask'd value:
> 
>         if (!priv->dma_cap.av)
> 
> so the original logic is to do boolean flag merging rather than bit-wise
> logic.

Oh yeah.  Thanks.  This code is hard to read.

It would be better to just write it like this:

	if (hw_cap & XGMAC_HWFEAT_AVSEL) && !(hw_cap & XGMAC_HWFEAT_RAVSEL)
		dma_cap->av = true;
	else
		dma_cap->av = false;

All these very shifts are concise but they introduce bugs like this one
you have found.

regards,
dan carpenter

