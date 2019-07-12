Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B56696B
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGLI4D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Jul 2019 04:56:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14574 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbfGLI4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 04:56:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6C8rIoR113258
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 04:56:02 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tpm4tfdng-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 04:56:01 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 12 Jul 2019 09:55:58 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 09:55:54 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6C8trdj49741978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 08:55:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C97BAE059;
        Fri, 12 Jul 2019 08:55:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 344EDAE055;
        Fri, 12 Jul 2019 08:55:53 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 08:55:53 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v4 bpf-next 0/4] selftests/bpf: fix compiling
 loop{1,2,3}.c on s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190711203508.GC16709@mini-arch>
Date:   Fri, 12 Jul 2019 10:55:52 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>, daniel@iogearbox.net,
        davem@davemloft.net, ast@kernel.org
Content-Transfer-Encoding: 8BIT
References: <20190711142930.68809-1-iii@linux.ibm.com>
 <20190711203508.GC16709@mini-arch>
To:     Stanislav Fomichev <sdf@fomichev.me>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071208-0020-0000-0000-0000035307CD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071208-0021-0000-0000-000021A6C586
Message-Id: <994CF53F-3E84-4CE8-92C5-B2983AD50EB8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=663 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 11.07.2019 um 22:35 schrieb Stanislav Fomichev <sdf@fomichev.me>:
> 
> On 07/11, Ilya Leoshkevich wrote:
>> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
>> 
>> This patch series consists of three preparatory commits, which make it
>> possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.
>> 
> Still looks good to me, thanks!
> 
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> 
> Again, should probably go via bpf to fix the existing tests, not bpf-next
> (but I see bpf tree is not synced with net tree yet).

Sorry, I missed your comment the last time. You are right - that’s the
reason I’ve been sending this to bpf-next so far — loop*.c don’t even
exist in the bpf tree.
