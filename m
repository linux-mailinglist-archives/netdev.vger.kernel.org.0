Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A572B0CD2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKLSjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:39:45 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgKLSjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:39:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACIXxQs063414;
        Thu, 12 Nov 2020 18:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=9JLSz7F4U072mTMc6WX+QwBtdSQiyj3GqHJlm84YjTU=;
 b=MJviSqG3mZC3Y6hnGuNh+Pt6nl2P6zf3BLfZeNVGflbPidFJmlTUGvEWA9nP7zd9noWW
 JI2COY2mYzZuB/fhGg1BZq2yem2DiPcKqDbpvj5X88CKUHScRhMi/OwBpY6M6/DSosZE
 XlrZtE033nNzFMw1SsjMDA4gstzVOsU05KqyHKUVHFt+wBI35KXt8CLvZg7KvvKERLvT
 6uQ/wDk9PZVokL9v7wtIJB8WPVOvgBUAaPFaKGWguAHyNIrN7Q3CAieLeLaybBDx5AI0
 4961tS2Fk3ONtDzCHC8QoCnwWHdnFCwRrFN7vppoLrw8kFXfG9I50wL8FEfZ0wOFYM0h LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b7799-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 18:39:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACIZERl074559;
        Thu, 12 Nov 2020 18:39:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt56gu8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 18:39:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACIdSOM027841;
        Thu, 12 Nov 2020 18:39:28 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 10:39:28 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20201112183717.GH9243@fieldses.org>
Date:   Thu, 12 Nov 2020 13:39:26 -0500
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <824E8418-4903-46D6-A20C-8890C399C2D8@oracle.com>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <20201112183717.GH9243@fieldses.org>
To:     Bruce Fields <bfields@fieldses.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 1:37 PM, J. Bruce Fields <bfields@fieldses.org> =
wrote:
>=20
> On Thu, Nov 12, 2020 at 12:57:45PM +0000, David Howells wrote:
>>=20
>> Hi Herbert, Bruce,
>>=20
>> Here's my first cut at a generic Kerberos crypto library in the =
kernel so
>> that I can share code between rxrpc and sunrpc (and cifs?).
>>=20
>> I derived some of the parts from the sunrpc gss library and added =
more
>> advanced AES and Camellia crypto.  I haven't ported across the =
DES-based
>> crypto yet - I figure that can wait a bit till the interface is =
sorted.
>>=20
>> Whilst I have put it into a directory under crypto/, I haven't made =
an
>> interface that goes and loads it (analogous to crypto_alloc_skcipher,
>> say).  Instead, you call:
>>=20
>>        const struct krb5_enctype *crypto_krb5_find_enctype(u32 =
enctype);
>>=20
>> to go and get a handler table and then use a bunch of accessor =
functions to
>> jump through the hoops.  This is basically the way the sunrpc gsslib =
does
>> things.  It might be worth making it so you do something like:
>>=20
>> 	struct crypto_mech *ctx =3D crypto_mech_alloc("krb5(18)");
>>=20
>> to get enctype 18, but I'm not sure if it's worth the effort.  Also, =
I'm
>> not sure if there are any alternatives to kerberos we will need to =
support.
>=20
> We did have code for a non-krb5 mechanism at some point, but it was =
torn
> out.  So I don't think that's a priority.
>=20
> (Chuck, will RPC-over-SSL need a new non-krb5 mechanism?)

No, RPC-over-TLS does not involve the GSS infrastructure in any way.


