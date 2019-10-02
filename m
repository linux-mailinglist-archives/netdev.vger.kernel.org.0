Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3BDC8C72
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfJBPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:10:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfJBPKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:10:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92F5Zwl130809;
        Wed, 2 Oct 2019 15:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=U251Xbrdds2ELQaYAcSlztvGxec730zcI/GOpzOyVCc=;
 b=o3hUOETiR3TfBaN51gYdtJSLEVfI2nar8y9priiWf+SEd2F798isdC+r6VIBaxNI7AJr
 d0Rfhyaac1NUF9VTixDSdusbHVGs52hGlYe3qv9rfCFBwOsy/iDwuJN2y1xA0X8hL8GB
 IjVElKnFDFGWHROuMBCd9uUhub2QomxKMAtG34HbmdD8c6+gJAS2+j3/9gFlBBJFEkUp
 m6LkkiYEglmKNyh04yI+82viR+ZLFdN4AGpVr78h4yP3z9C5rpAstrqAGlwSkV1TWjtE
 8cq1y9lJIl1n90zTlUQbIB5OiWBAp9eARejoxixCX9ntyiQ17ybXTLsLrlTabIjloqpI yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05rwhv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 15:10:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92F4UKx007883;
        Wed, 2 Oct 2019 15:10:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vc9dkpv4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 15:10:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x92FADt7015747;
        Wed, 2 Oct 2019 15:10:13 GMT
Received: from dhcp-10-175-191-98.vpn.oracle.com (/10.175.191.98)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 08:10:12 -0700
Date:   Wed, 2 Oct 2019 16:10:02 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-191-98.vpn.oracle.com
To:     =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
Message-ID: <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1358273857-529273610-1570029012=:24629"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1358273857-529273610-1570029012=:24629
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 Oct 2019, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

> This series adds support for executing multiple XDP programs on a single
> interface in sequence, through the use of chain calls, as discussed at th=
e Linux
> Plumbers Conference last month:
>=20
> https://linuxplumbersconf.org/event/4/contributions/460/
>=20
> # HIGH-LEVEL IDEA
>=20
> The basic idea is to express the chain call sequence through a special ma=
p type,
> which contains a mapping from a (program, return code) tuple to another p=
rogram
> to run in next in the sequence. Userspace can populate this map to expres=
s
> arbitrary call sequences, and update the sequence by updating or replacin=
g the
> map.
>=20
> The actual execution of the program sequence is done in bpf_prog_run_xdp(=
),
> which will lookup the chain sequence map, and if found, will loop through=
 calls
> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on=
 the
> previous program ID and return code.
>=20
> An XDP chain call map can be installed on an interface by means of a new =
netlink
> attribute containing an fd pointing to a chain call map. This can be supp=
lied
> along with the XDP prog fd, so that a chain map is always installed toget=
her
> with an XDP program.
>=20

This is great stuff Toke! One thing that wasn't immediately clear to me -
and this may be just me - is the relationship between program=20
behaviour for the XDP_DROP case and chain call execution.  My initial
thought was that a program in the chain XDP_DROP'ping the packet would
terminate the call chain, but on looking at patch #4 it seems that
the only way the call chain execution is terminated is if

- XDP_ABORTED is returned from a program in the call chain; or
- the map entry for the next program (determined by the return value
  of the current program) is empty; or
- we run out of entries in the map

The return value of the last-executed program in the chain seems
to be what determines packet processing behaviour after executing
the chain (_DROP, _TX, _PASS, etc).  So there's no way to both XDP_PASS=20
and XDP_TX a packet from the same chain, right? Just want to make
sure I've got the semantics correct. Thanks!

Alan
---1358273857-529273610-1570029012=:24629--
