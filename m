Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6F903B1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfHPOLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:11:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfHPOLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 10:11:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7GE90p3040745;
        Fri, 16 Aug 2019 14:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rrAIgZ4P0ppcqVMyqyiR1dhc7wUibmp5okZHvHPQgT8=;
 b=iS6KgC1swYeXsIXOvTz7W7s/tmTZChGDvn98Lr12Uq4seG88kEN+hpXPqJknTF8t1NG2
 8T0BAeHdszNIiBpI76034nG6htOhrcZy+H+yzxihlp8qPz/fDTvlOAszlyn5TBuCBLow
 6innOXMU6rVm8QiohQ4QkTaJYtA3811nBciImzQIw2UePzmQAjQ1J+sIZiWFTKL49qKl
 qsyYElIdYSG+gMJ+CaO4mumqzYkurjDKmFy3VqgoSdvrxsJyx2h3h6zIJL5tzAUfcMA0
 CgHI0eNdXWnnvPXLruSZihA0xLI4V3k9vrtto4M01zLo5OnYjDH+xThkctWeHuWFyN63 xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbu0r2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Aug 2019 14:10:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7GE9N1l176962;
        Fri, 16 Aug 2019 14:10:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2udgqg5wsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Aug 2019 14:10:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7GEAdcG017410;
        Fri, 16 Aug 2019 14:10:40 GMT
Received: from [10.159.153.160] (/10.159.153.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 07:10:39 -0700
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
To:     Andy Grover <andy@groveronline.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Chris Mason <clm@fb.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        Chris Mason <chris.mason@oracle.com>
References: <20190816075312.64959223@canb.auug.org.au>
 <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
 <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <15078f1f-a036-2a54-1a07-9197f81bd58f@oracle.com>
Date:   Fri, 16 Aug 2019 07:10:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908160148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908160148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/08/2019 02.15, Andy Grover wrote:
> On 8/16/19 3:06 PM, Gerd Rausch wrote:
>> Hi,
>>
>> Just added the e-mail addresses I found using a simple "google search",
>> in order to reach out to the original authors of these commits:
>> Chris Mason and Andy Grover.
>>
>> I'm hoping they still remember their work from 7-8 years ago.
> 
> Yes looks like what I was working on. What did you need from me? It's
> too late to amend the commitlogs...
> 

I'll let Stephen or David respond to what (if any) action is necessary.

The missing Signed-off-by was pointed out to me by Stephen yesterday.

Hence I tried to locate you guys to pull you into the loop in order to
not leave his concern unanswered.

Thanks,

  Gerd




