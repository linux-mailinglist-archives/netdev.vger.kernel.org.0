Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ED88DD11
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfHNSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:36:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfHNSge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:36:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EIXlOw123962;
        Wed, 14 Aug 2019 18:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4Y1mWa41W8MAbuvf3jyIICFRukEh8sKLbs5WZwCpIAM=;
 b=ep6XTPSG2lbyMrLycc9I0gSGvsUGOUOF2KTQu1pZQvrqJ24AGKzG9HFGf34S9SNGEjMt
 Ah6DMPEQD9P6wQ6Dwr3lRvSdTpa2wk19YUQJCagVtneDVB3op9vFhJsIdN0lyrYj5AHA
 apBtmR4bJZDsqVrOJBcU3TzfzVNygWGqnRQrRRkslSG3aVuTaqpfi5ZY3jNE/w6FjmL5
 BZRM3/nbkgXPcZl3vSo2RI7hKE38RCu6wNUvpyD6FXNrZdeiUOjYa33SWl39/f4LCwS3
 QPPOvbYlAHcWZfN49FRVfU2N4PZ7De5ZSM0iL3tTO+ZfcnsxK9E3Ysgcmk/zAlWCAacn 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtpmay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 18:36:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EIXQIX040889;
        Wed, 14 Aug 2019 18:36:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ucmwhr7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Aug 2019 18:36:21 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7EIaL43047625;
        Wed, 14 Aug 2019 18:36:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ucmwhr7a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 18:36:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7EIaK2U019077;
        Wed, 14 Aug 2019 18:36:20 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 11:36:20 -0700
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     David Miller <davem@davemloft.net>
Cc:     dledford@redhat.com, gerd.rausch@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
 <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
 <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
 <20190814.142112.1080694155114782651.davem@davemloft.net>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <53a6feaf-b48e-aadf-1bd7-4c82ddc36d1e@oracle.com>
Date:   Wed, 14 Aug 2019 11:36:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190814.142112.1080694155114782651.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 11:21 AM, David Miller wrote:
> From: santosh.shilimkar@oracle.com
> Date: Wed, 14 Aug 2019 11:01:36 -0700
> 
>> Some of the application software was released before 2009 and ended up
>> using these proc entries from downstream kernel. The newer lib/app
>> using RDS don't use these. Unfortunately lot of customer still use
>> Oracle 9, 10, 11 which were released before 2007 and run these apps
>> on modern kernels.
> 
> So those apps are using proc entries that were never upstream...
>
> Sorry, this is completely and utterly inappropriate.
> 
Agree. Unfortunately one of the legacy application library didn't
get upgraded even after the ports were registered with IANA.
Oracle 11 is still very active release and hence this patch.

It is fine to drop $subject patch from this series.

Regards,
Santosh



