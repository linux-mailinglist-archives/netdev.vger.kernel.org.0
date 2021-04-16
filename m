Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459673620E3
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243896AbhDPN1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:27:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235674AbhDPN1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:27:15 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GD2sdn042295;
        Fri, 16 Apr 2021 09:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=aquu956fTIgz3+7lHAMaLfz7OxkPFtlsRwWtasPoQFk=;
 b=QK8NVpZ19MXq25sAj1JJHLyZ0/RzDgoe/m614DZYRlLTMcpispCtiyqE6lQfPZD/c7oo
 Uuamk1zCbI2lJo3BA5q96got9BF0iilqHa8Mao0numS4RNkTNWB2dMvMrVn2Tz4YOKmT
 9Vh3p4Hkw9+YqIlv+MS9rHtJ13AWwytVSunNaxUgxpiH2ITjY9EncXHrO8/ClpNMH+nD
 yadcRcWRhhXFcN6RJLajkF3+QB/j8LeMG+5LtmYJHAWeJfpAhHxHXOTkmBvQmfkTT2nT
 uQ7pDq9IEIZsfLxQXpfZGVKMZIjbUD0/RXhnxKf4iixssNqwUR02ev7GtQ3fU/ooZPda sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37y8rnvu96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 09:26:13 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13GD2qfE042187;
        Fri, 16 Apr 2021 09:26:11 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37y8rnvu3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 09:26:11 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13GDNG9O019900;
        Fri, 16 Apr 2021 13:26:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 37u39hadvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 13:26:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13GDQ3ho46137672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 13:26:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A9A14C052;
        Fri, 16 Apr 2021 13:26:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3F3B4C044;
        Fri, 16 Apr 2021 13:26:01 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.64.24])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 16 Apr 2021 13:26:01 +0000 (GMT)
Subject: Re: [PATCH v2] tools: do not include scripts/Kbuild.include
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
References: <20210416130051.239782-1-masahiroy@kernel.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ee99eb80-5711-9349-23a4-0faf8d7b60a8@de.ibm.com>
Date:   Fri, 16 Apr 2021 15:26:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210416130051.239782-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -nujXjQtsLSCrONtCNjn6qt7wKYvylhh
X-Proofpoint-ORIG-GUID: 7gO-O2XrzlXYQU9_QTO3narixz6-3GWN
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_07:2021-04-15,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.04.21 15:00, Masahiro Yamada wrote:
> Since commit d9f4ff50d2aa ("kbuild: spilt cc-option and friends to
> scripts/Makefile.compiler"), some kselftests fail to build.
> 
> The tools/ directory opted out Kbuild, and went in a different
> direction. They copy any kind of files to the tools/ directory
> in order to do whatever they want in their world.
> 
> tools/build/Build.include mimics scripts/Kbuild.include, but some
> tool Makefiles included the Kbuild one to import a feature that is
> missing in tools/build/Build.include:
> 
>   - Commit ec04aa3ae87b ("tools/thermal: tmon: use "-fstack-protector"
>     only if supported") included scripts/Kbuild.include from
>     tools/thermal/tmon/Makefile to import the cc-option macro.
> 
>   - Commit c2390f16fc5b ("selftests: kvm: fix for compilers that do
>     not support -no-pie") included scripts/Kbuild.include from
>     tools/testing/selftests/kvm/Makefile to import the try-run macro.
> 
>   - Commit 9cae4ace80ef ("selftests/bpf: do not ignore clang
>     failures") included scripts/Kbuild.include from
>     tools/testing/selftests/bpf/Makefile to import the .DELETE_ON_ERROR
>     target.
> 
>   - Commit 0695f8bca93e ("selftests/powerpc: Handle Makefile for
>     unrecognized option") included scripts/Kbuild.include from
>     tools/testing/selftests/powerpc/pmu/ebb/Makefile to import the
>     try-run macro.
> 
> Copy what they need into tools/build/Build.include, and make them
> include it instead of scripts/Kbuild.include.
> 
> Link: https://lore.kernel.org/lkml/86dadf33-70f7-a5ac-cb8c-64966d2f45a1@linux.ibm.com/
> Fixes: d9f4ff50d2aa ("kbuild: spilt cc-option and friends to scripts/Makefile.compiler")
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

looks better.
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
