Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB6AF7FF
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfIKIb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:31:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:31:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B8TH2i075190;
        Wed, 11 Sep 2019 08:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=W0E9UrNnjyuvzRi0UEiwPQk0ehPpo7nENdV93FQVjtM=;
 b=lkeMbkJ5cNu4BeQ8TQNsTBayCeOZhg0R1vGYiuWG9XEGINyRokMdLTZQqvnWfQCibF0k
 feb+JrneQmuxeAiCyh+Fnp4CzZstOVSRyIhrPdQzItGqXpqH0fQsPUoNSoI7vBlopbWd
 fAHI9a5QqnB0L0X55Ytf6NSWslnSqQzPIJh9tioKKb1Fi6cZVqebgvVdNg3lMbkwAHeA
 bTu1wBg0QJ7tgrwJCX73NYGd/SrYk7p5vXrbhyRZQMtW7CsJV/jgYuAiWikwmbIapLlC
 mkLEWa0YF4Fvj7rwdM4bxwpp/Ziuo1ccV2UMDvAy5JMTvQx23KmGI9kbmMRAXsVvayC8 +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uw1m90bq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 08:30:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B8TFXA171239;
        Wed, 11 Sep 2019 08:30:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2uxk0syw0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 08:30:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8B8UmX7015696;
        Wed, 11 Sep 2019 08:30:48 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Sep 2019 01:30:48 -0700
Date:   Wed, 11 Sep 2019 11:30:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     maowenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190911083038.GF20699@kadam>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
 <20190910192207.GE20699@kadam>
 <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 09:30:47AM +0800, maowenan wrote:
> 
> 
> On 2019/9/11 3:22, Dan Carpenter wrote:
> > On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> >> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> >>> There are more parentheses in if clause when call sctp_get_port_local
> >>> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> >>> do cleanup.
> >>>
> >>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >>> ---
> >>>  net/sctp/socket.c | 3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >>> index 9d1f83b10c0a..766b68b55ebe 100644
> >>> --- a/net/sctp/socket.c
> >>> +++ b/net/sctp/socket.c
> >>> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> >>>  	 * detection.
> >>>  	 */
> >>>  	addr->v4.sin_port = htons(snum);
> >>> -	if ((ret = sctp_get_port_local(sk, addr))) {
> >>> +	if (sctp_get_port_local(sk, addr))
> >>>  		return -EADDRINUSE;
> >>
> >> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> >> casted to long.  It's not documented what it means and neither of the
> >> callers use the return since commit 62208f12451f ("net: sctp: simplify
> >> sctp_get_port").
> > 
> > Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
> > socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
> > because before the code assumed that a pointer casted to an int was the
> > same as a pointer casted to a long.
> 
> commit 4e54064e0a13 treated non-zero return value as unexpected, so the current
> cleanup is ok?

Yeah.  It's fine, I was just confused why we weren't preserving the
error code and then I saw that we didn't return errors at all and got
confused.

regards,
dan carpenter

