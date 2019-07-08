Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D494B62B31
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404815AbfGHVop convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 17:44:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730589AbfGHVop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:44:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68LWm2L079431
        for <netdev@vger.kernel.org>; Mon, 8 Jul 2019 17:44:44 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmbtrv72t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 17:44:43 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Mon, 8 Jul 2019 22:44:41 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 22:44:38 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68Libdu49938670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 21:44:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73FC9A4040;
        Mon,  8 Jul 2019 21:44:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAF81A4055;
        Mon,  8 Jul 2019 21:44:36 +0000 (GMT)
Received: from [9.145.50.9] (unknown [9.145.50.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 21:44:36 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next] selftests/bpf: make verifier loop tests arch
 independent
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190708212012.GA9509@mini-arch>
Date:   Mon, 8 Jul 2019 23:44:36 +0200
Cc:     Y Song <ys114321@gmail.com>, Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Transfer-Encoding: 8BIT
References: <20190703205100.142904-1-sdf@google.com>
 <CAH3MdRWePmAZNRfGNcBdjKAJ+D33=4Vgg1STYC3khNps8AmaHQ@mail.gmail.com>
 <20190708161338.GC29524@mini-arch>
 <99593C98-5DEC-4B18-AE6D-271DD8A8A7F6@linux.ibm.com>
 <20190708212012.GA9509@mini-arch>
To:     Stanislav Fomichev <sdf@fomichev.me>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19070821-4275-0000-0000-0000034A5043
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070821-4276-0000-0000-0000385A78BD
Message-Id: <E857E35C-4049-4189-9418-DD225B74CA4D@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 08.07.2019 um 23:20 schrieb Stanislav Fomichev <sdf@fomichev.me>:
> 
> On 07/08, Ilya Leoshkevich wrote:
>> 
>> 
>>> Am 08.07.2019 um 18:13 schrieb Stanislav Fomichev <sdf@fomichev.me>:
>>> 
>>> On 07/03, Y Song wrote:
>>>> On Wed, Jul 3, 2019 at 1:51 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>> 
>>>>> Take the first x bytes of pt_regs for scalability tests, there is
>>>>> no real reason we need x86 specific rax.
>>>>> 
>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>> ---
>>>>> tools/testing/selftests/bpf/progs/loop1.c | 3 ++-
>>>>> tools/testing/selftests/bpf/progs/loop2.c | 3 ++-
>>>>> tools/testing/selftests/bpf/progs/loop3.c | 3 ++-
>>>>> 3 files changed, 6 insertions(+), 3 deletions(-)
>>>>> 
>>>>> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
>>>>> index dea395af9ea9..d530c61d2517 100644
>>>>> --- a/tools/testing/selftests/bpf/progs/loop1.c
>>>>> +++ b/tools/testing/selftests/bpf/progs/loop1.c
>>>>> @@ -14,11 +14,12 @@ SEC("raw_tracepoint/kfree_skb")
>>>>> int nested_loops(volatile struct pt_regs* ctx)
>>>>> {
>>>>>       int i, j, sum = 0, m;
>>>>> +       volatile int *any_reg = (volatile int *)ctx;
>>>>> 
>>>>>       for (j = 0; j < 300; j++)
>>>>>               for (i = 0; i < j; i++) {
>>>>>                       if (j & 1)
>>>>> -                               m = ctx->rax;
>>>>> +                               m = *any_reg;
>>>> 
>>>> I agree. ctx->rax here is only to generate some operations, which
>>>> cannot be optimized away by the compiler. dereferencing a volatile
>>>> pointee may just serve that purpose.
>>>> 
>>>> Comparing the byte code generated with ctx->rax and *any_reg, they are
>>>> slightly different. Using *any_reg is slighly worse, but this should
>>>> be still okay for the test.
>>>> 
>>>>>                       else
>>>>>                               m = j;
>>>>>                       sum += i * m;
>>>>> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
>>>>> index 0637bd8e8bcf..91bb89d901e3 100644
>>>>> --- a/tools/testing/selftests/bpf/progs/loop2.c
>>>>> +++ b/tools/testing/selftests/bpf/progs/loop2.c
>>>>> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
>>>>> int while_true(volatile struct pt_regs* ctx)
>>>>> {
>>>>>       int i = 0;
>>>>> +       volatile int *any_reg = (volatile int *)ctx;
>>>>> 
>>>>>       while (true) {
>>>>> -               if (ctx->rax & 1)
>>>>> +               if (*any_reg & 1)
>>>>>                       i += 3;
>>>>>               else
>>>>>                       i += 7;
>>>>> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
>>>>> index 30a0f6cba080..3a7f12d7186c 100644
>>>>> --- a/tools/testing/selftests/bpf/progs/loop3.c
>>>>> +++ b/tools/testing/selftests/bpf/progs/loop3.c
>>>>> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
>>>>> int while_true(volatile struct pt_regs* ctx)
>>>>> {
>>>>>       __u64 i = 0, sum = 0;
>>>>> +       volatile __u64 *any_reg = (volatile __u64 *)ctx;
>>>>>       do {
>>>>>               i++;
>>>>> -               sum += ctx->rax;
>>>>> +               sum += *any_reg;
>>>>>       } while (i < 0x100000000ULL);
>>>>>       return sum;
>>>>> }
>>>>> --
>>>>> 2.22.0.410.gd8fdbe21b5-goog
>>>> 
>>>> Ilya Leoshkevich (iii@linux.ibm.com, cc'ed) has another patch set
>>>> trying to solve this problem by introducing s360 arch register access
>>>> macros. I guess for now that patch set is not needed any more?
>>> Oh, I missed them. Do they fix the tests for other (non-s360) arches as
>>> well? I was trying to fix the issue by not depending on any arch
>>> specific stuff because the test really doesn't care :-)
>> 
>> They are supposed to work for everything that defines PT_REGS_RC in
>> bpf_helpers.h, but I have to admit I tested only x86_64 and s390.
>> 
>> The main source of problems with my approach were mismatching definitions
>> of struct pt_regs for userspace and kernel, and because of that there was
>> some tweaking required for both arches. I will double check how it looks
>> for others (arm, mips, ppc, sparc) tomorrow.
> Thanks, I've tested your patches and they fix my issue as well. So you
> can have my Tested-by if we'd go with your approach.
> 
> One thing I don't understand is: why do you add 'ifdef __KERNEL__' to
> the bpf_helpers.h for x86 case? Who is using bpf_helpers.h with
> __KERNEL__ defined? Is it perf?

That’s samples/bpf. Also, there is a modified copy of it in bcc
(src/cc/export/helpers.h), which also gets built with __KERNEL__.

Best regards,
Ilya
