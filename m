Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA53D10065
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 21:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfD3Tmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 15:42:53 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:45722 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbfD3Tmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 15:42:52 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UJbXSl030038;
        Tue, 30 Apr 2019 20:42:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Zj90LOHEN4lV/bOzIGADAImHK7b2OINpy8q051pU4eI=;
 b=CB1ZR/VL+u36URZDA5AyIMF5l6Rwq4pIxHdRSod7KEYqSgghaCEX+Xwn+fh3QmuI0abl
 tv3+MPfoNvjaQQugQV3AayVe2uVv/1fs7C3d4dIh+W1ckUrfYpGLSGu9GWRfvJi8xZoz
 iJqq2IgVSuLGnKA+oUGK5UDwr93SrUYqz/LHzrN9rpYwUS2/TncH6eOuXFwe9rRz8l8G
 npZplOFjkOB7oVK78lARXFwtsQFt0stJmpdM45RIUAIjAgo+k9rJLDkuE7RgSIZgwEpR
 7VeC8JyOVKxIteeC+R0KSbunCjMCEpIfWHjTG8a/kyZH3o4V91RnKCiyUSSbQkiXVVXd 2g== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2s670vvh22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Apr 2019 20:42:50 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x3UJWol8022335;
        Tue, 30 Apr 2019 15:42:49 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2s4jdvecus-1;
        Tue, 30 Apr 2019 15:42:49 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 6A1561FCDD;
        Tue, 30 Apr 2019 19:42:39 +0000 (GMT)
Subject: Re: [PATCH iproute2-next] ss: add option to print socket information
 on one line
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556227308-16057-1-git-send-email-johunt@akamai.com>
 <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
 <f1a1cd3b-8b85-3296-edd0-8106b7e28010@akamai.com>
 <1f1ca56d-bfd7-7fc4-1fed-cff2cc69c6f7@akamai.com>
 <4ff0fbb5-9f32-440f-8eac-6f05b405b934@gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <5853f1a4-3031-65ee-f02a-1dbd08447718@akamai.com>
Date:   Tue, 30 Apr 2019 12:42:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4ff0fbb5-9f32-440f-8eac-6f05b405b934@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300116
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 12:41 PM, David Ahern wrote:
> On 4/30/19 12:55 PM, Josh Hunt wrote:
>> Actually, David can you clarify what you meant by "use 'oneline' as the
>> long option without the '-'."?
> 
> for your patch:
> 1,$s/one-line/oneline/
> 
> ip has -oneline which is most likely used as 'ip -o'. having ss with
> --one-line vs --oneline is at least consistent to the level it can be.
> 

OK, that's what I thought you meant, but wanted to confirm.

Thanks!
Josh
