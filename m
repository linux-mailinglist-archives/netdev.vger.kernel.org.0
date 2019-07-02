Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA25D4EA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfGBQ6m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Jul 2019 12:58:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbfGBQ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:58:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62GvsfJ189647
        for <netdev@vger.kernel.org>; Tue, 2 Jul 2019 12:58:40 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tg8ub6ms2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 12:58:40 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 2 Jul 2019 17:58:38 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 2 Jul 2019 17:58:35 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62GwYLA39780482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 16:58:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C399FA4054;
        Tue,  2 Jul 2019 16:58:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2A49A405B;
        Tue,  2 Jul 2019 16:58:34 +0000 (GMT)
Received: from dyn-9-152-98-98.boeblingen.de.ibm.com (unknown [9.152.98.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 16:58:34 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on
 s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAH3MdRUk5x2D9yRuKpGpVuDMFF0JbYeB+Y0Qz6chtPgfm-1vxA@mail.gmail.com>
Date:   Tue, 2 Jul 2019 18:58:34 +0200
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
References: <20190702153908.41562-1-iii@linux.ibm.com>
 <CAH3MdRUk5x2D9yRuKpGpVuDMFF0JbYeB+Y0Qz6chtPgfm-1vxA@mail.gmail.com>
To:     Y Song <ys114321@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19070216-0020-0000-0000-0000034F8CD6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070216-0021-0000-0000-000021A31F2A
Message-Id: <1AE29825-8FB2-4682-8822-5F3D16965657@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 02.07.2019 um 18:42 schrieb Y Song <ys114321@gmail.com>:
> 
> On Tue, Jul 2, 2019 at 8:40 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> -#elif defined(__s390x__)
>> -       #define bpf_target_s930x
> 
> I see in some other places (e.g., bcc) where
> macro __s390x__ is also used to indicate a s390 architecture.
> Could you explain the difference between __s390__ and
> __s390x__?

__s390__ is defined for 32-bit and 64-bit variants, __s390x__ is defined
for 64-bit variant only.

>> #if defined(bpf_target_x86)
>> 
>> +#ifdef __KERNEL__
> 
> In samples/bpf/,  __KERNEL__ is defined at clang options and
> in selftests/bpf/, the __KERNEL__ is not defined.
> 
> I checked x86 pt_regs definition with and without __KERNEL__.
> They are identical except some register name difference.
> I am wondering whether we can unify into all without
> __KERNEL__. Is __KERNEL__ really needed?

Right now removing it causes the build to fail, but the errors look
fixable. However, I wonder whether there is a plan regarding this:
should eBPF programs be built with user headers, kernel headers,
or both? Status quo appears to be "both", so I’ve decided to stick with
that in this patch.

>> +/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
>> +struct pt_regs;
>> +#define PT_REGS_PARM1(x) (((const volatile user_pt_regs *)(x))->gprs[2])
> 
> Is user_pt_regs a recent change or has been there for quite some time?
> I am asking since bcc did not use user_pt_regs yet.

It was added in late 2017 in commit 466698e654e8 ("s390/bpf: correct
broken uapi for BPF_PROG_TYPE_PERF_EVENT program type“).
