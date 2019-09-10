Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12A5AF1D6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfIJTXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:23:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfIJTXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:23:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AJIZMQ048968;
        Tue, 10 Sep 2019 19:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tksQD2Rpoes/XpADezB0hnxBUleozwtCafj604Oeb2A=;
 b=i2Zg7YwKCPWc5PIladBSkin1Ogyg6IVzqSySgL5xkhhEogQ28xOAjXET4JGka2Axh3Cj
 yug91VriQG4y04rrou4BHZJeT36/JBVNhoP+PSW4v8wbseAOkmVo9H1x+NvX0v7JhN6N
 NMsFTla22NwVDD9qBj1Q4egeMW9OUhURIVW7yXx8XbRQuFZTlFjNoV78KLH0XJ008Djj
 qrHlrqq+iN4LKyzqkTgLo75DWRSB1E/W0R+fa0Yh5+YdBpC48o2LL5DBQnO2PuuvA8v5
 NVEsj/9O/mFLjBeghCcRE428WiadbEua6X5YDL5UFLD4u/UcjKtm+AXji17XFVzKB9aq yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uw1jkdkr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 19:22:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AJIF7X067086;
        Tue, 10 Sep 2019 19:22:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uwqku4nex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 19:22:20 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8AJMIRK026489;
        Tue, 10 Sep 2019 19:22:18 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 12:22:18 -0700
Date:   Tue, 10 Sep 2019 22:22:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190910192207.GE20699@kadam>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910185710.GF15977@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909100181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909100181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> > There are more parentheses in if clause when call sctp_get_port_local
> > in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> > do cleanup.
> > 
> > Signed-off-by: Mao Wenan <maowenan@huawei.com>
> > ---
> >  net/sctp/socket.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 9d1f83b10c0a..766b68b55ebe 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> >  	 * detection.
> >  	 */
> >  	addr->v4.sin_port = htons(snum);
> > -	if ((ret = sctp_get_port_local(sk, addr))) {
> > +	if (sctp_get_port_local(sk, addr))
> >  		return -EADDRINUSE;
> 
> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> casted to long.  It's not documented what it means and neither of the
> callers use the return since commit 62208f12451f ("net: sctp: simplify
> sctp_get_port").

Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
because before the code assumed that a pointer casted to an int was the
same as a pointer casted to a long.

regards,
dan carpenter

