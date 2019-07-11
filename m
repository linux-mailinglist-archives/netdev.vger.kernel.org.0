Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623E3659DD
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfGKPAr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Jul 2019 11:00:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728725AbfGKPAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 11:00:47 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BExhZE079156
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 11:00:46 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tp74f8rxh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 11:00:45 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 11 Jul 2019 16:00:42 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 16:00:38 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BF0bkp12648538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 15:00:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D23A64204C;
        Thu, 11 Jul 2019 15:00:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B08C44203F;
        Thu, 11 Jul 2019 15:00:37 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 15:00:37 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v3 bpf] selftests/bpf: do not ignore clang failures
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAEf4Bzb6mY-F-wUNNimS+hMSRbJetTKXNcGDQbsJXhXDywA+tg@mail.gmail.com>
Date:   Thu, 11 Jul 2019 17:00:37 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <liu.song.a23@gmail.com>
Content-Transfer-Encoding: 8BIT
References: <20190711091249.59865-1-iii@linux.ibm.com>
 <CAEf4Bzb6mY-F-wUNNimS+hMSRbJetTKXNcGDQbsJXhXDywA+tg@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071115-0016-0000-0000-00000291CE55
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071115-0017-0000-0000-000032EF8E88
Message-Id: <51821F5F-A70F-485B-B6E7-CAE6D49B6D1D@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 11.07.2019 um 16:55 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> 
> On Thu, Jul 11, 2019 at 2:14 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> 
>> In addition, pull Kbuild.include in order to get .DELETE_ON_ERROR target,
> 
> In your original patch you explicitly declared .DELETE_ON_ERROR, but
> in this one you just include Kbuild.include.
> Is it enough to just include that file to get desired behavior or your
> forgot to add .DELETE_ON_ERROR?

It’s enough to just include Kbuild.include. I grepped the source tree
and found that no one else declares .DELETE_ON_ERROR explicitly, so I've
decided to avoid doing this as well.
