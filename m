Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3132B08D9
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgKLPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:49:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49316 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgKLPtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:49:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACFTOcY091503;
        Thu, 12 Nov 2020 15:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=bD1V5q95i6+ADV+YeAFQt2s8ENYs/W7Au47fsVzm170=;
 b=I+c7hO+bjcs00L2rQ4D9vhfLswmZuCqk8qj2Zy513vtnws9SiGwmfaAz+zOmv0gRqTSo
 Yl2cnvrFzhNjuZychmZGau0YrII9Ro+yhj+BD2XvIQ+khyK+s8kZ+LbbXgL8halL1px4
 Uozki8PMlSG60yqLJDKEeExb45H4jKL8F8e8CVFlIpylUYUQhAAO2n3uUgyiR65IY0Bw
 TpBPXFKJYSvkWq96Y3iegUx8Y9eBA+2p/DtC+CcSWXdUxvEDxhPS00SUB980D+1QtW21
 X6pMiCC78K0BL7hJ9vVX1vWNaN38N0iuyxkfBrnUeVA8evI2IPwpe0JcterNmlbbCs5p uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72ev7f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 15:49:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACFVCnl133264;
        Thu, 12 Nov 2020 15:49:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt5686x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 15:49:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACFn5ll005827;
        Thu, 12 Nov 2020 15:49:05 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 07:49:05 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <2380561.1605195776@warthog.procyon.org.uk>
Date:   Thu, 12 Nov 2020 10:49:03 -0500
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Bruce Fields <bfields@fieldses.org>,
        linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22138FE2-9E79-4E24-99FC-74A35651B0C1@oracle.com>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <2380561.1605195776@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 10:42 AM, David Howells <dhowells@redhat.com> =
wrote:
>=20
> Chuck Lever <chuck.lever@oracle.com> wrote:
>=20
>>> There are three main interfaces to it:
>>>=20
>>> (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.
>>>=20
>>>    These all do in-place crypto, using an sglist to define the =
buffer
>>>    with the data in it.  Is it necessary to make it able to take =
separate
>>>    input and output buffers?
>>=20
>> Hi David, Wondering if these "I/O" APIs use synchronous or async
>> crypto under the covers. For small data items like MICs, synchronous
>> might be a better choice, especially if asynchronous crypto could
>> result in incoming requests getting re-ordered and falling out of
>> the GSS sequence number window.
>>=20
>> What say ye?
>=20
> For the moment I'm using synchronous APIs as that's what sunrpc is =
using (I
> borrowed the basic code from there).

Really? My understanding of the Linux kernel SUNRPC implementation is
that it uses asynchronous, even for small data items. Maybe I'm using
the terminology incorrectly.

The problem that arises is on the server. The asynchronous API can
schedule, and if the server has other work to do, that can delay a
verify_mic long enough that the request drops out of the GSS sequence
number window (even a large window).

Whatever the mechanism, we need to have deterministic ordering, at
least on the server-side.


> It would be interesting to consider using async, but there's a =
potential
> issue.  For the simplified profile, encryption and integrity checksum
> generation can be done simultaneously, but decryption and verification =
can't.
> For the AES-2 profile, the reverse is true.
>=20
> For my purposes in rxrpc, async mode isn't actually that useful since =
I'm only
> doing the contents of a UDP packet at a time.  Either I'm encrypting =
with the
> intention of immediate transmission or decrypting with the intention =
of
> immediately using the data, so I'm in a context where I can wait =
anyway.
>=20
> What might get me more of a boost would be to encrypt the app data =
directly
> into a UDP packet and decrypt the UDP packet directly into the app =
buffers.
> This is easier said than done, though, as there's typically security =
metadata
> inserted into the packet inside the encrypted region.


--
Chuck Lever



