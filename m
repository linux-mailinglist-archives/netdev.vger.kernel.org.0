Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731DC64567
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 12:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfGJKuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 06:50:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfGJKun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 06:50:43 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AAlLbx061998
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:50:42 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tneg5r7uj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:50:42 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 10 Jul 2019 11:50:40 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 10 Jul 2019 11:50:36 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6AAoZ8n47317090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 10:50:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 179E34C059;
        Wed, 10 Jul 2019 10:50:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9C624C044;
        Wed, 10 Jul 2019 10:50:34 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jul 2019 10:50:34 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH] MAINTAINERS: update BPF JIT S390 maintainers
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
Date:   Wed, 10 Jul 2019 12:50:34 +0200
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Transfer-Encoding: 7bit
References: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
To:     Vasily Gorbik <gor@linux.ibm.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071010-0016-0000-0000-00000290E8D1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071010-0017-0000-0000-000032EEA1CC
Message-Id: <54C8D874-212A-4CA9-9654-5624AD8A61B4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=962 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 10.07.2019 um 12:43 schrieb Vasily Gorbik <gor@linux.ibm.com>:
> 
> Ilya Leoshkevich is joining as s390 bpf maintainer. With his background
> as gcc developer he would be valuable for the team and community as a
> whole. Ilya, have fun!
> 
> Since there is now enough eyes on s390 bpf, relieve Christian Borntraeger,
> so that he could focus on his maintainer tasks for other components.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 558acf24ea1e..98e7411dfe56 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3066,9 +3066,9 @@ S:	Maintained
> F:	arch/riscv/net/
> 
> BPF JIT for S390
> +M:	Ilya Leoshkevich <iii@linux.ibm.com>
> M:	Heiko Carstens <heiko.carstens@de.ibm.com>
> M:	Vasily Gorbik <gor@linux.ibm.com>
> -M:	Christian Borntraeger <borntraeger@de.ibm.com>
> L:	netdev@vger.kernel.org
> L:	bpf@vger.kernel.org
> S:	Maintained
> -- 
> 2.21.0

Thanks, Vasily!

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

