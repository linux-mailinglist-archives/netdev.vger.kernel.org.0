Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88CF28889A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbgJIMZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:25:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51298 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgJIMZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:25:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099CEKwH133483;
        Fri, 9 Oct 2020 12:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=n22P8Xfb0B1TLNzA82CTEqsWl3jmD6gQk4/3XYHTSuU=;
 b=NyjpwrQ3ipMnJMtzAl1nhhaVFGkTA7xPCwZKgDXI9tp+bWYqfGMzakpSWOfzesoST3YN
 7b4Xs56J73TIO7/s5B/bqo69BgLVenF3ip7RP2A52UVVOP9CVMxovyfWvdqRanIySKF8
 ALPXBE3UKnYODryFM/e/rz+cbvvv2MxoUYJuh2Imvh+hgPTzkCz54mfO3Rlu9gO3Zrzz
 R3QQGDRFz7X0P+e4eGXKyZUJSww1C+vFLh1rA6GTJ3JF/ZkF4nxxhehPw5XvbjUfaNs+
 CnixsWNGcweiJvDmJqleHQM2U84B5NdSGVps16Me+2PuHt00ErAVn882LSBhdp/3WTsU FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 342kvys70b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 09 Oct 2020 12:25:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099CGHL9036059;
        Fri, 9 Oct 2020 12:25:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3429k11s5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Oct 2020 12:25:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 099CP67m023139;
        Fri, 9 Oct 2020 12:25:10 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Oct 2020 05:25:06 -0700
Date:   Fri, 9 Oct 2020 15:24:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] stating: octeon: Drop on uncorrectable alignment or FCS
 error
Message-ID: <20201009122459.GP1042@kadam>
References: <20201009094605.1525-1-alexander.sverdlin@nokia.com>
 <20201009094605.1525-2-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009094605.1525-2-alexander.sverdlin@nokia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010090088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 phishscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010090088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 11:46:05AM +0200, Alexander A Sverdlin wrote:
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -69,14 +69,16 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>  	else
>  		port = work->word1.cn38xx.ipprt;
>  
> -	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
> +	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
>  		/*
>  		 * Ignore length errors on min size packets. Some
>  		 * equipment incorrectly pads packets to 64+4FCS
>  		 * instead of 60+4FCS.  Note these packets still get
>  		 * counted as frame errors.
>  		 */
> -	} else if (work->word2.snoip.err_code == 5 ||
> +		return 0;
> +
> +	if (work->word2.snoip.err_code == 5 ||
>  		   work->word2.snoip.err_code == 7) {

This line is indented to match the old code and it no longer matches.
(Please update the whitespace).

>  		/*
>  		 * We received a packet with either an alignment error

regards,
dan carpenter
