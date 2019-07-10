Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A0B645D1
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfGJLfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:35:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbfGJLfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:35:02 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ABVs9g016158
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:35:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tne42jwfr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:35:01 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <gor@linux.ibm.com>;
        Wed, 10 Jul 2019 12:34:59 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 10 Jul 2019 12:34:57 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6ABYt8W49479812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 11:34:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7BDFA4053;
        Wed, 10 Jul 2019 11:34:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8614BA4040;
        Wed, 10 Jul 2019 11:34:55 +0000 (GMT)
Received: from localhost (unknown [9.152.212.168])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 10 Jul 2019 11:34:55 +0000 (GMT)
Date:   Wed, 10 Jul 2019 13:34:54 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update BPF JIT S390 maintainers
References: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
X-TM-AS-GCONF: 00
x-cbid: 19071011-0012-0000-0000-00000330F481
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071011-0013-0000-0000-0000216A5D48
Message-Id: <your-ad-here.call-01562758494-ext-2794@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 12:43:45PM +0200, Vasily Gorbik wrote:
> Ilya Leoshkevich is joining as s390 bpf maintainer. With his background
> as gcc developer he would be valuable for the team and community as a
> whole. Ilya, have fun!
> 
> Since there is now enough eyes on s390 bpf, relieve Christian Borntraeger,
> so that he could focus on his maintainer tasks for other components.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 558acf24ea1e..98e7411dfe56 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3066,9 +3066,9 @@ S:	Maintained
>  F:	arch/riscv/net/
>  
>  BPF JIT for S390
> +M:	Ilya Leoshkevich <iii@linux.ibm.com>
>  M:	Heiko Carstens <heiko.carstens@de.ibm.com>
>  M:	Vasily Gorbik <gor@linux.ibm.com>
> -M:	Christian Borntraeger <borntraeger@de.ibm.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Maintained
> -- 
> 2.21.0

Dave, Alexei, Daniel,
would you take it via one of your trees? Or should I take it via s390?

Thanks,
Vasily

