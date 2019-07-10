Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6341C643FA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGJJAF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 05:00:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbfGJJAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 05:00:01 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6A8vfDg046330
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:00:00 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tnbk5uwxq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:00:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 10 Jul 2019 09:59:58 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 10 Jul 2019 09:59:57 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6A8xu7L50725092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 08:59:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EE825204E;
        Wed, 10 Jul 2019 08:59:56 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4E52F5204F;
        Wed, 10 Jul 2019 08:59:56 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] selftests/bpf: fix bpf_target_sparc check
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAEf4BzZswDkvPbhNnovLjWWmmhR2VBWtrCJkpMXM8M_5Ztn4-w@mail.gmail.com>
Date:   Wed, 10 Jul 2019 10:59:39 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
References: <20190709152126.37853-1-iii@linux.ibm.com>
 <CAEf4BzZswDkvPbhNnovLjWWmmhR2VBWtrCJkpMXM8M_5Ztn4-w@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071008-4275-0000-0000-0000034B4AA2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071008-4276-0000-0000-0000385B4D6F
Message-Id: <D784EE92-0B53-4D9F-BBD0-46DDA1483573@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 09.07.2019 um 19:56 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> 
> On Tue, Jul 9, 2019 at 8:22 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> bpf_helpers.h fails to compile on sparc: the code should be checking
>> for defined(bpf_target_sparc), but checks simply for bpf_target_sparc.
>> 
>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> ---
>> tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
>> index 5f6f9e7aba2a..a8fea087aa90 100644
>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
>> @@ -443,7 +443,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>> #ifdef bpf_target_powerpc
> 
> While at it, can you please also fix this one?

Do you mean #ifdef bpf_target_powerpc? I think it’s correct, because it’s #ifdef, not #if.
But I could change it to #if defined() for consistency.

Best regards,
Ilya
