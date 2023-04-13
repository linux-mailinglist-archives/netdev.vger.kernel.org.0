Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1156E0EAC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDMNbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjDMNav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:30:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67954B456;
        Thu, 13 Apr 2023 06:30:43 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v27so5055128wra.13;
        Thu, 13 Apr 2023 06:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681392642; x=1683984642;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KaQK7iRVCZ+tGOMD5UBKDQNPYAFG6irJphSnlz1XYBw=;
        b=TPjS5y9UZ2hxCMCh9+/obcWBxBNchwkNkR2+5Hxj1z6twN9B+YQviF21Fh32MmkP6l
         Gey735gbZMvKqM17FyPhZwLAlhMc0BaMLHZpgS3jBU15IOUeJHmNAQPx1/IWbZ70IYAz
         fRQGR8z4QJcX9Bub3XXje4MvKC/uFqpMos7wBeRxH/R07jrz1hGrK4a5m4SX+HhAEDa7
         cK3CgSI7a7vAgbnfCLbo/0d98/9ps5BcewJIp/d7SuXcryzNQc7QCgPqTFJqv2WDbJSF
         KukZP3s5C5zCnGNuDvAg38jUYSW4WulydwMzBxMqTbOH/AAAE65ofd9e37mMqd4tjQcK
         j1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681392642; x=1683984642;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KaQK7iRVCZ+tGOMD5UBKDQNPYAFG6irJphSnlz1XYBw=;
        b=T1VxzpqN28RfNTPzh4rG/5gFiM1IFF4jq6Jt9dboSvynj+7PR9cZtWcBtjFOXySnr6
         PTh38JNrQFHTvxFCLjRVviRWKGZ4ttGDPgSJrhoYIHkzVuGK5PiHYT01LsGDXjqEXsm6
         qiuZTcAgJPQY2jCjvsFgFy9aSj92JbE39Kvp/6DkmZoMkopRAY0UN1yy6IBluAMKDVPv
         Yu7RFP+pDGHzl2CjoW5AVbkCC6hHBipk6peIvyfro/0JD5/q2V/GcIPQjzVFUqsHkld1
         e6bdECefXnKzwLqIL7S692tvrDpvwf3hpUbDdt6m74gMEDGeyb5kYj0Hkh/W6aUn+tqw
         OMFw==
X-Gm-Message-State: AAQBX9e45EYJt9/umqO1lDkn80bp7QDFPI+o0Kk5s3UJ+mL+uGbrPzKh
        26ExgOXjRHctWObDmgHvTgXi/AarPAQ=
X-Google-Smtp-Source: AKy350bVM7Z+i+WXuHDw73K3etpPAQ49rP5bnEMELhFz/G6QANG9X+8NR7mVMHhDNPQePFigMOtm+g==
X-Received: by 2002:a05:6000:1a42:b0:2f6:208d:2239 with SMTP id t2-20020a0560001a4200b002f6208d2239mr1343465wry.11.1681392641452;
        Thu, 13 Apr 2023 06:30:41 -0700 (PDT)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id z18-20020adfd0d2000000b002da75c5e143sm1317371wrh.29.2023.04.13.06.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:30:40 -0700 (PDT)
Message-ID: <41f3331f-24d9-ae44-1609-1e9a610a6170@gmail.com>
Date:   Thu, 13 Apr 2023 15:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v4 resend] ip.7: Add Special and Reserved IP Addresses
 section
Content-Language: en-US
To:     Seth David Schoen <schoen@loyalty.org>, linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <20230413012348.GA2492327@demorgan>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230413012348.GA2492327@demorgan>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lpGbLPkzDqlAdiGmhUly0BE5"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lpGbLPkzDqlAdiGmhUly0BE5
Content-Type: multipart/mixed; boundary="------------ZbDUAOr3Nnooxg74Ca40Xhcq";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Seth David Schoen <schoen@loyalty.org>, linux-man@vger.kernel.org
Cc: netdev@vger.kernel.org
Message-ID: <41f3331f-24d9-ae44-1609-1e9a610a6170@gmail.com>
Subject: Re: [PATCH v4 resend] ip.7: Add Special and Reserved IP Addresses
 section
References: <20230413012348.GA2492327@demorgan>
In-Reply-To: <20230413012348.GA2492327@demorgan>

--------------ZbDUAOr3Nnooxg74Ca40Xhcq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Seth,

