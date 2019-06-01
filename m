Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A98320BB
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 23:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFAVJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 17:09:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfFAVJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 17:09:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x51L46G3137258;
        Sat, 1 Jun 2019 21:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=lFRaHJV4AGaMGcCZiaC3ENU3IoTU0EjPSzC0mon4Pw8=;
 b=l6HbYv0V4EtKyZ0owaeuuMaDS8qE+aLFVzv7JIcl+6UpfTX2xhNJwusiCNWKRXuN5pzQ
 vDXUytzmHT32WlvbBCgZ12k7IPY9OPzOQou773+zDjC/L6Nj0+SBIU45tJEwQ09FHUTh
 HnOZ3oCBRYsqWChnKPDDtS1HbsUGAXQsvvQ1ePMMKYJj7Y8DHIEf140E4amww+nQSZQk
 fXNbm9McFg7wiOWpMA+poFw3YtiZ3/cgVkHMwH2brXV+6zHKkyqVnqvpnHDNm1SEbXJ4
 lF7JrWguYk948C/upAmVl3iROuNJk1e6FmTGJRKHteiKX0cU8uyccK0PVzH7JI7fwlwx nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0q1p0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Jun 2019 21:09:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x51L8djc149730;
        Sat, 1 Jun 2019 21:09:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2suh60y1qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Jun 2019 21:09:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x51L98Z7029165;
        Sat, 1 Jun 2019 21:09:08 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 01 Jun 2019 14:09:07 -0700
Date:   Sun, 2 Jun 2019 00:08:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Colin King <colin.king@canonical.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] mwifiex: check for null return from skb_copy
Message-ID: <20190601210858.GG31203@kadam>
References: <20190413161438.6376-1-colin.king@canonical.com>
 <20190413192729.GL6095@kadam>
 <MN2PR18MB2637DAA4852542EDA2BBC01DA01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB2637DAA4852542EDA2BBC01DA01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9275 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=790
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906010152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9275 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=825 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906010152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 05:29:26PM +0000, Ganapathi Bhat wrote:
> Hi Dan,
> 
> > >  	if (is_multicast_ether_addr(ra)) {
> > >  		skb_uap = skb_copy(skb, GFP_ATOMIC);
> > > +		if (!skb_uap)
> > > +			return -ENOMEM;
> > 
> > I think we would want to free dev_kfree_skb_any(skb) before returning.
> I think if the pointer is NULL, no need to free it; 

You're misreading skb vs skb_uap.  "skb_uap" is NULL but "skb" is
non-NULL and I'm pretty sure we should free it.

regards,
dan carpenter

