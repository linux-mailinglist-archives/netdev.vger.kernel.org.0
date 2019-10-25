Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35921E4FB2
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440548AbfJYO6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:58:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437476AbfJYO6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:58:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PEmvJN049894;
        Fri, 25 Oct 2019 14:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8akM3Zo80mA5RvA40djKzIs5p/MWfdT9Yde14KUY/UA=;
 b=iEocMA83Pj8LY9Zd/2uc485IY6Do1XL8o5fnGFNh6ZbuhiOoUwpYh1jHzaXkUQs4Fskj
 1E2ojgsrHBjs87M84qgW/pobc6G4LL+U85T1N3ES/eIqmzm2bygs0nkZMjDZuGiBj7eR
 DR1X9Oc6+sLhixukV7bgw6teFqA/PVwiAlz82pOtVlwqv0UnQQslSBUkKIrAKHV1EfJ2
 frLP4pLCGZkU97m34GfbujQKnpo70a/6zXS08MGWMlVf/Ss6/VBlqZteF3YdHaT8Vu44
 hWxCE7FVp8jvvFDxA/KFUp8aMSfNijkQpuRlz9wlKKuAosXZODxbLukGp11dcmbYLvX5 gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswu3rss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 14:58:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PEnCUH167954;
        Fri, 25 Oct 2019 14:56:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vunbmjw9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 14:56:06 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9PEu6Qq000476;
        Fri, 25 Oct 2019 14:56:06 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 14:56:05 +0000
Date:   Fri, 25 Oct 2019 17:55:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuil Ivanov <samuil.ivanovbg@gmail.com>
Cc:     gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        linux-kernel@vger.kernel.org, manishc@marvell.com
Subject: Re: [PATCH 1/3] Staging: qlge: Rename prefix of a function to qlge
Message-ID: <20191025145554.GB7244@kadam>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
 <20191024212941.28149-2-samuil.ivanovbg@gmail.com>
 <20191025101705.GM24678@kadam>
 <20191025142842.GA10016@sivanov-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025142842.GA10016@sivanov-pc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=641
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=727 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 05:28:42PM +0300, Samuil Ivanov wrote:
> Dan you are correct it is a bit of a hodge podge :)
> I think that it is better to have a bigger patches that will rename
> more functions, but I don't this it is good to have all the
> functions renamed in one patch.
> 
> Just in the header file I counted around 55 function definitions,
> and in the source files there are some more.
> So that will make one huge patch.
> 

I don't really have a problem if you rename everything at once.  Or if
you want to rename all of them in a 55 patch patchset that's also fine
with me...

regards,
dan carpenter

