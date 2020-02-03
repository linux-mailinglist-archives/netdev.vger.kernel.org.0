Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3631503B0
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 10:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgBCJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 04:58:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgBCJ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 04:58:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0139r4Zl146734;
        Mon, 3 Feb 2020 09:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4+fD8usrrX6aqnYnl2AoNHWt1yCoOyQyBn9Zwn1ExN0=;
 b=WoEUl4OIKL1Ag/ibRqDqLDKt+XcRjiZcA0Jl1QHYOTBvjzSPEh0rPQHu8/ldWDON6NqS
 KCiZa1Qk/m9CUUjIgozZu6zMFBfQQ/Wbl1HSTm0fxqyJXhG9BFoWGpTQT4i8DCdO2ka7
 iowAfzdpMrCuWu+CnbWPeSxAKtLnAisi5DmglSOKh0acva02k8hwzVvrpBwJhH9Euapo
 kk//J2siV6pzzepcD+UFYPgi42PeHmfSNPYUbgLVslRH9jWa1OjlOa3mybKSOJefTHOi
 hT63CwLsl92tsMo7G9VN5JkmZWqKeGav3+doCC6lLitnl7T1NNnqzywdJ3gip4dFzKqT Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xwyg9avtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 09:58:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0139rxMR123793;
        Mon, 3 Feb 2020 09:56:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xwjt3htqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 09:56:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0139u1q3008752;
        Mon, 3 Feb 2020 09:56:04 GMT
Received: from kadam (/41.210.143.134)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Feb 2020 01:56:01 -0800
Date:   Mon, 3 Feb 2020 12:55:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     macro@linux-mips.org, ralf@linux-mips.org, davem@davemloft.net,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] defxx: Fix a sentinel at the end of a 'eisa_device_id'
 structure
Message-ID: <20200203095553.GN1778@kadam>
References: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002030078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002030078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 03:23:41PM +0100, Christophe JAILLET wrote:
> 'struct eisa_device_id' must be ended by an empty string, not a NULL
> pointer. Otherwise, a NULL pointer dereference may occur in
> 'eisa_bus_match()'.
> 
> Also convert some spaces to tab to please 'checkpatch.pl'.
> 
> Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/fddi/defxx.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
> index 077c68498f04..7ef0c57f07c6 100644
> --- a/drivers/net/fddi/defxx.c
> +++ b/drivers/net/fddi/defxx.c
> @@ -3768,11 +3768,11 @@ static void dfx_pci_unregister(struct pci_dev *pdev)
>  
>  #ifdef CONFIG_EISA
>  static const struct eisa_device_id dfx_eisa_table[] = {
> -        { "DEC3001", DEFEA_PROD_ID_1 },
> -        { "DEC3002", DEFEA_PROD_ID_2 },
> -        { "DEC3003", DEFEA_PROD_ID_3 },
> -        { "DEC3004", DEFEA_PROD_ID_4 },
> -        { }
> +	{ "DEC3001", DEFEA_PROD_ID_1 },
> +	{ "DEC3002", DEFEA_PROD_ID_2 },
> +	{ "DEC3003", DEFEA_PROD_ID_3 },
> +	{ "DEC3004", DEFEA_PROD_ID_4 },
> +	{ "" }

You haven't changed runtime at all.  :P (struct eisa_device_id)->sig[]
is an array, not a pointer.  There is no NULL dereference because an
array in the middle of another array can't be NULL.

regards,
dan carpenter

