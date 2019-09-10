Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F0AF154
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 20:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfIJS6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 14:58:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfIJS6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 14:58:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AIrs0f027506;
        Tue, 10 Sep 2019 18:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PNXHZLibSlx8GAKedEj61iEzVO7t88YI1+R7FoPooS8=;
 b=YjDCFK4zc9CyH8hCGLWDU+Ph0z6eFfR1BxfWSzUxQTEvqxGJsIm+GiYtNqTP6lfPKmJb
 ucgwJ5EebprZjNh8b7LVzgAlb+8LKbRmGQD/HYEjyljbHUnQmKp2TymM3LK/7aILWln9
 T1YNDIcwV4xatReCt27cxADfoUkCRLZMXCRDX6xBE2z8EsZgwDkFkNoOoZpnJ5Fz3KGs
 DochFJkjG+hU+d3IkzOsC8fU42efb/nOu9jxQv4Ewn4tNIoLmJQZ23BKD6CPemjbT7rR
 Fc1fZ/97rYHJC3tmv53eFqGgmMZdX51OiGiPGMwZgKFWWWoLHpAA95ke4GPbeifEX8OB lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uw1jkdfq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 18:57:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AIrpgJ105209;
        Tue, 10 Sep 2019 18:57:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uwq9qg20v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 18:57:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8AIvOHt018523;
        Tue, 10 Sep 2019 18:57:24 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 11:57:23 -0700
Date:   Tue, 10 Sep 2019 21:57:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190910185710.GF15977@kadam>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910071343.18808-2-maowenan@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909100176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909100176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> There are more parentheses in if clause when call sctp_get_port_local
> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> do cleanup.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/sctp/socket.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9d1f83b10c0a..766b68b55ebe 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>  	 * detection.
>  	 */
>  	addr->v4.sin_port = htons(snum);
> -	if ((ret = sctp_get_port_local(sk, addr))) {
> +	if (sctp_get_port_local(sk, addr))
>  		return -EADDRINUSE;

sctp_get_port_local() returns a long which is either 0,1 or a pointer
casted to long.  It's not documented what it means and neither of the
callers use the return since commit 62208f12451f ("net: sctp: simplify
sctp_get_port").

Probably it should just return a bool?

regards,
dan carpenter

