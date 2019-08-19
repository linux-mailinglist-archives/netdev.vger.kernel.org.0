Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306E894C0F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfHSRw2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Aug 2019 13:52:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbfHSRwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:52:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JHmNPl062826
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:52:25 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ufwf1qhu2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:52:24 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.ibm.com>;
        Mon, 19 Aug 2019 18:52:21 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 19 Aug 2019 18:52:16 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7JHqFKa25427978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 17:52:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E4AE4C058;
        Mon, 19 Aug 2019 17:52:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02FA94C040;
        Mon, 19 Aug 2019 17:52:15 +0000 (GMT)
Received: from localhost (unknown [9.85.69.174])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Aug 2019 17:52:14 +0000 (GMT)
Date:   Mon, 19 Aug 2019 23:22:13 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH 13/16] include/asm-generic: prefer __section from
 compiler_attributes.h
To:     akpm@linux-foundation.org,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, jpoimboe@redhat.com,
        Martin KaFai Lau <kafai@fb.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        miguel.ojeda.sandonis@gmail.com, netdev@vger.kernel.org,
        sedat.dilek@gmail.com, Song Liu <songliubraving@fb.com>, yhs@fb.com
References: <20190812215052.71840-1-ndesaulniers@google.com>
        <20190812215052.71840-13-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-13-ndesaulniers@google.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19081917-0016-0000-0000-000002A06F66
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081917-0017-0000-0000-000033009ADE
Message-Id: <1566237106.8670clhnrk.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=764 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Desaulniers wrote:
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

- Naveen

