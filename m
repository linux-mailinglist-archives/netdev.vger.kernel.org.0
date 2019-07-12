Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08CA66986
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfGLJAG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Jul 2019 05:00:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfGLJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 05:00:03 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6C8vGMl078536
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 05:00:02 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpmcgpx7r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 05:00:02 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 12 Jul 2019 09:59:59 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 09:59:57 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6C8xheg40763698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 08:59:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15329AE053;
        Fri, 12 Jul 2019 08:59:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDD8EAE045;
        Fri, 12 Jul 2019 08:59:55 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 08:59:55 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v4 bpf-next 1/4] selftests/bpf: compile progs with
 -D__TARGET_ARCH_$(SRCARCH)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAEf4BzYwwqn9ATwPyVcJ8nBQM+rvaFp7KBFjqbYY4GKda3G8jA@mail.gmail.com>
Date:   Fri, 12 Jul 2019 10:59:55 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Transfer-Encoding: 8BIT
References: <20190711142930.68809-1-iii@linux.ibm.com>
 <20190711142930.68809-2-iii@linux.ibm.com>
 <CAEf4BzYwwqn9ATwPyVcJ8nBQM+rvaFp7KBFjqbYY4GKda3G8jA@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071208-0016-0000-0000-000002920156
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071208-0017-0000-0000-000032EFC4B9
Message-Id: <6E5C9DDE-FF1D-4BFA-813E-7A0C3232B5F0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=840 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 12.07.2019 um 02:53 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> 
> On Thu, Jul 11, 2019 at 7:32 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> This opens up the possibility of accessing registers in an
>> arch-independent way.
>> 
>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> ---
>> tools/testing/selftests/bpf/Makefile | 4 +++-
>> 1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>> index 2620406a53ec..ad84450e4ab8 100644
>> --- a/tools/testing/selftests/bpf/Makefile
>> +++ b/tools/testing/selftests/bpf/Makefile
>> @@ -1,4 +1,5 @@
>> # SPDX-License-Identifier: GPL-2.0
>> +include ../../../scripts/Makefile.arch
>> 
>> LIBDIR := ../../../lib
>> BPFDIR := $(LIBDIR)/bpf
>> @@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
>> 
>> CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
>>              $(CLANG_SYS_INCLUDES) \
>> -             -Wno-compare-distinct-pointer-types
>> +             -Wno-compare-distinct-pointer-types \
>> +             -D__TARGET_ARCH_$(SRCARCH)
> 
> samples/bpf/Makefile uses $(ARCH), why does it work for samples?
> Should we update samples/bpf/Makefile as well?

I believe that in common cases both are okay, but judging by
linux:Makefile and linux:tools/scripts/Makefile.arch, one could use e.g.
ARCH=i686, and that would be converted to SRCARCH=x86. So IMHO SRCARCH
is safer, and we should change bpf/samples/Makefile. I could send a
patch separately.