On 4/13/23 03:23, Seth David Schoen wrote:
> Break out the discussion of special and reserved IPv4 addresses
> into a subsection, and briefly describe three cases in which
> Linux no longer treats addresses specially, where other systems
> do or did.
>=20
> The divergences in Linux's behavior mentioned in this patch were
> introduced at
>=20
> unicast 240/4 (since 2.6.25):
>   commit 1e637c74b0f84eaca02b914c0b8c6f67276e9697
>   Author: Jan Engelhardt <jengelh@computergmbh.de>
>   Date:   Mon Jan 21 03:18:08 2008 -0800
>=20
> unicast 0/8 (since 5.3):
>   commit 96125bf9985a75db00496dd2bc9249b777d2b19b
>   Author: Dave Taht <dave.taht@gmail.com>
>   Date:   Sat Jun 22 10:07:34 2019 -0700
>=20
> unicast subnet lowest address (since 5.14):
>   commit 58fee5fc83658aaacf60246aeab738946a9ba516
>   Merge: 77091933e453 6101ca0384e3
>   Author: David S. Miller <davem@davemloft.net>
>   Date:   Mon May 17 13:47:58 2021 -0700
>=20
> Signed-off-by: Seth David Schoen <schoen@loyalty.org>
> Suggested-by: John Gilmore <gnu@toad.com>
> ---
>  man7/ip.7 | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
>=20
> diff --git a/man7/ip.7 b/man7/ip.7
> index f69af1b32..94de21979 100644
> --- a/man7/ip.7
> +++ b/man7/ip.7
> @@ -237,6 +237,7 @@ In particular, this means that you need to call
>  on the number that is assigned to a port.
>  All address/port manipulation
>  functions in the standard library work in network byte order.
> +.SS Special and reserved addresses
>  .PP
>  There are several special addresses:
>  .B INADDR_LOOPBACK
> @@ -244,12 +245,43 @@ There are several special addresses:
>  always refers to the local host via the loopback device;
>  .B INADDR_ANY
>  (0.0.0.0)
> -means any address for binding;
> +means any address for socket binding;
>  .B INADDR_BROADCAST
>  (255.255.255.255)
> -means any host and has the same effect on bind as
> +has the same effect on socket binding as
>  .B INADDR_ANY
> -for historical reasons.
> +for historical reasons. A packet addressed to

Please use semantic newlines.  See man-pages(7):

   Use semantic newlines
       In the source of a manual page, new sentences should be started
       on  new  lines,  long  sentences  should be split into lines at
       clause breaks (commas, semicolons, colons, and so on), and long
       clauses should be split at phrase boundaries.  This convention,
       sometimes known as "semantic newlines", makes it easier to  see
       the  effect of patches, which often operate at the level of in=E2=80=
=90
       dividual sentences, clauses, or phrases.

> +.B INADDR_BROADCAST
> +through a socket which has
> +.B SO_BROADCAST
> +set will be broadcast to all hosts on the local network segment, as
> +long as the link is broadcast-capable.
> +.PP
> +On any locally-attached IP subnet with a link type that supports
> +broadcasts, the highest-numbered address (e.g., the .255 address on a
> +subnet with netmask 255.255.255.0) is designated as a broadcast addres=
s.
> +This "broadcast address" cannot usefully be assigned to an interface, =
and
> +can only be addressed with a socket on which the
> +.B SO_BROADCAST
> +option has been set.
> +Internet standards have historically also reserved the lowest-numbered=

> +address (e.g., the .0 address on a subnet with netmask 255.255.255.0)
> +for broadcast, though they call it "obsolete" for this purpose.  Since=

> +Linux 5.14, it is treated as an ordinary unicast address.
> +.PP
> +Internet standards have also traditionally reserved various addresses
> +for particular uses, though Linux no longer treats some of these
> +specially. Addresses in the ranges 0.0.0.1 through 0.255.255.255 and
> +240.0.0.0 through 255.255.255.254 (0/8 and 240/4) are reserved globall=
y.
> +Since Linux 5.3 and Linux 2.6.245, respectively, the 0/8 and 240/4
> +addresses are treated as ordinary unicast addresses. Systems that foll=
ow
> +the traditional behaviors may not interoperate with these historically=

> +reserved addresses.
> +.PP
> +All addresses from 127.0.0.1 through 127.255.255.254
> +are treated as loopback addresses akin to the standardized
> +local loopback address 127.0.0.1, while addresses in 224.0.0.0 through=

> +239.255.255.255 (224/4) are dedicated to multicast use.

