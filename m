Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EDD882BC
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436851AbfHISi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:38:27 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:13310 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbfHISiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:38:18 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x79ISNdH010986;
        Fri, 9 Aug 2019 19:38:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=dph1rIZbDEWdGs9ft+wbTKM3KmyyeGYTc/M7g5UbVl0=;
 b=WHyNrnIpN/LzI0JS05Bgt6l6TofI7WFo1Nc5eNZrK01bejxA65cP2nEj6scxdj/ytSz9
 YK4WWnplzGhpb/xXy2ZEfodujOHRJup0gRttlJaD86ApCtN/5s4C0Pl0fLzm849G4Ez7
 16wit2qPiHT9lwB/DJivLOSBfFmSx3q1AUE2xgpiGqJgCCWi1I8Lqgx5Fr3HYg0Oo1vp
 0LOdmDdKI0Lzt2JH+iJcRUSxIBjE8lF6bmJdEhBBGpkgVz5OGF8xaTHHeffDgm/seksP
 AIV4dYo/4tv7VuA+qiYqsr0cM8SSiPmo9JUCNWRbN/P77WZkDFXW7E291H3kwDIKpKkh eg== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2u52ahdxpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 19:38:08 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x79IVrvZ007192;
        Fri, 9 Aug 2019 11:38:06 -0700
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 2u5888k02v-1;
        Fri, 09 Aug 2019 11:38:06 -0700
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id DCB601FFEF;
        Fri,  9 Aug 2019 18:38:05 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, edumazet@google.com,
        ncardwell@google.com
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
 <1565221950-1376-2-git-send-email-johunt@akamai.com>
 <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <3353da97-e015-7303-6e10-7e3e99a50a8f@akamai.com>
Date:   Fri, 9 Aug 2019 11:38:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=736
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090182
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-09_06:2019-08-09,2019-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxlogscore=749 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908090182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 11:13 PM, Eric Dumazet wrote:
> 
> 
> On 8/8/19 1:52 AM, Josh Hunt wrote:
>> TCP_BASE_MSS is used as the default initial MSS value when MTU probing is
>> enabled. Update the comment to reflect this.
>>
>> Suggested-by: Neal Cardwell <ncardwell@google.com>
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> ---
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 

Dave

I forgot to tag these at net-next. Do I need to resubmit a v3 with 
net-next in the subject?

Thanks
Josh
