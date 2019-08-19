Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944E794BAF
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfHSR1h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Aug 2019 13:27:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727968AbfHSR1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:27:37 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JHM60s102969
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:27:36 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ufyb020ny-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:27:36 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Mon, 19 Aug 2019 18:27:34 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 19 Aug 2019 18:27:30 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7JHRUo643385094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 17:27:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B755204E;
        Mon, 19 Aug 2019 17:27:29 +0000 (GMT)
Received: from localhost (unknown [9.85.69.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 28BDE5204F;
        Mon, 19 Aug 2019 17:27:28 +0000 (GMT)
Date:   Mon, 19 Aug 2019 22:57:27 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and bpf_endian.h
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii.nakryiko@gmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>, kernel-team@fb.com,
        Michal Rostecki <mrostecki@opensuse.org>,
        Sargun Dhillon <sargun@sargun.me>
References: <20190816054543.2215626-1-andriin@fb.com>
In-Reply-To: <20190816054543.2215626-1-andriin@fb.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19081917-0012-0000-0000-000003406E70
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081917-0013-0000-0000-0000217A8F85
Message-Id: <1566235603.gbpzn6lgaa.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=584 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
> definitions essential to almost every BPF program. Which makes them
> useful not just for selftests. To be able to expose them as part of
> libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
> BSD-2-Clause. This patch updates licensing of those two files.

Quite late, but FWIW:
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>


- Naveen

