Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC0B8DC19
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfHNRmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:42:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfHNRmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:42:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EGs4au046819;
        Wed, 14 Aug 2019 17:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vt3RvfccuDz7u3wStto053OL4aIZLvwLj/wAfsvE7Pg=;
 b=DJfFSImEtNs/tA5U/IPn7OL5Lsek4G89bJltvae4omqJ3RkfRVGEA5pTRmcj8+eMg5nB
 DY3GfaV6IRpMzjpX7UyvXUJyubAZY4r7ABjjjNfgsjihd5+xBEkkmKeIa7DhEGNLnSR7
 OBYOZamH2XKyj+GCTUNeYwiPhKiXuUEvHacmsT1PLKBsJfcUTorz9m1Kn+YcJHwzxRMl
 nE4NI6f47lQfahNvAL7E+WfUfa3OvoRQrN2JMwJEymGXryuHj1Q5T4xdbgsl3JJfTDNL
 v2F3xGHosT92EnTtu6jNyEPJy+SnYouNd2o0yLN9aAfRU0cWLhD6vlrgJRc52Ebj6gVm tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqp614-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 17:41:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EGrtec030652;
        Wed, 14 Aug 2019 17:41:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf010fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Aug 2019 17:41:57 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7EHdWt2182248;
        Wed, 14 Aug 2019 17:41:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ucgf010fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 17:41:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7EHft2u016762;
        Wed, 14 Aug 2019 17:41:55 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 10:41:55 -0700
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     Doug Ledford <dledford@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
 <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <d9281697-27c6-2aa5-6675-4b082be31c5d@oracle.com>
Date:   Wed, 14 Aug 2019 10:41:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

On 14/08/2019 08.56, Doug Ledford wrote:
> Good Lord...RDS was taken into the kernel in Feb of 2009, so over 10
> years ago.  The patch to put PF_RDS/AF_RDS/SOL_RDS was taken into
> include/linux/socket.h Feb 26, 2009.  The RDS ports were allocated by
> IANA on Feb 27 and May 20, 2009.  And you *still* have software that
> needs this?

I'll let Santosh elaborate on this, but it looks like we (i.e. Oracle) do:

From our Gerrit, posted on Aug 08, 2019, 10:39:29 AM UTC-07:00:
--------%<--------%<--------%<--------%<--------%<--------%<--------
Santosh Shilimkar Acked-by +1
Patch Set 1: Acked-by+1
Unfortunately we need to keep these around.
--------%<--------%<--------%<--------%<--------%<--------%<--------

> As of today, does your current build of Oracle software still require this,
> or have you at least fixed it up in your modern builds?
> 

I'll let Santosh answer that question as well.

Thanks,

  Gerd
