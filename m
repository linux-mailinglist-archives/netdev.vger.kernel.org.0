Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FB4221024
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGOPEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:04:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:04:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FF28PN058008;
        Wed, 15 Jul 2020 15:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=DD4W8IxdwHhBImQ38dCQSbHYl/4/M9t0RzXrlshPkRQ=;
 b=W1LSiDUwvjnhHON4NQzG7EJBBZa6POUpYK5CN+CGasjjUfDPq7KMcalyy5ictAUVGjXN
 fAUK1tVq72sBW/yoY03rafkzS8/UV7Cg7yZfGZfiwzHgsJYUNJpVaRrueyLTPk4KGUzL
 Tg2Y3AJpW5gPIJ/qcFH9pWtVOtaJJltwBG9dNuy/1MJ00oDuUvQs3kjlS/2gDifKYTz9
 kzrKmp3qXXbjokBUtBbVxg+62ZuTcyyPeY++i8eDDz5XJKXLbDsUuTl1Gnx9iSBsdGm4
 JhTvT5KbKKxHrRvxZtWa9d+w4YUMv4f2X2jPpu3iuICuPVACQgDXwDsuHGDbZUOcdaYh pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274urc06g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 15:04:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FEveIf103834;
        Wed, 15 Jul 2020 15:02:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 327q6unc30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 15:02:03 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FF22QX005651;
        Wed, 15 Jul 2020 15:02:02 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 08:02:02 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
Date:   Wed, 15 Jul 2020 11:02:00 -0400
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 10:48 AM, Kai-Heng Feng =
<kai.heng.feng@canonical.com> wrote:
>=20
> Hi,
>=20
> Multiple users reported NFS causes NULL pointer dereference [1] on =
Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and =
commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".
>=20
> The same issue happens on upstream stable 5.4.y branch.
> The mainline kernel doesn't have this issue though.
>=20
> Should we revert them? Or is there any missing commits need to be =
backported to v5.4?
>=20
> [1] https://bugs.launchpad.net/bugs/1886277
>=20
> Kai-Heng

31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()") is a =
refactoring
change. It shouldn't have introduced any behavior difference. But in =
theory,
practice and theory should be the same...

Check if 0a8e7b7d0846 ("SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove =
xdr_buf_trim()")")
is also applied to 5.4.0-40-generic.

It would help to know if v5.5 stable is working for you. I haven't had =
any
problems with it.


--
Chuck Lever



