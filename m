Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E2A24CA5
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfEUK2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:28:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbfEUK2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 06:28:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LANVHW036941;
        Tue, 21 May 2019 10:27:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=t4iGz702FxiPoqBJZC20mzL6PDTkQtNdAFMfDZKsF2g=;
 b=YShbBBNoTnFakj3j1idMUC/2meM33xYeZIVO0G4gBK1aWB9is8qdj54m4cp7VZEvJWtO
 ddN9IYcMk6ZtCchwlUYbB6zChlcp3LPvfmzd6fkRZKqMGdGLZOYLkY0kVTqOLI4T/s80
 mescmliPSjmvEjQh1sCsjmoU4gB0yMizxq9bONnrRpiXzCyU/LEN2k5v7E07OxD58UIJ
 coUS4Gn2CWkkE9zH6jWfpwmXExvKQFXLtOaJ0V/Wz/EH+AnxXzfi/hWrjUJoljU233/D
 ECTBltIX+jE3FArfJwO2idgAPQFT/mJ/ZmOwCtZOOUQr4z8ytsuWd6B5ALQrowHvwy0U 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sj9ftce50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 10:27:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LARdR5135175;
        Tue, 21 May 2019 10:27:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sks1jcg1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 10:27:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LARoRb002994;
        Tue, 21 May 2019 10:27:50 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 10:27:49 +0000
Date:   Tue, 21 May 2019 13:27:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] mISDN: Fix indenting in dsp_cmx.c
Message-ID: <20190521102742.GJ19380@kadam>
References: <20190521094256.GA11899@mwanda>
 <60901822e34c6c715668dbcf7adbded312d19ea4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60901822e34c6c715668dbcf7adbded312d19ea4.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=864
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210066
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=916 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 02:57:10AM -0700, Joe Perches wrote:
> On Tue, 2019-05-21 at 12:42 +0300, Dan Carpenter wrote:
> > We used a script to indent this code back in 2012, but I guess it got
> > confused by the ifdefs and added some extra tabs.  This patch removes
> > them.
> 
> Yup, thanks Dan.
> Emacs indent-region made a mess of it.
> 

The re-indent generally made things better and even in this case it
didn't really make it worse, just different.

regards,
dan carpenter

