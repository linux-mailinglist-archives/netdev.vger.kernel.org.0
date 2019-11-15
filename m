Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA56EFDF97
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfKOODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:03:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfKOODf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 09:03:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFDnBER013529;
        Fri, 15 Nov 2019 14:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=bnPX2OgeK3ijYnTq5eg/WnUbrlpyXkw4Zi8V/8h7jco=;
 b=nY8ASD/ZdpTDoGPIDQKOc7IzYn37aPd3yzAv/CFc3AUJucnwiw9DellRCXeg3WuA+fE8
 Bkq+b+lbCBwt8cocHIx/OgCzov6F8kt3XN7wBe1MqWYKb9c94sCDvadrAdgIz0FgsAMo
 ZDQgszXJaBsNLv6jXM+mgJaakmhpj14bMqhM5uD/9bi2MPC/Bh2XpT8gNRXL2HitQ/M6
 iLR6DeFvuAzFzRL08q3BCcTEx1vKCE3clsyZoSr0xJsFRSyaxHMF1oVmqKzLDCekdvoC
 Lg8cURGqV6wYgLrn62w+rDtOKjpIQuPDIn/sjdpl2RVH50AojzDyt7nRf0v2HEAQ1yHx BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w9gxpkdsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 14:03:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFDnBm4193052;
        Fri, 15 Nov 2019 14:03:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w9h182hnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 14:03:30 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAFE3S9d022052;
        Fri, 15 Nov 2019 14:03:28 GMT
Received: from dhcp-10-175-203-21.vpn.oracle.com (/10.175.203.21)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 06:03:28 -0800
Date:   Fri, 15 Nov 2019 14:03:23 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-203-21.vpn.oracle.com
To:     =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
cc:     Jiri Benc <jbenc@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf] selftests: bpf: xdping is not meant to be run
 standalone
In-Reply-To: <87a78xmgmu.fsf@toke.dk>
Message-ID: <alpine.LRH.2.20.1911151402580.15722@dhcp-10-175-203-21.vpn.oracle.com>
References: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com> <87a78xmgmu.fsf@toke.dk>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1358293557-283249934-1573826608=:15722"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=627
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=690 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1358293557-283249934-1573826608=:15722
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 15 Nov 2019, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

> Jiri Benc <jbenc@redhat.com> writes:
>=20
> > The actual test to run is test_xdping.sh, which is already in TEST_PROG=
S.
> > The xdping program alone is not runnable with 'make run_tests', it
> > immediatelly fails due to missing arguments.
> >
> > Move xdping to TEST_GEN_PROGS_EXTENDED in order to be built but not run=
=2E
> >
> > Fixes: cd5385029f1d ("selftests/bpf: measure RTT from xdp using xdping"=
)
> > Cc: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: Jiri Benc <jbenc@redhat.com>
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
>=20

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
---1358293557-283249934-1573826608=:15722--
