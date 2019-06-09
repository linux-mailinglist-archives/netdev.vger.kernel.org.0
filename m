Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A33A46E
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfFIJQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 05:16:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33484 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbfFIJQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 05:16:55 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5996wLE022839
        for <netdev@vger.kernel.org>; Sun, 9 Jun 2019 05:16:54 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t0tj0y9k2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 05:16:54 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Sun, 9 Jun 2019 10:16:51 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Jun 2019 10:16:46 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x599Gj1v56492118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jun 2019 09:16:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15AA4A4053;
        Sun,  9 Jun 2019 09:16:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CDE1A404D;
        Sun,  9 Jun 2019 09:16:44 +0000 (GMT)
Received: from osiris (unknown [9.145.173.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun,  9 Jun 2019 09:16:44 +0000 (GMT)
Date:   Sun, 9 Jun 2019 11:16:43 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 00/33] Convert files to ReST - part 1
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560045490.git.mchehab+samsung@kernel.org>
X-TM-AS-GCONF: 00
x-cbid: 19060909-0020-0000-0000-0000034878F1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060909-0021-0000-0000-0000219B9744
Message-Id: <20190609091642.GA3705@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906090069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 11:26:50PM -0300, Mauro Carvalho Chehab wrote:
> This is the first part of a series I wrote sometime ago where I manually
> convert lots of files to be properly parsed by Sphinx as ReST files.
> 
> As it touches on lot of stuff, this series is based on today's docs-next
> + linux-next, at tag next-20190607.
> 
> I have right now about 85 patches with this undergoing work. That's
> because I opted to do ~1 patch per converted directory.
> 
> That sounds too much to be send on a single round. So, I'm opting to split
> it on 3 parts. Those patches should probably be good to be merged
> either by subsystem maintainers or via the docs tree.
> 
> I opted to mark new files not included yet to the main index.rst (directly or
> indirectly ) with the :orphan: tag, in order to avoid adding warnings to the
> build system. This should be removed after we find a "home" for all
> the converted files within the new document tree arrangement.
> 
> Both this series and  the next parts are on my devel git tree,
> at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=convert_rst_renames_v4
> 
> The final output in html (after all patches I currently have, including 
> the upcoming series) can be seen at:
> 
> 	https://www.infradead.org/~mchehab/rst_conversion/

Will there be a web page (e.g. kernel.org), which contains always the
latest upstream version?

>   docs: Debugging390.txt: convert table to ascii artwork
>   docs: s390: convert docs to ReST and rename to *.rst
>   s390: include/asm/debug.h add kerneldoc markups

I can pick these up for s390. Or do you want to send the whole series
in one go upstream?

