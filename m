Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB813675E7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbhDUXtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbhDUXtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 19:49:35 -0400
X-Greylist: delayed 414 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Apr 2021 16:48:59 PDT
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2720AC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 16:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
        d=auristor.com; s=MDaemon; r=y; t=1619048522; x=1619653322;
        i=jaltman@auristor.com; q=dns/txt; h=Subject:To:Cc:References:
        From:Organization:Message-ID:Date:User-Agent:MIME-Version:
        In-Reply-To:Content-Type; bh=siwg87SXJYiTWdziVpoZ1/WZRB5wq4B9NwI
        qCSHRR8g=; b=rw7OjJ/vGqPAxymRRG7lpzeJ7Lc9a9NulEyrry5On/2FylijJtR
        /dn70eT/e+HAdoDRhxXOZqoax+1HUmHJ3IMVPWTwvUGJ1+LXw7MmiYGwU4I6/uT0
        v661PU/IkTzkOD6gDwsWqxpgMduj1ZEq1uwKzGPMxtU1GFOn8pIgM7s0=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Wed, 21 Apr 2021 19:42:02 -0400
Received: from [IPv6:2603:7000:73d:4f22:a130:f9e2:913b:3942] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v21.0.1) 
        with ESMTPSA id md5001002923297.msg; Wed, 21 Apr 2021 19:42:02 -0400
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Wed, 21 Apr 2021 19:42:02 -0400
        (not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73d:4f22:a130:f9e2:913b:3942
X-MDHelo: [IPv6:2603:7000:73d:4f22:a130:f9e2:913b:3942]
X-MDArrival-Date: Wed, 21 Apr 2021 19:42:02 -0400
X-MDOrigin-Country: United States, North America
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=1745ad0e69=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: netdev@vger.kernel.org
Subject: Re: [PATCH RESEND][next] rxrpc: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva (gustavoars@kernel.org)" <gustavoars@kernel.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305091900.GA139713@embeddedor>
From:   Jeffrey E Altman <jaltman@auristor.com>
Organization: AuriStor, Inc.
Message-ID: <f843303f-435f-7b37-a717-0026492d5342@auristor.com>
Date:   Wed, 21 Apr 2021 19:41:56 -0400
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210305091900.GA139713@embeddedor>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vZGXR53gPZweKfBp9WjYp9mam63MimH4v"
X-MDCFSigsAdded: auristor.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vZGXR53gPZweKfBp9WjYp9mam63MimH4v
Content-Type: multipart/mixed; boundary="wFwjbYYuEXESC2Po1enD2cAyA32wXLtF6";
 protected-headers="v1"
From: Jeffrey E Altman <jaltman@auristor.com>
To: "Gustavo A. R. Silva (gustavoars@kernel.org)" <gustavoars@kernel.org>,
 David Howells <dhowells@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-afs@lists.infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Message-ID: <f843303f-435f-7b37-a717-0026492d5342@auristor.com>
Subject: Re: [PATCH RESEND][next] rxrpc: Fix fall-through warnings for Clang
References: <20210305091900.GA139713@embeddedor>
In-Reply-To: <20210305091900.GA139713@embeddedor>

--wFwjbYYuEXESC2Po1enD2cAyA32wXLtF6
Content-Type: multipart/mixed;
 boundary="------------BB28084041891EC2EF6E9249"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------BB28084041891EC2EF6E9249
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/5/2021 4:19 AM, Gustavo A. R. Silva (gustavoars@kernel.org) wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warnin=
g
> by explicitly adding a break statement instead of letting the code fall=

> through to the next case.
>=20
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

This change looks good to me.  Although I would also be happy with a=20
fallthrough statement being added instead.

Reviewed-by: Jeffrey Altman <jaltman@auristor.com>


--------------BB28084041891EC2EF6E9249
Content-Type: text/x-vcard; charset=utf-8;
 name="jaltman.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="jaltman.vcf"

begin:vcard
fn:Jeffrey Altman
n:Altman;Jeffrey
org:AuriStor, Inc.
adr:;;255 W 94TH ST STE 6B;New York;NY;10025-6985;United States
email;internet:jaltman@auristor.com
title:CEO
tel;work:+1-212-769-9018
url:https://www.linkedin.com/in/jeffreyaltman/
version:2.1
end:vcard


--------------BB28084041891EC2EF6E9249--

--wFwjbYYuEXESC2Po1enD2cAyA32wXLtF6--

--vZGXR53gPZweKfBp9WjYp9mam63MimH4v
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+kRK8Zf0SbJM8+aZ93pzVZK2mgQFAmCAuEQFAwAAAAAACgkQ93pzVZK2mgQ6
vxAAnvRRrMO46SO6sEIk7UdNXwggTg09B+Gs5/g2WX+GFeJyhi/Ap2a5C0sx9phaGC2a31dTqsXQ
dwRXt/8V0l+Lx1tlnyhUY/D2z0YMA2vHxfYo+ksmGcoNbzXg0imuCiCd7EUrp5GEaVmSziFzdQxq
P/Di8xePJymwRKXwm9FRWGQOe0zxExFWDqEjQm2NIvowzCxVOdotC8+pC/m3fIkW6wGygSvkeVCf
ZX620oebCBOym56oI/QPm/HOpm+i4GWxpHIwbAmbYzEmxsG7grFJQK2Eu4CGt/Vw1tZCskzvY/8p
Q9UMATgg/i5jpvNphQZ74BzfWuhS5qowJF0NMjFwbZ7BDHo68iOX2cKhOahi/rqys1I9IgcX13K3
NZ2BmJrgGOAgyUl1kr/8pXFjRkLTDZ2f4vhIDiiq69l6drOMET6GyLbZmXrvxYo0FvrE5WzkARgO
BWZFDFkNUJpWAwgTC4mnbY11vsL0Jar+36tuMrbDn5M9/bkzDl+TojKwbpyNb8mdHZNZ6nBq16rC
hvBfrf/Tq/GRcVG2kWdaEeu0aazSPL4/MwhoiqvyXc+y++iJb4KV39x16iMSDScMQtnnez/GmrJB
dVXd+zeK9r4Gww4appSWeLVMZTawBgJtJm5V/tfbm/wulW/pjNLdPOg3BIGiEi/ST2d9RuiaPMaA
Em8=
=JlT8
-----END PGP SIGNATURE-----

--vZGXR53gPZweKfBp9WjYp9mam63MimH4v--

