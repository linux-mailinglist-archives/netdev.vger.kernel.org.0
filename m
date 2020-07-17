Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446AD2241E8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgGQRgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:36:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGQRgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:36:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HHX61B196185;
        Fri, 17 Jul 2020 17:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=cifHzIcoftN1NjY2VgZBGvbry+3hcUjikyTTIwz6b+I=;
 b=Kw8MW12jaxZbEDIWxd1/ANXZGBk+CWJAjC1z+/QFX3IYh6cp9g2U3XoEvBJHyubv54uc
 2Kjb+NmX50QkogKhdU6A1oELLrGyMyrCJDvavhHKZoSo8CBO/VXCYW220vEozbQgwTOQ
 VqI/WbZYr+Q5NxlBMeIXQR2TH/J8DhaMfxYjsLEzZVNX7Dw14r0BMbG2vYjGCWwPFZEr
 U5hR97QoquZvDMNXeH0eTp3L4CQcFd3MCbKHp8plqci2giGJ3gvWFexjVn/vS/Xhu1pz
 HLHR5Zu9+n3yupwfe5Ezy90SwuKo6khEg4DBJbMFqjcCWCvMVrYZW69TQ7rHqLztj9ux 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cmrhqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 17:34:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HHXvjk071078;
        Fri, 17 Jul 2020 17:34:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32bbk0shbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 17:34:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06HHYDY6002560;
        Fri, 17 Jul 2020 17:34:13 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 10:34:12 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <4546230.GXAFRqVoOG@keks.as.studentenwerk.mhn.de>
Date:   Fri, 17 Jul 2020 13:34:11 -0400
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-owner@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <650B6279-9550-4844-9375-280F11C3DC4B@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <5619613.lOV4Wx5bFT@keks.as.studentenwerk.mhn.de>
 <0885F62B-F9D2-4248-9313-70DAA1A1DE71@oracle.com>
 <4546230.GXAFRqVoOG@keks.as.studentenwerk.mhn.de>
To:     Pierre Sauter <pierre.sauter@stwm.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 17, 2020, at 1:29 PM, Pierre Sauter <pierre.sauter@stwm.de> =
wrote:
>=20
> Hi Chuck,
>=20
> Am Donnerstag, 16. Juli 2020, 21:25:40 CEST schrieb Chuck Lever:
>> So this makes me think there's a possibility you are not using =
upstream
>> stable kernels. I can't help if I don't know what source code and =
commit
>> stream you are using. It also makes me question the bisect result.
>=20
> Yes you are right, I was referring to Ubuntu kernels 5.4.0-XX. =46rom =
the
> discussion in the Ubuntu bugtracker I got the impression that Ubuntu =
kernels
> 5.4.0-XX and upstream 5.4.XX are closely related, obviously they are =
not. The
> bisection was done by the original bug reporter and also refers to the =
Ubuntu
> kernel.
>=20
> In the meantime I tested v5.4.51 upstream, which shows no problems. =
Sorry for
> the bother.

Pierre, thanks for confirming!

Kai-Heng suspected an upstream stable commit that is missing in =
5.4.0-40,
but I don't have any good suggestions.


>>> My krb5 etype is aes256-cts-hmac-sha1-96.
>>=20
>> Thanks! And what is your NFS server and filesystem? It's possible =
that the
>> client is not estimating the size of the reply correctly. Variables =
include
>> the size of file handles, MIC verifiers, and wrap tokens.
>=20
> The server is Debian with v4.19.130 upstream, filesystem ext4.
>=20
>> You might try:
>>=20
>> e8d70b321ecc ("SUNRPC: Fix another issue with MIC buffer space")
>=20
> That one is actually in Ubuntus 5.4.0-40, from looking at the code.

--
Chuck Lever



