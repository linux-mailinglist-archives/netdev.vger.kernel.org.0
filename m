Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62F71BF501
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD3KKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:10:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgD3KKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:10:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U9wtDG044025;
        Thu, 30 Apr 2020 10:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5WhGcq90rfMBRqKV0qb10Jbha9Kn+6XcelGD6TM+nHo=;
 b=jS4fO3pEbYQLmfAdBVeBEL97Vc+ySSqlzQqty9S2gK4Qdz8bU7ZTqWDfUVa3E6VAWz2u
 gAaVpz338nMUpXb1U7PZZyIZTdk7e/Oxg6Dvx+V+HMxNk6f7MzXo2FpgmK4r3Eq97ZUS
 sAdGfnpdqauMl2mP07sUtXHGUYdJgn6/c2mjyvehF3bnu7RGgBW+wqEwGMHhoQIaBAlT
 gMJjaD4siEPLuOlBuUcukGyuCGCueXATJ4YogQ4+QjDXEHEyIz5JLWoFyEKEdOAHZdjX
 zfg5c2wo8YJl1jzSih6Pm78hhwF5Fh0LnC9XDOPi6ZUdwV7IJHHVQ/PNfCHeHG721Po8 tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucgajn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 10:10:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UA6XDC113255;
        Thu, 30 Apr 2020 10:08:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30qtkvykbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 10:08:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UA8bQi028097;
        Thu, 30 Apr 2020 10:08:37 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 10:08:36 +0000
Date:   Thu, 30 Apr 2020 13:08:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     Rylan Dmello <mail@rylan.coffee>, devel@driverdev.osuosl.org,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/7] staging: qlge: Remove gotos from
 ql_set_mac_addr_reg
Message-ID: <20200430100828.GU2014@kadam>
References: <cover.1588209862.git.mail@rylan.coffee>
 <a6f485e43eb55e8fdc64a7a346cb0419b55c3cb6.1588209862.git.mail@rylan.coffee>
 <20200430093835.GT2014@kadam>
 <4c91091b304fc5df2a2f292a1e0c78d80217bb94.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c91091b304fc5df2a2f292a1e0c78d80217bb94.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=991 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 03:03:07AM -0700, Joe Perches wrote:
> On Thu, 2020-04-30 at 12:38 +0300, Dan Carpenter wrote:
> > On Wed, Apr 29, 2020 at 09:33:04PM -0400, Rylan Dmello wrote:
> > > As suggested by Joe Perches, this patch removes the 'exit' label
> > > from the ql_set_mac_addr_reg function and replaces the goto
> > > statements with break statements.
> []
> > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> []
> > > @@ -336,22 +336,20 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
> > >  
> > >  		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
> > >  		if (status)
> > > -			goto exit;
> > > +			break;
> > 
> > Just "return status".  A direct return is immediately clear but with a
> > break statement then you have to look down a bit and then scroll back.
> 
> To me, 6 of 1, half dozen of other as
> all the case breaks could be returns.
> 
> So either form is fine with me.
> 
> The old form was poor through.

With a goto exit or a break you have to scroll down to exactly the same
place.  There is no difference at all.

Anyway, I'm actually fine with this patch series as-is.  It improves
a whole lot of stuff and doesn't cause any problems which weren't
there to begin with.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
