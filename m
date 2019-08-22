Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A6C9940E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfHVMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHVMoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MChPGb134044;
        Thu, 22 Aug 2019 12:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZYokRlnvCmLtc9vK3EkGdQ38OM+1djb8iV/zhcd0nFE=;
 b=PR+brW4lxpOr/O6zGzhkbPeL5HPrgqNFedOwlgbaVB/O3yTR6P/ngCY5HMTxuYBLf5gh
 Yj1wHGwQb2UjI1wBhhJ/Lxo1g8ezVc3Ne5MhcZwwGx97h6tQktPRd5NKXApBqsDqP8Sg
 brPz1uFfM5uiICOfJ2GfW6ANwC0tAbr/LeYObzSdXAFQ8g16p9GPs46ImpIdYohUgG/l
 HlMO3yI+zDFRcl+Xi/C7oOgJtYoJvoYVzheLL1dvDmsTZlMrF+CkMHGC4lYHcLwqbD5L
 R9k5Ab1YY8AHakuuscZsv03D1CpJQIZ1R+9vsbK97ywzCtaGyZFlw2YHXjupKc8WJLIE eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ue90twe6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 12:43:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MChiGt189847;
        Thu, 22 Aug 2019 12:43:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uh2q5y7u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 12:43:55 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7MCgvSr006308;
        Thu, 22 Aug 2019 12:42:57 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 05:42:55 -0700
Date:   Thu, 22 Aug 2019 15:42:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Martin Tomes <tomesm@gmail.com>
Cc:     isdn@linux-pingi.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Staging: isdn/gigaset : Fix bare unsigned warnings and
 trailing lines errors
Message-ID: <20190822124249.GI4451@kadam>
References: <1566401259-16921-1-git-send-email-tomesm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566401259-16921-1-git-send-email-tomesm@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=950
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

These drivers are ancient and going to be deleted soon.  We're not
accepting cleanups for them at this point.

On Wed, Aug 21, 2019 at 03:27:39PM +0000, Martin Tomes wrote:
> There are many bare use of unsigned warnings and trailing statements should be on next line errors from checkpatch.pl script.
> Change the code by adding 'unsigned int'. Move 'break' statement of 'switch' command to next line.

For future reference, this should be split up so each patch fixes
one kind of style issue.  And the commit message lines of text are too
long.  The limit is 75 characters for commit messages (like an email).

regards,
dan carpenter

