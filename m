Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902EC3B8B9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404024AbfFJPzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:55:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391356AbfFJPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:55:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5AFlbSK145202
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 11:55:42 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t1rnrd3a7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 11:55:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Mon, 10 Jun 2019 16:55:39 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Jun 2019 16:55:34 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5AFtXs559965666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 15:55:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE8A1AE051;
        Mon, 10 Jun 2019 15:55:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34469AE055;
        Mon, 10 Jun 2019 15:55:33 +0000 (GMT)
Received: from osiris (unknown [9.145.162.214])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 10 Jun 2019 15:55:33 +0000 (GMT)
Date:   Mon, 10 Jun 2019 17:55:31 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
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
 <20190609091642.GA3705@osiris>
 <20190609092940.5e34e3b0@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609092940.5e34e3b0@recife.lan>
X-TM-AS-GCONF: 00
x-cbid: 19061015-0008-0000-0000-000002F1FB8D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061015-0009-0000-0000-0000225EF2D2
Message-Id: <20190610155531.GC4031@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 09, 2019 at 09:29:40AM -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 9 Jun 2019 11:16:43 +0200
> > Will there be a web page (e.g. kernel.org), which contains always the
> > latest upstream version?
> 
> Yes:
> 
> 	https://www.kernel.org/doc/html/latest/
> 
> I guess this one is based on Linus tree.
> 
> Jon also maintains a version at:
> 
> 	https://static.lwn.net/kerneldoc/
> 
> I guess that one is based on docs-next branch from the Docs tree.
> 
> Btw, if you want to build it for yourself, you could use:
> 
> 	make htmldocs

Thanks a lot!

> > I can pick these up for s390. Or do you want to send the whole series
> > in one go upstream?
> 
> Yeah, feel free to pick them via the s390 tree.

Ok, applied! :)

