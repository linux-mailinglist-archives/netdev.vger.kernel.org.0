Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277973A480
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfFIJ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 05:27:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbfFIJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 05:27:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x599QoIE026125
        for <netdev@vger.kernel.org>; Sun, 9 Jun 2019 05:27:49 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t0t06g0qs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 05:27:49 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Sun, 9 Jun 2019 10:27:46 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Jun 2019 10:27:41 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x599ReFd35979690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jun 2019 09:27:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7404011C04A;
        Sun,  9 Jun 2019 09:27:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4A7B11C050;
        Sun,  9 Jun 2019 09:27:39 +0000 (GMT)
Received: from osiris (unknown [9.145.173.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun,  9 Jun 2019 09:27:39 +0000 (GMT)
Date:   Sun, 9 Jun 2019 11:27:38 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Markus Heiser <markus.heiser@darmarit.de>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
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
 <20190609091642.GA3705@osiris>
 <56cd597a-9db8-b6ea-eed1-51d3bdf0e6e0@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56cd597a-9db8-b6ea-eed1-51d3bdf0e6e0@darmarit.de>
X-TM-AS-GCONF: 00
x-cbid: 19060909-0008-0000-0000-000002F1A5FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060909-0009-0000-0000-0000225E99D8
Message-Id: <20190609092738.GB3705@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=982 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906090070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 09, 2019 at 11:22:36AM +0200, Markus Heiser wrote:
> 
> Am 09.06.19 um 11:16 schrieb Heiko Carstens:
> >Will there be a web page (e.g. kernel.org), which contains always the
> >latest upstream version?
> 
> You are looking for the HTML docs on kernel.org?
> 
>   https://www.kernel.org/doc/html/latest/

Yes, thanks!

