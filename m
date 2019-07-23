Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A902571B36
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390776AbfGWPOe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 11:14:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390767AbfGWPOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:14:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NFBSag132501
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 11:14:31 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tx395va0q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 11:14:29 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 23 Jul 2019 16:14:28 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 23 Jul 2019 16:14:25 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6NFEOGA33226826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 15:14:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC4DDA405C;
        Tue, 23 Jul 2019 15:14:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48507A4054;
        Tue, 23 Jul 2019 15:14:24 +0000 (GMT)
Received: from [9.145.183.72] (unknown [9.145.183.72])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Jul 2019 15:14:24 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190719111716.1cbf62d1@cakuba.netronome.com>
Date:   Tue, 23 Jul 2019 17:14:23 +0200
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, lmb@cloudflare.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Transfer-Encoding: 8BIT
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
 <20190718142041.83342-1-iii@linux.ibm.com>
 <20190718115111.643027cf@cakuba.netronome.com>
 <43FB794B-6200-4560-BF10-BBF4B9247913@linux.ibm.com>
 <20190719111716.1cbf62d1@cakuba.netronome.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19072315-0028-0000-0000-0000038721BA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072315-0029-0000-0000-000024475A5C
Message-Id: <06890ADF-E310-41D1-9A4A-26755296F525@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 19.07.2019 um 20:17 schrieb Jakub Kicinski <jakub.kicinski@netronome.com>:
> 
> On Fri, 19 Jul 2019 15:12:24 +0200, Ilya Leoshkevich wrote:
>>> Am 18.07.2019 um 20:51 schrieb Jakub Kicinski <jakub.kicinski@netronome.com>:
>>> 
>>> We should probably make a script with all the ways of calling make
>>> should work. Otherwise we can lose track too easily.  
>> 
>> Thanks for the script!
>> 
>> I’m trying to make it all pass now, and hitting a weird issue in the
>> Kbuild case. The build prints "No rule to make target
>> 'scripts/Makefile.ubsan.o'" and proceeds with an empty BPFTOOL_VERSION,
>> which causes problems later on.
> 
> Does it only break with UBSAN enabled?

No, all the time. I think this is a coincidence - make happens to scan
scripts/Makefile.ubsan first.

> 
>> I've found that this is caused by sub_make_done=1 environment variable,
>> and unsetting it indeed fixes the problem, since the root Makefile no
>> longer uses the implicit %.o rule.
>> 
>> However, I wonder if that would be acceptable in the final version of
>> the patch, and whether there is a cleaner way to achieve the same
>> effect?
> 
> I'm not sure to be honest. Did you check how perf deals with that?

perf obtains the version using "git describe". However, if we are
building it from a tarball, it falls back to "make kernelversion" and
fails in a similar way:

linux-5.3-rc1$ make defconfig
linux-5.3-rc1$ make tools/perf
<snip>
make[6]: Circular scripts/Makefile.ubsan.mod <- scripts/Makefile.ubsan.o dependency dropped.
make[6]: m2c: Command not found
make[6]: *** [<builtin>: scripts/Makefile.ubsan.o] Error 127
make[5]: *** [Makefile:1765: scripts/Makefile.ubsan.o] Error 2
<snip>

The same trick helps:

--- tools/perf/util/PERF-VERSION-GEN.orig	2019-07-23 17:12:07.621123187 +0200
+++ tools/perf/util/PERF-VERSION-GEN	2019-07-23 17:12:33.441133619 +0200
@@ -26,7 +26,7 @@
 fi
 if test -z "$TAG"
 then
-	TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
+	TAG=$(MAKEFLAGS= sub_make_done= make -sC ../.. kernelversion)
 fi
 VN="$TAG$CID"
 if test -n "$CID"
