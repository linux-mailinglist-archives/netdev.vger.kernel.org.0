Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB39221176
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgGOPp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:45:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50996 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGOPp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:45:27 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2020 11:45:26 EDT
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FF1rhZ064552;
        Wed, 15 Jul 2020 15:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dE2+XAhVZ3ELSojoIO+9JYurWJh0dM6wVluR2D7xeL4=;
 b=O0ngZE5YBhuV8ifHX7+fJJrWxHZHX60tohL8NZE8Gw9kTS/8ztKLV2AUKFf3rTftVeXm
 nLeiZGtY4hjs4vrEzrryGEmHgNNyn6gi4i4mHh73tT+1slLnkWIyd4HpQoej3VRQ4aQC
 BFHSQo+QWGCYApQoer0un93OBxcFjIDsIOevbJWiqw2qFBMu9oZGuD9sVFR01KEjLiMj
 YwnpX92Qo6999waUfjgcRRRg3HuPEVkISagfmc1y5OrJUgZ4rTk73RqFjgVzZLPYx5aa
 Sc2UwL3DDk+4ed5NsuwM1494Ucy8NzLzeG6whjj1TqZYI1Sf1Pr0IJV0pfBWK9ZfsOPA 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 327s65j9y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 15:16:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FF3fw8011650;
        Wed, 15 Jul 2020 15:14:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0rdww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 15:14:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FFErBA030894;
        Wed, 15 Jul 2020 15:14:53 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 08:14:53 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
Date:   Wed, 15 Jul 2020 11:14:52 -0400
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7042081C-27B3-4024-BA34-7146B459F8B4@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
 <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 11:08 AM, Kai-Heng Feng =
<kai.heng.feng@canonical.com> wrote:
>=20
>> On Jul 15, 2020, at 23:02, Chuck Lever <chuck.lever@oracle.com> =
wrote:
>>=20
>>> On Jul 15, 2020, at 10:48 AM, Kai-Heng Feng =
<kai.heng.feng@canonical.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>> Multiple users reported NFS causes NULL pointer dereference [1] on =
Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and =
commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".
>>>=20
>>> The same issue happens on upstream stable 5.4.y branch.
>>> The mainline kernel doesn't have this issue though.
>>>=20
>>> Should we revert them? Or is there any missing commits need to be =
backported to v5.4?
>>>=20
>>> [1] https://bugs.launchpad.net/bugs/1886277
>>>=20
>>> Kai-Heng
>>=20
>> 31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()") is a =
refactoring
>> change. It shouldn't have introduced any behavior difference. But in =
theory,
>> practice and theory should be the same...
>>=20
>> Check if 0a8e7b7d0846 ("SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove =
xdr_buf_trim()")")
>> is also applied to 5.4.0-40-generic.
>=20
> Yes, it's included. The commit is part of upstream stable 5.4.
>=20
>>=20
>> It would help to know if v5.5 stable is working for you. I haven't =
had any
>> problems with it.
>=20
> I'll ask users to test it out.=20
> Thanks for you quick reply!

Another thought: Please ask what encryption type is in use. The
kerberos_v1 enctypes might exercise a code path I wasn't able to
test.


--
Chuck Lever



