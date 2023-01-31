Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8A26837FA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjAaUy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAaUy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:54:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54D34C28;
        Tue, 31 Jan 2023 12:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1675198477; bh=QeckxysZjgypxBRfoatLwznSwJbDt6HokBs3xnmWHB4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=kWzj+Z2p6lKeqamyPgX04OPdFh3vJlwjdSuxdwBVhB7cTDwEf5EF6D2V8pW6jiCem
         5c1Z3SsrKvq7wdtC+3/EG6b+uyGRa6UriQE4syySM/Hxgvywp6GyopEYF2Xz4Bc1CE
         wd8CCX0ZNeNWU0PpcvkMCk03Fc6erHHuOoR+cEGQ1ssVzKr9SXOnthY0ZHtnrLQOef
         Pf2ye4ogRjHjGZZxGsg8EhjG3/tZhhbiXIg/QZB8G3yh9h4Iu8fpsqDyqHJNSgsSzi
         SpipxIo1brX16MOYA5gONjVQz2Nha346ZN8cqpjojdElkXw2XKHp/KhHdQv9M4v1CJ
         GdRc1J3e8oHVA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0G1n-1oT62k1X9j-00xJNl; Tue, 31
 Jan 2023 21:54:37 +0100
Date:   Tue, 31 Jan 2023 21:54:36 +0100
From:   Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add kerneldoc comment to napi_complete_done
Message-ID: <Y9mADAaHTGOEBzHd@probook>
References: <20230129132618.1361421-1-j.neuschaefer@gmx.net>
 <20230130182622.462a2e0e@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="spt6httPZc2M2IgK"
Content-Disposition: inline
In-Reply-To: <20230130182622.462a2e0e@kernel.org>
X-Provags-ID: V03:K1:Dvk4XHQzgmvXSu/0175crCx4gYC47dN01iRmJk/i+r2gzcUYRWr
 6357Oa7Gb277XuZKzYeRkZ/JnVp/L+dFuLMEd9Rp+sZUy+LNb8V6C1NljlF6d+a1mWBQVX+
 wqcaeRVAqcGj7gC1+ORImEZN+kz7fY4pJq0vQSPUM9Ytpj6qGs/QFaShFOH5SBAWG91976T
 u5Vhf+7hIF6r1cFj7IMZA==
UI-OutboundReport: notjunk:1;M01:P0:DMrOMspsWJ0=;z5o2rLNODMzbWH9XWlnWVzN+bjs
 mrkf+m5QyQ2v02Kex+REplSwkeS6lz8Bj3QCI6yWapNuT9Co0IScAMCvGD74ZUMILXBufmIkU
 g90r2TIsS9Dy2oTSPqa+l9tK/cvPqf2/R8Zhdp0QxR5TcHiSZ1sZTi8nYPC+3tDWXF+0CIk1Y
 d6n8clBEkKS0H8cfBfVnL6ydPtSiw8qu+vX4NvvcRErwAlxvCraABOuE6d6zb6NO4V41GASGS
 Dp//2/KEPeGvtV36Sll6tcPv8FTJcN1S+FSPbqP5jK77G7bupXJRz8wJmY713qZzWFdd8cZzH
 KC0I4sBbxKYnL9pRbKwIF2NPgNCNeRvUd0Gk+hj6h6p9whg4gqSnfGqNyEo8PS3XFveob8BgT
 2+ynOXdjPm+e32cq/mFMhfoC+SnwdLWgsR+9+1A7Naf0ADDcIQcL4bhZylLyInDAS5sBOHl+C
 5uWDIRRyu0R7yRlCuiGZh4kmA2eCXPe7eMtkP1/SL8s9YwA9z+BNBBRsx33OkXxzltBXaTHi7
 bkmCGphnsThAs43iVglMrxPXtlJMb2gDWsHgcq5g2FB5TNQz+4YAbJUbtXHGp1Edqr0C1Ad5A
 UueBOOQ2WVqyOx7Z3BIzhzbc2RvyRRjQvNmETGNV99wNI8OdenoQXMnnD9rQFE/U4bLod7GwR
 kuj2kfys4HmFZ9Dz3vng649g/Y6sLRwYtBZNxkFaHPRpd04iUbiXzh5wWcgCUNA032CjDbKWu
 t6XSF9O824ilnp6svI5tPrng1djgEq5llVeZGuoC/Z8m3iGvQGcMO7klgNbZ/E3KAp/3p4+nT
 nBJlGn/LpZXgHwELzwDrpnSKOX5YsjOqc2ObdBIe/6SeYW3PHPfc0hKUpnwCTjrgpvorUbwGM
 Llq6x3B9IpwHLRSJa722dRPGKY6E1IepiVP3pqVpBTLydpKswc7H6fZlvR0JFpDpkJZBG2bzK
 cHqpcA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--spt6httPZc2M2IgK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 06:26:22PM -0800, Jakub Kicinski wrote:
> On Sun, 29 Jan 2023 14:26:18 +0100 Jonathan Neusch=C3=A4fer wrote:
> > Document napi_complete_done, so that it shows up in HTML documentation.
>=20
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index aad12a179e540..828e58791baa1 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
>=20
> Please put the doc in the source file, rather than the header.

Will do.

Thanks,
Jonathan

--spt6httPZc2M2IgK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmPZgAwACgkQCDBEmo7z
X9s8HRAAwpljw8caoG7P0QpqN0Vn06mjKaH6nQuiIk2XxKoQmgU2uUCGaMoLn/Qg
Y46XsT4NpWE7T7+D/PeFjpwPsZWi9mp02lD1wYP6HOK39uAC6PL1arBvRS36D6NV
N8gi/08m8r4V4zt6SqN0bQ4V90bVXvcfyfPUglsVmxkYDw+K/sHEeaUdxsICjXOt
3e8EW84RHwHksp2jQd+pWK+rNWKNf1QDoSwQSt/NoYpTpHnF0VGjJCWB4H1YjwHT
gIvd4TlZCrqb5RJeCn7loHrVbSjJrpbAJKBYtjD7AmY3uOO0MJvsNoowDZfcnKz9
D8nBf8YRjM/Zpt3EtY6yi5xE8iVXy6JTnKguXDPt/z9efNHMAvJJ9xXaDAF65wn8
Ll5qu7fILmtAMxZ4e8O0jeYkdERzxfH6DHHZzxo7C2Yi8mS9Dwzwbre8yO2JOoAY
sbN9BxeA9Rf0wvD3Su4oCTkt0d1OMRzRO7IhDKLn71lq9jHpsunfdduhuT6kut7i
WkRZNJOg4JrkRYTcHTP1j2YBCagQn83oy8ps24FtrOfmKAqyTklo4/nCGsqmR3sK
lqF+ur7f7LPmUR7NYfwEmJGyIPHpD0MHyRPRH6R8pNX/eHAntdyJDAt5Rrv5OR1T
OzwN0DWYwHExG6nNLKsL88uF9qAQ1J+jlVE/iSin5hLC3Mk+jS8=
=W5lQ
-----END PGP SIGNATURE-----

--spt6httPZc2M2IgK--
