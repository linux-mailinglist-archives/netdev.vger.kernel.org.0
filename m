Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB7E6E61B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfGSNMc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 09:12:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726239AbfGSNMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 09:12:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JD8CUY175813
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 09:12:30 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tud5u47gn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 09:12:30 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 19 Jul 2019 14:12:28 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 14:12:25 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6JDCOLa48234528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 13:12:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B600311C054;
        Fri, 19 Jul 2019 13:12:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C50811C04A;
        Fri, 19 Jul 2019 13:12:24 +0000 (GMT)
Received: from dyn-9-152-98-35.boeblingen.de.ibm.com (unknown [9.152.98.35])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jul 2019 13:12:24 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190718115111.643027cf@cakuba.netronome.com>
Date:   Fri, 19 Jul 2019 15:12:24 +0200
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, lmb@cloudflare.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Transfer-Encoding: 8BIT
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
 <20190718142041.83342-1-iii@linux.ibm.com>
 <20190718115111.643027cf@cakuba.netronome.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071913-0016-0000-0000-000002945E8E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071913-0017-0000-0000-000032F23FEE
Message-Id: <43FB794B-6200-4560-BF10-BBF4B9247913@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 18.07.2019 um 20:51 schrieb Jakub Kicinski <jakub.kicinski@netronome.com>:
> 
> We should probably make a script with all the ways of calling make
> should work. Otherwise we can lose track too easily.

Thanks for the script!

I’m trying to make it all pass now, and hitting a weird issue in the
Kbuild case. The build prints "No rule to make target
'scripts/Makefile.ubsan.o'" and proceeds with an empty BPFTOOL_VERSION,
which causes problems later on.

I've found that this is caused by sub_make_done=1 environment variable,
and unsetting it indeed fixes the problem, since the root Makefile no
longer uses the implicit %.o rule.

However, I wonder if that would be acceptable in the final version of
the patch, and whether there is a cleaner way to achieve the same
effect?

Best regards,
Ilya
