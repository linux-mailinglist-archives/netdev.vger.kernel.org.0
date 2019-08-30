Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B102BA35E5
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfH3Lm5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Aug 2019 07:42:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727417AbfH3Lm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 07:42:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UBgldd049034
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 07:42:55 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq2qjh2d1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 07:42:55 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 30 Aug 2019 12:42:53 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 30 Aug 2019 12:42:49 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UBgm6P51707962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:42:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFA1611C04C;
        Fri, 30 Aug 2019 11:42:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D87011C04A;
        Fri, 30 Aug 2019 11:42:48 +0000 (GMT)
Received: from dyn-9-152-96-21.boeblingen.de.ibm.com (unknown [9.152.96.21])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 11:42:48 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next v2 0/4] tools: bpftool: improve bpftool build
 experience
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190830110040.31257-1-quentin.monnet@netronome.com>
Date:   Fri, 30 Aug 2019 13:42:48 +0200
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Transfer-Encoding: 8BIT
References: <20190830110040.31257-1-quentin.monnet@netronome.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19083011-4275-0000-0000-0000035F0D94
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19083011-4276-0000-0000-000038714794
Message-Id: <A222439F-07F7-4256-B00D-72F1E4C2906D@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 30.08.2019 um 13:00 schrieb Quentin Monnet <quentin.monnet@netronome.com>:
> 
> Hi,
> This set attempts to make it easier to build bpftool, in particular when
> passing a specific output directory. This is a follow-up to the
> conversation held last month by Lorenz, Ilya and Jakub [0].
> 
> The first patch is a minor fix to bpftool's Makefile, regarding the
> retrieval of kernel version (which currently prints a non-relevant make
> warning on some invocations).
> 
> Second patch improves the Makefile commands to support more "make"
> invocations, or to fix building with custom output directory. On Jakub's
> suggestion, a script is also added to BPF selftests in order to keep track
> of the supported build variants.
> 
> Building bpftool with "make tools/bpf" from the top of the repository
> generates files in "libbpf/" and "feature/" directories under tools/bpf/
> and tools/bpf/bpftool/. The third patch ensures such directories are taken
> care of on "make clean", and add them to the relevant .gitignore files.
> 
> At last, fourth patch is a sligthly modified version of Ilya's fix
> regarding libbpf.a appearing twice on the linking command for bpftool.
> 
> [0] https://lore.kernel.org/bpf/CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com/
> 
> v2:
> - Return error from check script if one of the make invocations returns
>  non-zero (even if binary is successfully produced).
> - Run "make clean" from bpf/ and not only bpf/bpftool/ in that same script,
>  when relevant.
> - Add a patch to clean up generated "feature/" and "libbpf/" directories.
> 
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> Quentin Monnet (4):
>  tools: bpftool: ignore make built-in rules for getting kernel version
>  tools: bpftool: improve and check builds for different make
>    invocations
>  tools: bpf: account for generated feature/ and libbpf/ directories
>  tools: bpftool: do not link twice against libbpf.a in Makefile
> 
> tools/bpf/.gitignore                          |   1 +
> tools/bpf/Makefile                            |   5 +-
> tools/bpf/bpftool/.gitignore                  |   2 +
> tools/bpf/bpftool/Makefile                    |  28 ++--
> tools/testing/selftests/bpf/Makefile          |   3 +-
> .../selftests/bpf/test_bpftool_build.sh       | 143 ++++++++++++++++++
> 6 files changed, 167 insertions(+), 15 deletions(-)
> create mode 100755 tools/testing/selftests/bpf/test_bpftool_build.sh
> 
> -- 
> 2.17.1

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>

for the whole series.