Maybe it would be interesting to use tagged paragraphs (.TP), so that
it's reasy to see at a first glance the reserved values?  Something like:=


   Special and reserved addresses
       INADDR_LOOPBACK
       127.0.0.1
                INADDR_LOOPBACK (127.0.0.1) always refers to the
                local host via the loopback device;

       INADDR_ANY
       0.0.0.0
               INADDR_ANY (0.0.0.0) means any address for socket
               binding;

       INADDR_BROADCAST
       255.255.255.255
               INADDR_BROADCAST (255.255.255.255) has the same
               effect on socket binding as INADDR_ANY for
               historical reasons.  A packet addressed to
               INADDR_BROADCAST through a socket which has
               SO_BROADCAST set will be broadcast to all hosts
               on the local network segment, as long as the link
               is broadcast=E2=80=90capable.

       Highest-numbered address
       Lowest-numbered address
              On any locally=E2=80=90attached IP subnet with a link  type=
  that
              supports  broadcasts, the highest=E2=80=90numbered address =
(e.g.,
              the .255 address on a subnet with netmask  255.255.255.0)
              is  designated  as  a broadcast address.  This "broadcast
              address" cannot usefully be assigned to an interface, and
              can  only  be  addressed  with  a  socket  on  which  the
              SO_BROADCAST  option  has  been  set.  Internet standards
              have historically also reserved the  lowest=E2=80=90numbere=
d  ad=E2=80=90
              dress  (e.g.,  the  .0  address  on a subnet with netmask
              255.255.255.0) for broadcast, though they call it  "obso=E2=
=80=90
              lete"  for this purpose.  Since Linux 5.14, it is treated
              as an ordinary unicast address.

       Internet standards have also traditionally reserved vari=E2=80=90
       ous addresses for particular uses, though Linux no longer
       treats some of these specially.

       [0.0.0.1, 0.255.255.255]
       [240.0.0.0, 255.255.255.254]
              Addresses in these ranges (0/8 and 240/4) are
              reserved globally.  Since  Linux 5.3 and Linux
              2.6.245, respectively, the 0/8 and 240/4 addresses
              are treated as ordinary unicast addresses.  Systems
              that follow the traditional behaviors may not
              interoperate with these historically reserved
              addresses.

       [127.0.0.1, 127.255.255.254]
              Addresses in this range are treated as loopback
              addresses akin to the standardized local loopback
              address 127.0.0.1.

       [224.0.0.0, 239.255.255.255]
              Addresses in this range (224/4) are dedicated
              to multicast use.

Cheers,
Alex


>  .SS Socket options
>  IP supports some protocol-specific socket options that can be set with=

>  .BR setsockopt (2)

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------ZbDUAOr3Nnooxg74Ca40Xhcq--

--------------lpGbLPkzDqlAdiGmhUly0BE5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmQ4A/kACgkQnowa+77/
2zKbog//c0BHLMCtDQNLp0fl/2Cs7qeFsTC8LOn21auQP3tBH+d2AAxhr7L7NVIU
cc5uosIe+ekSCVh0yuMlEex/QYZjChwP5SQ/Bp7ZuJeTNKMVwIYBJJkJHnyhNCCs
uI7D7hHIsBo8J6Pn27GKswb0t6rqOieUr2f3JD/oY3ifUIwryFlJP4MzZEGOEJT6
7detZ2GQpVzTbA8cal129qAdYBn5BGBhBupYoJe0LTTpsqrjj16Kve8Mvt1syvTb
Q9urfgJM67ScM5VRshIrfIK/YmL/t0cuCz54bhsDzzCs2h06XYoBOtLJdzjxtdXr
6E6c8hkBJ2RBb+j+Sk1FK/UTsEcY/RkNmuGUozV/UnqQqlHLIDFvACyZjwFcIq3Q
86bMCINr/Td7vvJM05Kn74bewFJ9Hv4XiUwNoKudT9ljNXXSfd7Wcq2PT3F/3/M6
HsCTwUySf29eUxkawyTMf6ZV4asXDSItS8PN8f7kJij5/Z5gZSEl4WM4XyD2b3HK
lvMtW0wVLf7MwmWH3pdO6IcEfrAVA7qzc0pmtFY6CpAYCw02+NOdyAnrvDu7c/WZ
j81DblG68RO1+usGUcwoFm4puA15sq+YY6/WoOdJjG+75IkofC9I3X+o1Vvpn/EY
VxrAq+BuZ1kZkbGN0m1wCbRcyvDCk4T25imKo6WTPl5i9vSeb2U=
=TWrU
-----END PGP SIGNATURE-----

--------------lpGbLPkzDqlAdiGmhUly0BE5--
