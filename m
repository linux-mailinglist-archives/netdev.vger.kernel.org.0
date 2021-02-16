Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDBD31C82C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBPJgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:36:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBPJgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:36:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11G9OIP0104352;
        Tue, 16 Feb 2021 09:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=umlK3jjN3ke1kJh78TX63gbIlvs0OA9GfJ6oIRc1qWw=;
 b=ut4I/ptEuIcK+GK0bemnN49TXn8Cg/MNmQN3b2CPT2mpQfDCYAqOfJuflmq/f1YNOSgs
 xOPG9TFJOmw1wc+MJnAKd8CdsslibIdUxtberU8eBUg2X+NNAM9vGzD5uc1oAMN8hlJ8
 Ds2WDD2yrqwk3vQU/cZiCQgrsOBxZWok5xU2jrJ9DVDoJ0P2KeQS8fs1mQLzZEdjmgr3
 SqHZMkptSzh93ZWcgtzUvDFfph0uNy75631OLXyEcpavQbrXBm8P4FwumvXLvA+l6nEX
 boU+GZicgOxq29TNLkWP/pJUddEA+WbVyqSXuD77z3jyB+40o+/YAdYh9vpBBAffUrSt Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36p7dne2xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 09:35:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11G9Q8e8015185;
        Tue, 16 Feb 2021 09:35:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 36prnxqb5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 09:35:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11G9ZHAM002402;
        Tue, 16 Feb 2021 09:35:17 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Feb 2021 01:35:16 -0800
Date:   Tue, 16 Feb 2021 12:35:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Du Cheng <ducheng2@gmail.com>, Manish Chopra <manishc@marvell.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] staging: fix coding style in
 driver/staging/qlge/qlge_main.c
Message-ID: <20210216093510.GY2087@kadam>
References: <20210216085326.178912-1-ducheng2@gmail.com>
 <f9f2ed25-8903-450b-0971-a5eb292380cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9f2ed25-8903-450b-0971-a5eb292380cf@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9896 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9896 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102160088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:20:22AM +0100, Heiner Kallweit wrote:
> On 16.02.2021 09:53, Du Cheng wrote:
> > align * in block comments on each line
> > 
> > changes v3:
> > - add SUBSYSTEM in subject line
> > - add explanation to past version of this patch
> > 
> > changes v2:
> > - move closing of comment to the same line
> > 
> > changes v1:
> > - align * in block comments
> > 
> > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > ---
> >  drivers/staging/qlge/qlge_main.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index 5516be3af898..2682a0e474bd 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
> >  
> >  	qlge_tx_ring_clean(qdev);
> >  
> > -	/* Call netif_napi_del() from common point.
> > -	*/
> > +	/* Call netif_napi_del() from common point. */
> >  	for (i = 0; i < qdev->rss_ring_count; i++)
> >  		netif_napi_del(&qdev->rx_ring[i].napi);
> >  
> > 
> Typically such trivial patches aren't much appreciated for staging drivers.
> In the case here I have doubts that the comment as such provides any benefit.

Huh?  What?  I think you have mixed up staging and non-staging.  In
staging we apply this sort of patch all the time.

This patch improves the code.  It's the only warning of this type in the
file.  We will apply it.

If you start down the path of worrying about "is this worth doing" then
you end up wasting maintainer time and developer time.  That's like an
ambiguous thing, right?  We try to avoid ambiguity and be mechanical and
predictable.

We won't apply patches which fix checkpatch warnings if the result is
worse looking code.  This might seem like an ambiguous judgement call to
newbies but it is actually 100% predictable to oldbies.  :P

Anyway the v2 v3 stuff is supposed to be below the --- cut off so please
fix that and resend.

regards,
dan carpenter