>> There are three main interfaces to it:
>>=20
>> (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.
>>=20
>>     These all do in-place crypto, using an sglist to define the =
buffer
>>     with the data in it.  Is it necessary to make it able to take =
separate
>>     input and output buffers?
>=20
> I don't know.  My memory is that the buffer management in the existing
> rpcsec_gss code is complex and fragile.  See e.g. the long comment in
> gss_krb5_remove_padding.

And even worse, the buffer handling is slightly different in the NFS
client and server code paths.


> --b.
>=20
>> (*) PRF+ calculation for key derivation.
>> (*) Kc, Ke, Ki derivation.
>>=20
>>     These use krb5_buffer structs to pass objects around.  This is =
akin to
>>     the xdr_netobj, but has a void* instead of a u8* data pointer.
>>=20
>> In terms of rxrpc's rxgk, there's another step in key derivation that =
isn't
>> part of the kerberos standard, but uses the PRF+ function to generate =
a key
>> that is then used to generate Kc, Ke and Ki.  Is it worth putting =
this into
>> the directory or maybe having a callout to insert an intermediate =
step in
>> key derivation?
>>=20
>> Note that, for purposes of illustration, I've included some rxrpc =
patches
>> that use this interface to implement the rxgk Rx security class.  The
>> branch also is based on some rxrpc patches that are a prerequisite =
for
>> this, but the crypto patches don't need it.
>>=20
>> ---
>> The patches can be found here also:
>>=20
>> 	=
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=3D=
crypto-krb5
>>=20
>> David
>> ---
>> David Howells (18):
>>      crypto/krb5: Implement Kerberos crypto core
>>      crypto/krb5: Add some constants out of sunrpc headers
>>      crypto/krb5: Provide infrastructure and key derivation
>>      crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
>>      crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt =
functions
>>      crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and =
verify_mic
>>      crypto/krb5: Implement the AES enctypes from rfc3962
>>      crypto/krb5: Implement crypto self-testing
>>      crypto/krb5: Implement the AES enctypes from rfc8009
>>      crypto/krb5: Implement the AES encrypt/decrypt from rfc8009
>>      crypto/krb5: Add the AES self-testing data from rfc8009
>>      crypto/krb5: Implement the Camellia enctypes from rfc6803
>>      rxrpc: Add the security index for yfs-rxgk
>>      rxrpc: Add YFS RxGK (GSSAPI) security class
>>      rxrpc: rxgk: Provide infrastructure and key derivation
>>      rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)
>>      rxrpc: rxgk: Implement connection rekeying
>>      rxgk: Support OpenAFS's rxgk implementation
>>=20
>>=20
>> crypto/krb5/Kconfig              |    9 +
>> crypto/krb5/Makefile             |   11 +-
>> crypto/krb5/internal.h           |  101 +++
>> crypto/krb5/kdf.c                |  223 ++++++
>> crypto/krb5/main.c               |  190 +++++
>> crypto/krb5/rfc3961_simplified.c |  732 ++++++++++++++++++
>> crypto/krb5/rfc3962_aes.c        |  140 ++++
>> crypto/krb5/rfc6803_camellia.c   |  249 ++++++
>> crypto/krb5/rfc8009_aes2.c       |  440 +++++++++++
>> crypto/krb5/selftest.c           |  543 +++++++++++++
>> crypto/krb5/selftest_data.c      |  289 +++++++
>> fs/afs/misc.c                    |   13 +
>> include/crypto/krb5.h            |  100 +++
>> include/keys/rxrpc-type.h        |   17 +
>> include/trace/events/rxrpc.h     |    4 +
>> include/uapi/linux/rxrpc.h       |   17 +
>> net/rxrpc/Kconfig                |   10 +
>> net/rxrpc/Makefile               |    5 +
>> net/rxrpc/ar-internal.h          |   20 +
>> net/rxrpc/conn_object.c          |    2 +
>> net/rxrpc/key.c                  |  319 ++++++++
>> net/rxrpc/rxgk.c                 | 1232 =
++++++++++++++++++++++++++++++
>> net/rxrpc/rxgk_app.c             |  424 ++++++++++
>> net/rxrpc/rxgk_common.h          |  164 ++++
>> net/rxrpc/rxgk_kdf.c             |  271 +++++++
>> net/rxrpc/security.c             |    6 +
>> 26 files changed, 5530 insertions(+), 1 deletion(-)
>> create mode 100644 crypto/krb5/kdf.c
>> create mode 100644 crypto/krb5/rfc3961_simplified.c
>> create mode 100644 crypto/krb5/rfc3962_aes.c
>> create mode 100644 crypto/krb5/rfc6803_camellia.c
>> create mode 100644 crypto/krb5/rfc8009_aes2.c
>> create mode 100644 crypto/krb5/selftest.c
>> create mode 100644 crypto/krb5/selftest_data.c
>> create mode 100644 net/rxrpc/rxgk.c
>> create mode 100644 net/rxrpc/rxgk_app.c
>> create mode 100644 net/rxrpc/rxgk_common.h
>> create mode 100644 net/rxrpc/rxgk_kdf.c

--
Chuck Lever



