Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10C2132AF4
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAGQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:18:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgAGQSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:18:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007GC1l8073481;
        Tue, 7 Jan 2020 16:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LrUamD+V8wbn5/d7X40R8tpABzP39MyqAKN7D5HtWXc=;
 b=YPAXbqoVr3cTDeqFBB4Nz6GhRhpaQiNLlaj1xNdMcLkBtF0ngywq9yRXvYToJ9bViSA3
 Esgaj70CkduG48RRyZ8pMtLe0W1Qii8EstRPyJZI81+nUqgdIFg7HvwUiIFN/rlWQTWL
 gsNlTsrEzmjCVnF35m/S36gxeU/WUdINnH3X8tobEmYliVHEEPH3flnvGYND2rIt4NqW
 jx2eHScgjPX7Lv4mW7xSe6Z6vdZR/8cxFwJ4l3vX3R29LCuRElqVmasJ+hV7VUBaSQmB
 7HZ4TlPVYtZAC1fO77g61AgMpk02MuUTWXXblHDkH8aAMxqbu2dcX+TENZLPPPKPXUT7 rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xakbqpg4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 16:18:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007G4Heb015586;
        Tue, 7 Jan 2020 16:18:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xcpcqk745-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 16:18:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 007GIZha024022;
        Tue, 7 Jan 2020 16:18:35 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 08:18:35 -0800
Date:   Tue, 7 Jan 2020 19:18:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rose: remove redundant assignment to variable failed
Message-ID: <20200107161827.GO3911@kadam>
References: <20200107152415.106353-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107152415.106353-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 03:24:15PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable failed is being assigned a value that is never read, the
> following goto statement jumps to the end of the function and variable
> failed is not referenced at all.  Remove the redundant assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/rose/rose_route.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
> index c53307623236..5277631fa14c 100644
> --- a/net/rose/rose_route.c
> +++ b/net/rose/rose_route.c
> @@ -696,7 +696,6 @@ struct rose_neigh *rose_get_neigh(rose_address *addr, unsigned char *cause,
>  				for (i = 0; i < node->count; i++) {
>  					if (!rose_ftimer_running(node->neighbour[i])) {
>  						res = node->neighbour[i];
> -						failed = 0;
>  						goto out;
>  					}
>  					failed = 1;

I don't know the code, but I would have expected the out label to come
earlier:


        }
        if (!route_frame) { /* connect request */
                for (node = rose_node_list; node != NULL; node = node->next) {
                        if (rosecmpm(addr, &node->address, node->mask) == 0) {
                                for (i = 0; i < node->count; i++) {
                                        if (!rose_ftimer_running(node->neighbour[i])) {
                                                res = node->neighbour[i];
                                                failed = 0;
                                                goto out;
                                        }
                                        failed = 1;
                                }
                        }
                }
        }

<--------***********  I would have expected it to be right here.
        if (failed) {
                *cause      = ROSE_OUT_OF_ORDER;
                *diagnostic = 0;
        } else {
                *cause      = ROSE_NOT_OBTAINABLE;
                *diagnostic = 0;
        }

out:
        if (!route_frame) spin_unlock_bh(&rose_node_list_lock);
        return res;

regards,
dan carpenter

