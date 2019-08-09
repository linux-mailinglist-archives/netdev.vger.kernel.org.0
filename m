Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F166882CF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHISnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:43:52 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:27076 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbfHISnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:43:52 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x79IRQol024451;
        Fri, 9 Aug 2019 19:43:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=+lUrMhVL3czHi+8ll9y44jFNn4VSz3iRhkY15lQD7X4=;
 b=cDY0OZu5OlBQ9as9GMenJsv/AwJVXkBegVcCgh2qEToqCVWj6QJXgNbOdye9b1d1hy8p
 8opnjHxMNC7MPlOKzjlJvOSBh72ooMLSWUtOCPsFmS7oMLnrPxzI1Orh19eokfuaWAgx
 +OnxHUlIOSVTYCUaJ3jkgRr40gqsi+wGevlVpqd71FlDmHU7c1UgLHp8HgAzGl/Q8rtU
 atnaZL2ZN7xrvk4H/EieO/Ym2rGx4GW35wKxBqPzxwNowJ5F/HODdcjRbHACkZTfu+aB
 Ei5ACxEDJn8RTZaX5QwWNS8A0FXBdPtMTE7/yisBQzy8Ru/SnAojXG005TFebd2IjXLD dg== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2u52p8vugf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 19:43:48 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x79IVtYt011636;
        Fri, 9 Aug 2019 14:43:47 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2u55m25e62-1;
        Fri, 09 Aug 2019 14:43:47 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id B825280D1A;
        Fri,  9 Aug 2019 18:43:46 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        edumazet@google.com, ncardwell@google.com
References: <1565221950-1376-2-git-send-email-johunt@akamai.com>
 <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
 <3353da97-e015-7303-6e10-7e3e99a50a8f@akamai.com>
 <20190809.114314.1715215925183719227.davem@davemloft.net>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <8a078753-bfb5-cd7e-449b-615ad7fd5d50@akamai.com>
Date:   Fri, 9 Aug 2019 11:43:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809.114314.1715215925183719227.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=791
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090182
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-09_06:2019-08-09,2019-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=787
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908090182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 11:43 AM, David Miller wrote:
> From: Josh Hunt <johunt@akamai.com>
> Date: Fri, 9 Aug 2019 11:38:05 -0700
> 
>> I forgot to tag these at net-next. Do I need to resubmit a v3 with
>> net-next in the subject?
> 
> No need.
> 

Thanks
