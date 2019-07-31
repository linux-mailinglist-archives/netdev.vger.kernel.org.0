Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6007C341
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbfGaNWR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 31 Jul 2019 09:22:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729405AbfGaNWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:17 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VDHSIj060062
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 09:22:16 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u39p5xsre-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 09:21:58 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 31 Jul 2019 14:21:31 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 31 Jul 2019 14:21:27 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VDLQkp51249302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 13:21:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CA415204E;
        Wed, 31 Jul 2019 13:21:26 +0000 (GMT)
Received: from dyn-9-152-97-97.boeblingen.de.ibm.com (unknown [9.152.97.97])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1D4FA52059;
        Wed, 31 Jul 2019 13:21:26 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next 1/9] selftests/bpf: prevent headers to be
 compiled as C code
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAEf4Bzbj6RWUo8Q7wgMnbL=T7V2yK2=gbdO3sSfxJ71Gp6jeYA@mail.gmail.com>
Date:   Wed, 31 Jul 2019 15:21:25 +0200
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Transfer-Encoding: 8BIT
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-2-andriin@fb.com> <20190726212152.GA24397@mini-arch>
 <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
 <20190726220119.GE24397@mini-arch>
 <CAEf4Bzbj6RWUo8Q7wgMnbL=T7V2yK2=gbdO3sSfxJ71Gp6jeYA@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19073113-0020-0000-0000-00000358FB1B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19073113-0021-0000-0000-000021AD0501
Message-Id: <3D822EE0-C033-4192-B505-A30E5EC23BC3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 27.07.2019 um 20:53 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> 
> On Fri, Jul 26, 2019 at 3:01 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>> 
>> On 07/26, Andrii Nakryiko wrote:
>>> On Fri, Jul 26, 2019 at 2:21 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>>>> 
>>>> On 07/26, Andrii Nakryiko wrote:
>>>>> Apprently listing header as a normal dependency for a binary output
>>>>> makes it go through compilation as if it was C code. This currently
>>>>> works without a problem, but in subsequent commits causes problems for
>>>>> differently generated test.h for test_progs. Marking those headers as
>>>>> order-only dependency solves the issue.
>>>> Are you sure it will not result in a situation where
>>>> test_progs/test_maps is not regenerated if tests.h is updated.
>>>> 
>>>> If I read the following doc correctly, order deps make sense for
>>>> directories only:
>>>> https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
>>>> 
>>>> Can you maybe double check it with:
>>>> * make
>>>> * add new prog_tests/test_something.c
>>>> * make
>>>> to see if the binary is regenerated with test_something.c?
>>> 
>>> Yeah, tested that, it triggers test_progs rebuild.
>>> 
>>> Ordering is still preserved, because test.h is dependency of
>>> test_progs.c, which is dependency of test_progs binary, so that's why
>>> it works.
>>> 
>>> As to why .h file is compiled as C file, I have no idea and ideally
>>> that should be fixed somehow.
>> I guess that's because it's a prerequisite and we have a target that
>> puts all prerequisites when calling CC:
>> 
>> test_progs: a.c b.c tests.h
>>        gcc a.c b.c tests.h -o test_progs
>> 
>> So gcc compiles each input file.
> 
> If that's really a definition of the rule, then it seems not exactly
> correct. What if some of the prerequisites are some object files,
> directories, etc. I'd say the rule should only include .c files. I'll
> add it to my TODO list to go and check how all this is defined
> somewhere, but for now I'm leaving everything as is in this patch.
> 

I believe it’s an implicit built-in rule, which is defined by make
itself here:

https://git.savannah.gnu.org/cgit/make.git/tree/default.c?h=4.2.1#n131

The observed behavior arises because these rules use $^ all over the
place. My 2c is that it would be better to make the rule explicit,
because it would cost just an extra line, but it would be immediately
obvious why the code is correct w.r.t. rebuilds.

Best regards,
Ilya
