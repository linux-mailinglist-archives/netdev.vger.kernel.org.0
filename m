Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13B41F7088
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFKWqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:46:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbgFKWqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:46:35 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05BMXEua152323;
        Thu, 11 Jun 2020 18:46:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31kknyjvtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 18:46:20 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05BMZSB0162540;
        Thu, 11 Jun 2020 18:46:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31kknyjvt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 18:46:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05BMjYmr015758;
        Thu, 11 Jun 2020 22:46:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s82aed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 22:46:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05BMiw9m60621252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jun 2020 22:44:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8387AE067;
        Thu, 11 Jun 2020 22:46:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 298A6AE065;
        Thu, 11 Jun 2020 22:46:14 +0000 (GMT)
Received: from sig-9-145-174-225.de.ibm.com (unknown [9.145.174.225])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jun 2020 22:46:14 +0000 (GMT)
Message-ID: <e1823b9409720aadb14691fbc4e136ad36c5264c.camel@linux.ibm.com>
Subject: Re: [RFC] .BTF section data alignment issue on s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Jiri Olsa <jolsa@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Frantisek Hrbata <fhrbata@redhat.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Date:   Fri, 12 Jun 2020 00:46:13 +0200
In-Reply-To: <20200611205040.GA1853644@krava>
References: <20200611205040.GA1853644@krava>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 cotscore=-2147483648 priorityscore=1501 mlxlogscore=999 clxscore=1011
 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-11 at 22:50 +0200, Jiri Olsa wrote:
> hi,
> we're hitting a problem on s390 with BTF data alignment.
> 
> When running simple test, we're getting this message from
> verifier and console:
> 
>   bpf_common.c:91: BROK: Failed verification: in-kernel BTF is
> malformed
>   [   41.545572] BPF:Total section length too long
> 
> 
> AFAICS it happens when .BTF section data size is not an even number
> ;-)
> 
> DISCLAIMER I'm quite ignorant of s390x arch details, so most likely
> I'm
> totally wrong and perhaps missing something important and there's
> simple
> explanation.. but here's what got me here:
> 
> 
> ... so BTF data is placed in .BTF section via linker script:
> 
>         .BTF : AT(ADDR(.BTF) - LOAD_OFFSET)
> {                           \
>                 __start_BTF =
> .;                                        \
>                 *(.BTF)                                              
>    \
>                 __stop_BTF =
> .;                                         \
>         }
> 
> 
> and the .BTF data size in btf_parse_vmlinux is computed as:
> 
>         btf->data_size = __stop_BTF - __start_BTF;
> 
> 
> this computation is compiled as:
> 
>         00000000002aeb20 <btf_parse_vmlinux>:
>         ...
>           2aeb8a:  larl    %r1,cda3ac <__start_BTF+0x2084a8>    #
> loads r1 with end
>           2aeb90:  larl    %r2,ad1f04 <__start_BTF>             #
> loads r2 with start
>           2aeb96:  sgr     %r1,%r2                              #
> substract r1 - r2 
> 
> 
> having following values for start/stop_BTF symbols:
> 
>         # nm ./vmlinux | grep __start_BTF
>         0000000000ad1f04 R __start_BTF
>         # nm ./vmlinux | grep __stop_BTF
>         0000000000cda3ad R __stop_BTF
> 
>         -> the BTF data size is 0x2084a9
> 
> 
> but as you can see the instruction that loads the 'end' symbol:
> 
>         larl    %r1,cda3ac <__start_BTF+0x2084a8>
> 
> 
> is loading '__start_BTF + 0x2084a8', which is '__stop_BTF - 1'
> 
> 
> From spec it seems that larl instruction's argument must be even
> number ([1] page 7-214):
> 
>         2.   For  LOAD  RELATIVE  LONG,  the  second  oper-and must
> be aligned
>         on an integral boundary cor-responding to the operand’s
> size. 
> 
> 
> I also found an older bug complaining about this issue [2]:
> 
>         ...
>         larl instruction can only load even values - instructions on
> s390 are 2-byte
>         aligned and the instruction encodes offset to the target in
> 2-byte units.
>         ...
>         The GNU BFD linker for s390 doesn't bother to check if
> relocations fit or are
>         properly aligned. 
>         ...
> 
> 
> I tried to fix that aligning the end to even number, but then
> btf_check_sec_info logic needs to be adjusted as well, and
> probably other places as well.. so I decided to share this
> first.. because it all seems wrong ;-)
> 
> thoughts? thanks,
> jirka
> 
> 
> [1] http://publibfi.boulder.ibm.com/epubs/pdf/dz9zr008.pdf
> [2] https://sourceware.org/bugzilla/show_bug.cgi?id=18960
> 
Hi Jiri,

Actually I recently ran into it myself on Debian, and I believe your
analysis is correct :-) The only thing to add to it is that the
compiler emits the correct instruction (if you look at the .o file),
it's linker that messes things up.

The linker bug in question is [1].

I opened [2] to Debian folks, and I believe that other important
distros (RH, SUSE, Ubuntu) have this fixed already.

Which distro are you using?

Best regards,
Ilya

[1] 
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=e6213e09ed0e
[2] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=961736

