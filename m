Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB025BA99
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgICFqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:46:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3324 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbgICFqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:46:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0835VoCL128582;
        Thu, 3 Sep 2020 01:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=EEmfAEII1MFsjoFBO9r2yZjXFgAAI3FqsD9VQfebOoE=;
 b=CzIuSojQTIPntS0vdfCwj461k1Z/PaVo/M+kDUeNSxHUCviaCKeu6g8R+XYTCsP8vMig
 WSg37KR2gmDjG/pq+gQUDLflVAPXukKNbNqr7KBJTNH70+8dJzansvk2OefE6rbMv3BI
 eddut5OSAyqPikzSUyDXRa1dKu4AziD+of0g5aEWZRL09qztmgYVrXfSzGbX0w1VUQf0
 Wk6fzTDVwZYaAG3MY1WncJqyID7mb17fEvBUne8hJviu1HwxaPGWwsrdos5qEayojGpd
 Ul8BtJHIt5oYdtbziI/C+ukhleB3mxXSclPiX28xW0Xnx7tcURrlwdb5fiFpPvW01KIJ Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33asvus4x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 01:46:19 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0835k1Ss163547;
        Thu, 3 Sep 2020 01:46:19 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33asvus4wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 01:46:19 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0835YHQ8008398;
        Thu, 3 Sep 2020 05:46:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 337en83b2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 05:46:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0835kF7M32506258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 05:46:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06DD8A4055;
        Thu,  3 Sep 2020 05:46:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 960C1A4053;
        Thu,  3 Sep 2020 05:46:14 +0000 (GMT)
Received: from localhost (unknown [9.102.26.23])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 05:46:14 +0000 (GMT)
Date:   Thu, 03 Sep 2020 11:16:12 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] libbpf: Remove arch-specific include path in Makefile
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
References: <20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com>
        <CAEf4BzZXyJsJ6rFp7pj_0PhyE_df9Z08wE9pUkZBp8i1qz_h1Q@mail.gmail.com>
        <fc8b0c65-b74a-d924-4189-ff6359d1ebdc@iogearbox.net>
In-Reply-To: <fc8b0c65-b74a-d924-4189-ff6359d1ebdc@iogearbox.net>
MIME-Version: 1.0
User-Agent: astroid/v0.15-13-gb675b421
 (https://github.com/astroidmail/astroid)
Message-Id: <1599111859.vtxbe8ojub.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=979 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 9/2/20 10:58 PM, Andrii Nakryiko wrote:
>> On Wed, Sep 2, 2020 at 1:43 AM Naveen N. Rao
>> <naveen.n.rao@linux.vnet.ibm.com> wrote:
>>>
>>> Ubuntu mainline builds for ppc64le are failing with the below error (*)=
:
>>>      CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
>>>      DESCEND  bpf/resolve_btfids
>>>
>>>    Auto-detecting system features:
>>>    ...                        libelf: [ [32mon[m  ]
>>>    ...                          zlib: [ [32mon[m  ]
>>>    ...                           bpf: [ [31mOFF[m ]
>>>
>>>    BPF API too old
>>>    make[6]: *** [Makefile:295: bpfdep] Error 1
>>>    make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build=
-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
>>>    make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
>>>    make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolv=
e_btfids] Error 2
>>>    make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_on=
e] Error 2
>>>    make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/buil=
d-generic'
>>>    make[1]: *** [Makefile:185: __sub-make] Error 2
>>>    make[1]: Leaving directory '/home/kernel/COD/linux'
>>>
>>> resolve_btfids needs to be build as a host binary and it needs libbpf.
>>> However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
>>> This results in mixing of cross-architecture headers resulting in a
>>> build failure.
>>>
>>> The specific header include path doesn't seem necessary for a libbpf
>>> build. Hence, remove the same.
>>>
>>> (*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log
>>>
>>> Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
>>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>> ---
>>=20
>> This seems to still build fine for me, so I seems fine. Not sure why
>> that $(ARCH)/include/uapi path is there.
>>=20
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
> Same here, builds fine from my side too. Looks like this was from the ver=
y early days,
> added in commit 1b76c13e4b36 ("bpf tools: Introduce 'bpf' library and add=
 bpf feature
> check"). Applied, thanks!

Thanks!

Daniel, I see that this has been applied to bpf-next. Can you please=20
consider sending this in for v5.9-rc series so as to resolve the build=20
failures?


- Naveen

