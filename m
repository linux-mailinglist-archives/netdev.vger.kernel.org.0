Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C442214BD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGOSyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:54:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGOSyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:54:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIpufU015158;
        Wed, 15 Jul 2020 18:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8nMMglpPtmSbuRefk5IkxI40fcsel9sw4WlVCU3Fnfg=;
 b=Suf3P2jxUi0QTi7RwFtfQiTN1r7HSXl1/QC/gCvYi2GQ2SS7Qx96u+jeCEUwcCRMVXfp
 q7bqx/X5wqqsobRSUILsRmGJ2zi5UTETwwPVmeYgiopiqpM0iKtElDc7VkhT7YdDPfMd
 kX/PAQV+gZfjCKxfhZ3oyniQtlr0xur5+O79NIjkpst7tbWptrYp0vbvfuyqI1cdg2ks
 j8grbl8y8SXAGuLyTYMBMnngMvoiCM/EKehs0ECypGz7DPBG5js7SCLbSwVFAxHSXfTY
 41DVqVyDqLe2v5NOJJFQPpg6QQlDOHytfNiPuacg5awNJbveQdkWG4FTArAuOkYICXAM SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 327s65kfhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 18:54:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FImgC2056404;
        Wed, 15 Jul 2020 18:54:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qc1gxmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 18:54:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FIsWWg026388;
        Wed, 15 Jul 2020 18:54:32 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 11:54:32 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <7042081C-27B3-4024-BA34-7146B459F8B4@oracle.com>
Date:   Wed, 15 Jul 2020 14:54:30 -0400
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3884DFB0-D276-442D-8199-8FC77A40F1E5@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
 <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
 <7042081C-27B3-4024-BA34-7146B459F8B4@oracle.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 11:14 AM, Chuck Lever <chuck.lever@oracle.com> =
wrote:
>=20
>=20
>=20
>> On Jul 15, 2020, at 11:08 AM, Kai-Heng Feng =
<kai.heng.feng@canonical.com> wrote:
>>=20
>>> On Jul 15, 2020, at 23:02, Chuck Lever <chuck.lever@oracle.com> =
wrote:
>>>=20
>>>> On Jul 15, 2020, at 10:48 AM, Kai-Heng Feng =
<kai.heng.feng@canonical.com> wrote:
>>>>=20
>>>> Hi,
>>>>=20
>>>> Multiple users reported NFS causes NULL pointer dereference [1] on =
Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and =
commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".
>>>>=20
>>>> The same issue happens on upstream stable 5.4.y branch.
>>>> The mainline kernel doesn't have this issue though.
>>>>=20
>>>> Should we revert them? Or is there any missing commits need to be =
backported to v5.4?
>>>>=20
>>>> [1] https://bugs.launchpad.net/bugs/1886277
>>>>=20
>>>> Kai-Heng
>>>=20
>>> 31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()") is a =
refactoring
>>> change. It shouldn't have introduced any behavior difference. But in =
theory,
>>> practice and theory should be the same...
>>>=20
>>> Check if 0a8e7b7d0846 ("SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove =
xdr_buf_trim()")")
>>> is also applied to 5.4.0-40-generic.
>>=20
>> Yes, it's included. The commit is part of upstream stable 5.4.
>>=20
>>>=20
>>> It would help to know if v5.5 stable is working for you. I haven't =
had any
>>> problems with it.
>>=20
>> I'll ask users to test it out.=20
>> Thanks for you quick reply!
>=20
> Another thought: Please ask what encryption type is in use. The
> kerberos_v1 enctypes might exercise a code path I wasn't able to
> test.

OK.

v5.4.40 does not have 31c9590ae468 and friends, but the claim is this
one crashes?

And v5.4.51 has those three and 89a3c9f5b9f0, which Pierre claims fixes
the problem for him; but another commenter says v5.4.51 still crashes.

So we're getting inconsistent problem reports.

Have the testers enable memory debugging : KASAN or SLUB debugging
might provide more information. I might have some time later this week
to try reproducing on upstream stable, but no guarantees.


--
Chuck Lever



