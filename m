Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F331E3B0A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394163AbfJXSca convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 14:32:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40880 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbfJXSca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:32:30 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OIRO0F060554
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 14:32:29 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vucdrs4yt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 14:32:16 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 24 Oct 2019 19:31:20 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 19:31:16 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OIVFSX29229186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 18:31:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB52C4C05E;
        Thu, 24 Oct 2019 18:31:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 818E64C073;
        Thu, 24 Oct 2019 18:31:14 +0000 (GMT)
Received: from dyn-9-152-99-235.boeblingen.de.ibm.com (unknown [9.152.99.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Oct 2019 18:31:14 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <5d2cf6b8-a634-62ea-0b80-1d499aa3c693@fb.com>
Date:   Thu, 24 Oct 2019 20:31:14 +0200
Cc:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
 <C47F20A9-D34A-43C9-AAB5-6F125C73FA16@linux.ibm.com>
 <5d2cf6b8-a634-62ea-0b80-1d499aa3c693@fb.com>
To:     Yonghong Song <yhs@fb.com>
X-Mailer: Apple Mail (2.3594.4.19)
X-TM-AS-GCONF: 00
x-cbid: 19102418-0028-0000-0000-000003AF057E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102418-0029-0000-0000-000024713903
Message-Id: <85F5C807-EDAF-4A85-A5D4-D72FBFFD0A26@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 24.10.2019 um 19:49 schrieb Yonghong Song <yhs@fb.com>:
> 
> 
> 
> On 10/24/19 9:04 AM, Ilya Leoshkevich wrote:
>>> Am 23.10.2019 um 03:35 schrieb Prabhakar Kushwaha <prabhakar.pkin@gmail.com>:
>>> 
>>> 
>>> Adding other mailing list, folks...
>>> 
>>> Hi All,
>>> 
>>> I am trying to build kselftest on Linux-5.4 on ubuntu 18.04. I installed
>>> LLVM-9.0.0 and Clang-9.0.0 from below links after following steps from
>>> [1] because of discussion [2]
>>> 
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__releases.llvm.org_9.0.0_llvm-2D9.0.0.src.tar.xz&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=se8pV6OlDAeF2g5iEAvSB2qhLBJGPaHADv3NQVNFx6U&s=IzBxNhAvcILfAD_XcSB7t0s6-B-wFY3TBoVGH6WhRK8&e=
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__releases.llvm.org_9.0.0_clang-2Dtools-2Dextra-2D9.0.0.src.tar.xz&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=se8pV6OlDAeF2g5iEAvSB2qhLBJGPaHADv3NQVNFx6U&s=KkjCjWm_q2iMfFh50rTKtFqQEMbRBVhT9Oh8KMfgwW4&e=
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__releases.llvm.org_9.0.0_cfe-2D9.0.0.src.tar.xz&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=se8pV6OlDAeF2g5iEAvSB2qhLBJGPaHADv3NQVNFx6U&s=TvkN9sb5rSB5BNxJP27UmCsfNHsRQdaVeAnBa1TkyjM&e=
>>> 
>>> Now, i am trying with llc -march=bpf, with this segmentation fault is
>>> coming as below:
>>> 
>>> gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
>>> -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
>>> -I../../../include -Dbpf_prog_load=bpf_prog_test_load
>>> -Dbpf_load_program=bpf_test_load_program    test_flow_dissector.c
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
>>> -lrt -lpthread -o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_flow_dissector
>>> gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
>>> -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
>>> -I../../../include -Dbpf_prog_load=bpf_prog_test_load
>>> -Dbpf_load_program=bpf_test_load_program
>>> test_tcp_check_syncookie_user.c
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
>>> -lrt -lpthread -o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_tcp_check_syncookie_user
>>> gcc -g -Wall -O2 -I../../../include/uapi -I../../../lib
>>> -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR
>>> -I../../../include -Dbpf_prog_load=bpf_prog_test_load
>>> -Dbpf_load_program=bpf_test_load_program    test_lirc_mode2_user.c
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_stub.o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/libbpf.a -lcap -lelf
>>> -lrt -lpthread -o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_lirc_mode2_user
>>> (clang -I. -I./include/uapi -I../../../include/uapi
>>> -I/usr/src/tovards/linux/tools/testing/selftests/bpf/../usr/include
>>> -D__TARGET_ARCH_arm64 -g -idirafter /usr/local/include -idirafter
>>> /usr/local/lib/clang/9.0.0/include -idirafter
>>> /usr/include/aarch64-linux-gnu -idirafter /usr/include
>>> -Wno-compare-distinct-pointer-types -O2 -target bpf -emit-llvm \
>>> -c progs/test_core_reloc_arrays.c -o - || echo "clang failed") | \
>>> llc -march=bpf -mcpu=probe  -filetype=obj -o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o
>>> Stack dump:
>>> 0. Program arguments: llc -march=bpf -mcpu=probe -filetype=obj -o
>>> /usr/src/tovards/linux/tools/testing/selftests/bpf/test_core_reloc_arrays.o
>>> 1. Running pass 'Function Pass Manager' on module '<stdin>'.
>>> 2. Running pass 'BPF Assembly Printer' on function '@test_core_arrays'
>>> #0 0x0000aaaac618db08 llvm::sys::PrintStackTrace(llvm::raw_ostream&)
>>> (/usr/local/bin/llc+0x152eb08)
>>> Segmentation fault
>> 
>> Hi,
>> 
>> FWIW I can confirm that this is happening on s390 too with llvm-project
>> commit 950b800c451f.
>> 
>> Here is the reduced sample that triggers this (with -march=bpf
>> -mattr=+alu32):
>> 
>> struct b {
>>   int e;
>> } c;
>> int f() {
>>   return __builtin_preserve_field_info(c.e, 0);
>> }
>> 
>> This is compiled into:
>> 
>> 0B      bb.0 (%ir-block.0):
>> 16B       %0:gpr = LD_imm64 @"b:0:0$0:0"
>> 32B       $w0 = COPY %0:gpr, debug-location !17; 1-E.c:5:3
>> 48B       RET implicit killed $w0, debug-location !17; 1-E.c:5:3
>> 
>> and then BPFInstrInfo::copyPhysReg chokes on COPY, since $w0 and %0 are
>> in different register classes.
> 
> Ilya,
> 
> Thanks for reporting. I can reproduce the issue with latest trunk.
> I will investigate and fix the problem soon.
> 
> Yonghong

Thanks for taking care of this! Just FYI, bisect pointed to 05e46979d2f4
("[BPF] do compile-once run-everywhere relocation for bitfields").

Could you please add me to Phabricator review? I'm curious what the
proper solution is going to be, as I'm still not sure whether handling
asymmetric copies is the right approach, or whether they should rather
be prevented from occuring in the first place.

Best regards,
Ilya
