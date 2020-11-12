Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E7F2B079E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgKLOg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:36:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgKLOg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:36:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACEXr3T139990;
        Thu, 12 Nov 2020 14:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=QwWCHuJd7yIyTduNt/pf/bouD4hpEBJNBee87sGYN9U=;
 b=t8G0ysWwFSWadi/fDZV3k+NDg5M6eyi5lPgC5miyeXlwFWwjaE4GnwOKBl7MSyqfaT47
 lCBG5AjMkn7PL3O4bHD+wTvDAKvScAdi5uq7rwtmSMOHQ+LVV4dkHKVe+yF5FCVq31vA
 CsDJ/VE5mDzP0iFKWA2DZF7US6HdQcDatLpMIhvaPFnLLBt1zgxZvXv6u4eZ+IVUAjSP
 wzk7bphRs5g/ocznuWGA2ban649TeLSoZy0pijtsYtVgBUX8Y4LhymWtJN4m537t2V9+
 Wr19mQC042pYQjVe/Yob/h6mmhCjIW3YeGpVG+zLJtxd5S3qmKhCDDFmqhw63CNqjTsx pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhm5jnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 14:36:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACEZM72183114;
        Thu, 12 Nov 2020 14:36:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55rbpuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 14:36:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACEaY9C013837;
        Thu, 12 Nov 2020 14:36:34 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 06:36:34 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
Date:   Thu, 12 Nov 2020 09:36:32 -0500
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 7:57 AM, David Howells <dhowells@redhat.com> =
wrote:
>=20
>=20
> Hi Herbert, Bruce,
>=20
> Here's my first cut at a generic Kerberos crypto library in the kernel =
so
> that I can share code between rxrpc and sunrpc (and cifs?).
>=20
> I derived some of the parts from the sunrpc gss library and added more
> advanced AES and Camellia crypto.  I haven't ported across the =
DES-based
> crypto yet - I figure that can wait a bit till the interface is =
sorted.
>=20
> Whilst I have put it into a directory under crypto/, I haven't made an
> interface that goes and loads it (analogous to crypto_alloc_skcipher,
> say).  Instead, you call:
>=20
>        const struct krb5_enctype *crypto_krb5_find_enctype(u32 =
enctype);
>=20
> to go and get a handler table and then use a bunch of accessor =
functions to
> jump through the hoops.  This is basically the way the sunrpc gsslib =
does
> things.  It might be worth making it so you do something like:
>=20
> 	struct crypto_mech *ctx =3D crypto_mech_alloc("krb5(18)");
>=20
> to get enctype 18, but I'm not sure if it's worth the effort.  Also, =
I'm
> not sure if there are any alternatives to kerberos we will need to =
support.
>=20
> There are three main interfaces to it:
>=20
> (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.
>=20
>     These all do in-place crypto, using an sglist to define the buffer
>     with the data in it.  Is it necessary to make it able to take =
separate
>     input and output buffers?

Hi David, Wondering if these "I/O" APIs use synchronous or async
crypto under the covers. For small data items like MICs, synchronous
might be a better choice, especially if asynchronous crypto could
result in incoming requests getting re-ordered and falling out of
the GSS sequence number window.

What say ye?


> (*) PRF+ calculation for key derivation.
> (*) Kc, Ke, Ki derivation.
>=20
>     These use krb5_buffer structs to pass objects around.  This is =
akin to
>     the xdr_netobj, but has a void* instead of a u8* data pointer.
>=20
> In terms of rxrpc's rxgk, there's another step in key derivation that =
isn't
> part of the kerberos standard, but uses the PRF+ function to generate =
a key
> that is then used to generate Kc, Ke and Ki.  Is it worth putting this =
into
> the directory or maybe having a callout to insert an intermediate step =
in
> key derivation?
>=20
> Note that, for purposes of illustration, I've included some rxrpc =
patches
> that use this interface to implement the rxgk Rx security class.  The
> branch also is based on some rxrpc patches that are a prerequisite for
> this, but the crypto patches don't need it.
>=20
> ---
> The patches can be found here also:
>=20
> 	=
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=3D=
crypto-krb5
>=20
> David
> ---
> David Howells (18):
>      crypto/krb5: Implement Kerberos crypto core
>      crypto/krb5: Add some constants out of sunrpc headers
>      crypto/krb5: Provide infrastructure and key derivation
>      crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
>      crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt =
functions
>      crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and =
verify_mic
>      crypto/krb5: Implement the AES enctypes from rfc3962
>      crypto/krb5: Implement crypto self-testing
>      crypto/krb5: Implement the AES enctypes from rfc8009
>      crypto/krb5: Implement the AES encrypt/decrypt from rfc8009
>      crypto/krb5: Add the AES self-testing data from rfc8009
>      crypto/krb5: Implement the Camellia enctypes from rfc6803
>      rxrpc: Add the security index for yfs-rxgk
>      rxrpc: Add YFS RxGK (GSSAPI) security class
>      rxrpc: rxgk: Provide infrastructure and key derivation
>      rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)
>      rxrpc: rxgk: Implement connection rekeying
>      rxgk: Support OpenAFS's rxgk implementation
>=20
>=20
> crypto/krb5/Kconfig              |    9 +
> crypto/krb5/Makefile             |   11 +-
> crypto/krb5/internal.h           |  101 +++
> crypto/krb5/kdf.c                |  223 ++++++
> crypto/krb5/main.c               |  190 +++++
> crypto/krb5/rfc3961_simplified.c |  732 ++++++++++++++++++
> crypto/krb5/rfc3962_aes.c        |  140 ++++
> crypto/krb5/rfc6803_camellia.c   |  249 ++++++
> crypto/krb5/rfc8009_aes2.c       |  440 +++++++++++
> crypto/krb5/selftest.c           |  543 +++++++++++++
> crypto/krb5/selftest_data.c      |  289 +++++++
> fs/afs/misc.c                    |   13 +
> include/crypto/krb5.h            |  100 +++
> include/keys/rxrpc-type.h        |   17 +
> include/trace/events/rxrpc.h     |    4 +
> include/uapi/linux/rxrpc.h       |   17 +
> net/rxrpc/Kconfig                |   10 +
> net/rxrpc/Makefile               |    5 +
> net/rxrpc/ar-internal.h          |   20 +
> net/rxrpc/conn_object.c          |    2 +
> net/rxrpc/key.c                  |  319 ++++++++
> net/rxrpc/rxgk.c                 | 1232 ++++++++++++++++++++++++++++++
> net/rxrpc/rxgk_app.c             |  424 ++++++++++
> net/rxrpc/rxgk_common.h          |  164 ++++
> net/rxrpc/rxgk_kdf.c             |  271 +++++++
> net/rxrpc/security.c             |    6 +
> 26 files changed, 5530 insertions(+), 1 deletion(-)
> create mode 100644 crypto/krb5/kdf.c
> create mode 100644 crypto/krb5/rfc3961_simplified.c
> create mode 100644 crypto/krb5/rfc3962_aes.c
> create mode 100644 crypto/krb5/rfc6803_camellia.c
> create mode 100644 crypto/krb5/rfc8009_aes2.c
> create mode 100644 crypto/krb5/selftest.c
> create mode 100644 crypto/krb5/selftest_data.c
> create mode 100644 net/rxrpc/rxgk.c
> create mode 100644 net/rxrpc/rxgk_app.c
> create mode 100644 net/rxrpc/rxgk_common.h
> create mode 100644 net/rxrpc/rxgk_kdf.c
>=20
>=20

--
Chuck Lever



