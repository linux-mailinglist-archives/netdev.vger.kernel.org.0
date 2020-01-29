Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B570A14C858
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgA2Jsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:48:43 -0500
Received: from thermi.consulting ([188.68.37.10]:61148 "EHLO thermi.consulting"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgA2Jsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 04:48:43 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 04:48:41 EST
X-Virus-Scanned: amavisd-new at thermi.consulting
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=thermi.consulting;
        s=201909; t=1580290772;
        bh=k1ERDR5ssGfqeTVgzqVJ4/tTSScfvbtNULEQ45CfDt0=;
        h=To:From:Subject:Date:MIME-Version:Content-Type;
        b=F52JPI4wlGuZMRiTVVA2qez0xSalHnY2PfIhcuGF46sk5VTFxJ3CbPWMaL+PhZ0Xb
         NFephXsahLpRGW2N0HR4MCGNbJxx6/edYirzVQ9Qk90871jBwmfPtEAKs/+fVbyXUL
         SUIk2MhZn6E43N4HrUzZIbsrF4xE/130/K0dM4FMjQ7NamlwB6JgUMx46S8dnmOBfr
         9wuQRJbz9vodipqWsqDX8dZff8lhNarDG+pYKBqNPQriHQNT1uzWHGRmLGf1ykPzez
         muh69e4XpRMFr7ZuqErUvDCXY//75ldRzhQqfom7IaAhdyOQ4n5o/guYnJ41JhCQ+j
         g7pB0/ReHnASA==
To:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        davem@davemloft.net
From:   Noel Kuntze <noel.kuntze@thermi.consulting>
Autocrypt: addr=noel.kuntze@thermi.consulting; prefer-encrypt=mutual; keydata=
 mQINBFj5VaoBEAC3iywTeHDZ5TT9adO4p8TJa8dyMVvwP33ueIu+CMJI9AQZZGUZRbVeJiCW
 Rtghw4tkQQxQ/xC17RZ+0hFwlCJ/6xicgSi2uDaXlgngWLQZalnbeQUit4YzXbSNxIHzyb4G
 8IaA8Q2IDx6g67QYy3LIeONWGgFtyAWCvSl8JX5GMU9Pyz3H/8AXc8ZIn5boAp2VdzXudR+0
 S4w82dyXjv0Mn4M3CmQsoF+3wZC5zKa8a1lGvk+4o8XGMe5t70jQFFzBUEPwJDPij8QtJxAN
 WSz4SjRzj/z0z/I1HK6vHkn9fvOfK7pJd3fNjctHVleSgKHB6y/iUxMZ0vOGdoUVuh4y4c2w
 vJ9wqnB6+3uSqyDsiRQ7ztGZjg57RngZerwxQ8pcKrKZCzXrJGV9Jj1DSfmm++LOCFzCn7g1
 skpLkngSvPQ3+PWbLuK+ynxr4zmKvUh2rJIiS0ILLcr4Zz4T5MxtVc1PYDAgcVRo5QBznvUk
 ucE1gfOFqa+azXyd7WynrCgWWIKoWQaFcBv2ZjF8wppT29tytkNEkdKKxAz4pUGU4NlVjn34
 QUTe3Cqf+cPd6ODCx7hMqLVaplONSkM7TpWXzZDwCUSqpk+xv4pUVluEEg/y7u6HZHdMkTLk
 iI9qGCY89yzNuoqebWxQXRb269rvOL2+PJn7r1wvgwlRGnaB4wARAQABtCtOb2VsIEt1bnR6
 ZSA8bm9lbC5rdW50emVAdGhlcm1pLmNvbnN1bHRpbmc+iQJUBBMBCAA+FiEENSSTvrX3jmMT
 cq8t9U7kCwc5rWwFAlj5VaoCGyMFCQlmAYAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 9U7kCwc5rWxV2A/+Isk4Pksd2X2MbDUcieJtkn0s2v5AIeAVOqn4R+hqwcnCgX8UuqyJTvjO
 kcQRgqJfMWcNN314YwMprdL/aeE6y7BQ8s8tTJ64aIPtXAPyLkE8Vox4rqKVPCyewxdmDXoh
 tt6YIX3IBDbsDyOe24q7nSXVF5X/250XaArhhKZpJQI9g1ojofrGeqz9ojdE+btzgwlESV9A
 Ip9PujMLIqG4DdmOmz50YmKBrc0e4s43p2Hamzv1iNa0ZIKFjGN9VH8jtUyNfQi4QvubnGb6
 doqkyG/7B+j6e3I0s6mybsPM2PH/M+WYTymLWWBJBCxI1AGW2CjWlSuDrZ5Vauj1R/ddly5C
 bCsE6NKpr8fL7B3FOsmdmPC0YcQUyU2UiXouyzwbLfC+Il8/Qv7zlfm18sF3Pw6UGBkv4YCM
 ryQF2iMvSLyv/RJ72ccbnMQNuujZlecuEEC+CHlFQ1f0ZsMu5lHo6h9aepz7dXvTeCaFvWX7
 I55lNFoy1COH+e6A8Q9Yfa/imWWSo6BZEkdUsjv9jyjyqGdk7VKtr7EcbOsDzvfJzI6GO4Rh
 OsG6LKhrV02/1JxiURq27z2ktYQCUR2SOMebM17gHmG3fPGe4NDTNguv2jQWl9HrCcVGdz/w
 RFRgyRcRTP8rmnw1ZIhIkPcW4JYBImY8jdI8OrBOizkxSxz12De5Ag0EWPlVqgEQAKWrSJOx
 OB/rvNetzsNRWtb0cgmaDtgRpkWug+VX2QKwhP0vDz31QbilXk7Qod5nAX+esaiua8Zq6x/u
 p74HQPeCAsV9Yhu6pXmH11BHBFetyo6/fc+PEa7Ua2uBBgi4KM9LlWiJ9jToaHE9TQDmRyQ+
 kCUt9IsQq8RTu8s9gixeYoRih77EplfFkFB+mY0kLt0H7RhMtGBnvtGl6p70CIoFrwBRTdN4
 VMLEnTQepIoeXMLt149HSzS0nEowCJjiHHNjJHZ3RVAVu7OKyCqV2G8oXJlz+T8ShJC8YEaL
 iWTVsIaOUiGhuczEClgDAw2lPpjxAuV+v/2Z3Uu7O1sKUx4H0SsDGTI68Lya0AAAyJ2Ac+Jt
 FpSJvhpCgevHKzq0+6upXYq7vtkw18eao0nnpOxFCBLNTMed3/uM9BTrZaByfq+7fQ71c36z
 P46K6xKtWpAT3D2uZHRCxmh4v6fQC639bJJ65rYRlRXAPAGxxuRwvM5oardbOGRmTCqQasU/
 UrzCYWb38wWYsUIphC5NtesaubhveNYd7W3YdTuhMpYke/OfA6J7xZvlMSEILpH/iHaESoKx
 0+3k/AZvoytAsdqkslEq05TqXQXHpjI9TnsyaMOBMDTdElUMW4cO8sKWJe8ncRQ5FEBlOJmY
 CkSnOXLvO6XTphwU49vaOU+Am3v1ABEBAAGJAjwEGAEIACYWIQQ1JJO+tfeOYxNyry31TuQL
 BzmtbAUCWPlVqgIbDAUJCWYBgAAKCRD1TuQLBzmtbNb4D/kB2z+D3/vJXC/ix9hetPkkB6dH
 LfJn2mMyCv0MNE8WH+CkVUbgP6xlanOD6QvCA3nJLSO4uymV/slN6G1ZUK3IftVnLeFa9BZ5
 K+C5AtNk6GgUF+UwDE90viu13yVpUX87aLwgDqe3D3Z5Ju0lyK2k26dQNhTcgTXPMGdHNI1w
 INVyuwCmpVBCuJ7jhfab+gfOm/uCk/KDyKZL1zx2ND2nwbe0imtya39F6TJc6qGRinnG5W6Y
 64ywjqFek9W7BRs5I14avsTCQ9M1clsUWDe/4tfee4UayQkX+aAh50AuhJ+eKWaLrbr5Vvu+
 0Fp9yOReZebRtY2agn467jqBx+9jIqmPj3bY7f7BooscX2fi2YpoxUGi9xIWAVrJEfDVErYD
 L6PgTrs2Pwdk9r193BxlY6MdZKE1t38WLi3Hq4tNNcJCKmxwMW+dkntu/H6/VVyhpR+hm83n
 tArxTmxa6WboTOqbLtz6b5/9D53qhwm7yKkmbohA98Hq22/F+n95TtDA2hvfwIAWxn8jY66h
 MgxWcFC00hCm21wROYAPfzR0R9ieB8QRm7igR6fqFKwEAH9Z2kQGzMevsZn3qfUIWHcuYojF
 4xrvev7eXUEFQyyLTQdnCEuf575F8/TagnVIVIRAgN/Yd4ehqLLWxcn49vRVL6xzLmrJQ+3g
 S8oPas/9uw==
Organization: Noel Kuntze IT- und Unternehmenssicherheit
Subject: XFRM with bridged packets problem
Message-ID: <f595200d-46e5-b28c-fd3b-331ddad11347@thermi.consulting>
Date:   Wed, 29 Jan 2020 10:39:32 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fNmENzaWf83vJthtgQAr8VYsMtVCcFolY"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fNmENzaWf83vJthtgQAr8VYsMtVCcFolY
Content-Type: multipart/mixed; boundary="QeZ5GNq7Z6hGIEsU3OVdhSqmnHTbdtZut";
 protected-headers="v1"
From: Noel Kuntze <noel.kuntze@thermi.consulting>
To: netdev@vger.kernel.org, steffen.klassert@secunet.com, davem@davemloft.net
Message-ID: <f595200d-46e5-b28c-fd3b-331ddad11347@thermi.consulting>
Subject: XFRM with bridged packets problem

--QeZ5GNq7Z6hGIEsU3OVdhSqmnHTbdtZut
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE

Hello List, Steffen, Dave,

I have found a bug in XFRM/The IPv4 network stack.
Reproduced on 4.19.99 lts and 5.4.15.

Following my notes to the problem:

XFRM docker issue
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Topology:
docker container with veth pair attached to docker0.
docker0 address 172.17.0.1, container address 172.17.0.2
IPsec policy based tunnel from 172.16.20.2/32 to 0.0.0.0/0
Passthrough policies for multicast, 172.17.0.0/16 to 172.17.0.0/16,
no matching policy for 172.17.0.2 =3D=3D 0.0.0.0/0
Packets are sent through tunnel regardless
Packets with wrong source IP can be observed on other IPsec peer, traffic=
 counters of incoming SA increases; One endpoint is on the internet, no s=
hared link.

Naturally, the packets are dropped when they're received by the other pee=
r because the policy doesn't match the negotiated policies don't match th=
e packets.

After adding an SNAT rule on the docker host to change the packets' sourc=
e address to 172.16.20.2, they match the policies on the server and make =
it onwards. Before then "XfrmInNoPols" in /proc/self/net/xfrm_stat is inc=
reased for every packet.

Please let me know what you think.

Kind regards

Noel

--=20
Noel Kuntze
IT security consultant

GPG Key ID: 0x0739AD6C
Fingerprint: 3524 93BE B5F7 8E63 1372 AF2D F54E E40B 0739 AD6C



--QeZ5GNq7Z6hGIEsU3OVdhSqmnHTbdtZut--

--fNmENzaWf83vJthtgQAr8VYsMtVCcFolY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENSSTvrX3jmMTcq8t9U7kCwc5rWwFAl4xUtQACgkQ9U7kCwc5
rWwgow/9E96Wu0aESkXexmkMg1z/GA5rL8C1QWZMoOzufn8RRK89ESjD57qc8VDl
7X2Qlj+uK8jdXmoEnzigABmLRuhg8GSAV5/5Qf1vSGwF2GT5795jT3Vmvyow6wf5
I4CWLJG/tdSv7M3FCNLvPuLB19pBqywvK4t9lY118jBQaAjsG48kT57VsSX1O9bw
UWndSEm6gnl2I3qeSKD4EH0IUKXJKASXYcDtrmkFas4/91ObHxQuE3zs6neya7th
81rWrjekzeKxvXIl+V997F3hLMPjMq2o1nKSkOltxsDan6Z+SS/gPacnSXHOh9js
S7awTxEEq8PuHomAdsHh4cFsTe8KnKSgEtvsix8cefCiQXYA5o2v1/FA4mr80io0
GylrCxymT/J0+6udRQEhzbyrQ7QdstwnwyO6KwwUEEkqkc7vDaiCyuR+BSWREgPu
BzLlamop+S/bLHItQdV8ItsYh7rM8W3uC/d+zgl2oaCO7I7NTp80Rh9GvSVwjhC/
NKW3Mb+IwWpItiLzgVfmTVqQpqAyAf6BvPjtb9qY3OGGAo93AuVGqw5nVH8rDuwh
k12oVQaC72DKW65L6UU/dSPRA4d5iZ+1n9DWKP5wTQroaCcf0jTIUK49ai/AUe9G
CetKWnFQwMc6zVu9sipKuBOUFQEnF5bzJtCg0VgR79h3tGCVN3o=
=QOlC
-----END PGP SIGNATURE-----

--fNmENzaWf83vJthtgQAr8VYsMtVCcFolY--
