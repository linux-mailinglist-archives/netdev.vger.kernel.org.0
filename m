Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C957C6E2A76
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDNTJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 15:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDNTJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 15:09:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0C106;
        Fri, 14 Apr 2023 12:09:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q6so7077030wrc.3;
        Fri, 14 Apr 2023 12:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681499366; x=1684091366;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPaSN8j8Tte71Ibw03Nwg/bJ1T4n2RtGqmHptCINpCY=;
        b=Lee8XBlhNOgenRYbV5pnEfYUOxdSh+TcNIdnGk/thc9GLfS0DjUmICve6XnDMJkNjJ
         H2P7z02gQck9dGOA0ADzK2yn0mJwbdnlBZ98rkx85ZGKL4oTeBhOVDRDq7ug6XAcMp4o
         KCBwnnvrwWqBstwGam8lTzoyZ5KKsX0grJc4vMs/11Z31Y6aa0dYF99IE6r1FWdwV5lO
         f1O9ANjFnNlCXs2hrBH5ICynEaXXOdSm8eA2ZsAC9hVm9MX4y1wnaljgqdFh0iVEzUVj
         8D8vb80Egpmwl2CksYkEPxgVp+qJz8Dloob5RPYGakU5P9tdKtayzn2hgQYtL9kNmxl4
         cvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681499366; x=1684091366;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TPaSN8j8Tte71Ibw03Nwg/bJ1T4n2RtGqmHptCINpCY=;
        b=RXlnHTqZIgBe0xFZ7XmOkya4xlPoDVuRJ/t4PewF+HIr9JZ0eobC4JJS5M6fNUZ4kc
         WsiHaIV9bxUv43KSG5P+DKhTTEc7UXBBLXQsnTuDbUvVdRw+rYbOIhZvEVbE48GxdANj
         e8PL5xqCLivlLJEH2qF0+StAWWvrLbKx5fKLqzQ/J4fSSXliodPNhmosr3i615hUM3vG
         xVtWJJDbxcnsHSG5sTlw59TYwyqAI7+nwSWPh+VRLciqF6wXMyyAHZojzhVuqgeAymCf
         HDcW+4mEb+PE8hVoEtKeWGl+Hz2qswrQatGtLWaEvDuxRSOqjttbVQ+erLJmKLjscx5U
         vOjw==
X-Gm-Message-State: AAQBX9fFlLoDwxvcY1GU1wldU8YgpLel5Xcz5D5K9MfCGhbQM+qnW59M
        M+81NkgEfGJFKA8dhc+LY7IWVghz3tI=
X-Google-Smtp-Source: AKy350ZmGftd9sN063rKsCG6oMEAwCkuRIEO/k/UXVnLyJq21Zg/RrLpvxmSN1cjWt3VLwiC/2FVAw==
X-Received: by 2002:a5d:570c:0:b0:2f2:7adf:3c67 with SMTP id a12-20020a5d570c000000b002f27adf3c67mr5313246wrv.61.1681499365582;
        Fri, 14 Apr 2023 12:09:25 -0700 (PDT)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d65c2000000b002ceacff44c7sm4119496wrw.83.2023.04.14.12.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 12:09:25 -0700 (PDT)
Message-ID: <d9aecd22-47af-c59a-5345-ecb416af83db@gmail.com>
Date:   Fri, 14 Apr 2023 21:09:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6] ip.7: Add "special and reserved addresses" section
Content-Language: en-US
To:     Seth David Schoen <schoen@loyalty.org>
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
References: <20230414184433.GA2557040@demorgan>
 <20230414184558.GB2557040@demorgan>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230414184558.GB2557040@demorgan>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------482Dq4jiSwqrjr1R9NKL51pW"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------482Dq4jiSwqrjr1R9NKL51pW
Content-Type: multipart/mixed; boundary="------------4OEGrm8LtK6uWpl90jPV7sm3";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Seth David Schoen <schoen@loyalty.org>
Cc: linux-man@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <d9aecd22-47af-c59a-5345-ecb416af83db@gmail.com>
Subject: Re: [PATCH v6] ip.7: Add "special and reserved addresses" section
References: <20230414184433.GA2557040@demorgan>
 <20230414184558.GB2557040@demorgan>
In-Reply-To: <20230414184558.GB2557040@demorgan>

--------------4OEGrm8LtK6uWpl90jPV7sm3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Seth,

On 4/14/23 20:45, Seth David Schoen wrote:
> Break out the discussion of special and reserved IPv4 addresses into
> a subsection, formatted as a pair of definition lists, and briefly
> describing three cases in which Linux no longer treats addresses
> specially, where other systems do or did.
>=20
> Also add a specific example to the NOTES paragraph that discourages
> the use of IP broadcasting, so people can more easily understand
> what they are supposed to do instead.
>=20
> Signed-off-by: Seth David Schoen <schoen@loyalty.org>
> Suggested-by: John Gilmore <gnu@toad.com>

Patch applied.

Thanks!

Alex

> ---
>  man7/ip.7 | 83 +++++++++++++++++++++++++++++++++++++++++++++++++------=

>  1 file changed, 75 insertions(+), 8 deletions(-)
>=20
> diff --git a/man7/ip.7 b/man7/ip.7
> index 6c50d0281..6f1ee4dbe 100644
> --- a/man7/ip.7
> +++ b/man7/ip.7
> @@ -237,19 +237,82 @@ In particular, this means that you need to call
>  on the number that is assigned to a port.
>  All address/port manipulation
>  functions in the standard library work in network byte order.
> -.PP
> +.SS Special and reserved addresses
>  There are several special addresses:
> -.B INADDR_LOOPBACK
> -(127.0.0.1)
> +.TP
> +.BR INADDR_LOOPBACK " (127.0.0.1)"
>  always refers to the local host via the loopback device;
> +.TP
> +.BR INADDR_ANY " (0.0.0.0)"
> +means any address for socket binding;
> +.TP
> +.BR INADDR_BROADCAST " (255.255.255.255)"
> +has the same effect on
> +.BR bind (2)
> +as
>  .B INADDR_ANY
> -(0.0.0.0)
> -means any address for binding;
> +for historical reasons.
> +A packet addressed to
>  .B INADDR_BROADCAST
> -(255.255.255.255)
> -means any host and has the same effect on bind as
> +through a socket which has
> +.B SO_BROADCAST
> +set will be broadcast to all hosts on the local network segment,
> +as long as the link is broadcast-capable.
> +
> +.TP
> +Highest-numbered address
> +.TQ
> +Lowest-numbered address
> +On any locally-attached non-point-to-point IP subnet
> +with a link type that supports broadcasts,
> +the highest-numbered address
> +(e.g., the .255 address on a subnet with netmask 255.255.255.0)
> +is designated as a broadcast address.
> +It cannot usefully be assigned to an individual interface,
> +and can only be addressed with a socket on which the
> +.B SO_BROADCAST
> +option has been set.
> +Internet standards have historically
> +also reserved the lowest-numbered address
> +(e.g., the .0 address on a subnet with netmask 255.255.255.0)
> +for broadcast, though they call it "obsolete" for this purpose.
> +(Some sources also refer to this as the "network address.")
> +Since Linux 5.14,
> +.\" commit 58fee5fc83658aaacf60246aeab738946a9ba516
> +it is treated as an ordinary unicast address
> +and can be assigned to an interface.
> +
> +.PP
> +Internet standards have traditionally also reserved various addresses
> +for particular uses, though Linux no longer treats
> +some of these specially.
> +
> +.TP
> +[0.0.0.1, 0.255.255.255]
> +.TQ
> +[240.0.0.0, 255.255.255.254]
> +Addresses in these ranges (0/8 and 240/4) are reserved globally.
> +Since Linux 5.3
> +.\" commit 96125bf9985a75db00496dd2bc9249b777d2b19b
> +and Linux 2.6.25,
> +.\" commit 1e637c74b0f84eaca02b914c0b8c6f67276e9697
> +respectively,
> +the 0/8 and 240/4 addresses, other than
>  .B INADDR_ANY
> -for historical reasons.
> +and
> +.BR INADDR_BROADCAST ,
> +are treated as ordinary unicast addresses.
> +Systems that follow the traditional behaviors may not
> +interoperate with these historically reserved addresses.
> +.TP
> +[127.0.0.1, 127.255.255.254]
> +Addresses in this range (127/8) are treated as loopback addresses
> +akin to the standardized local loopback address
> +.B INADDR_LOOPBACK
> +(127.0.0.1);
> +.TP
> +[224.0.0.0, 239.255.255.255]
> +Addresses in this range (224/4) are dedicated to multicast use.
>  .SS Socket options
>  IP supports some protocol-specific socket options that can be set with=

>  .BR setsockopt (2)
> @@ -1343,6 +1406,10 @@ with careless broadcasts.
>  For new application protocols
>  it is better to use a multicast group instead of broadcasting.
>  Broadcasting is discouraged.
> +See RFC 6762 for an example of a protocol (mDNS)
> +using the more modern multicast approach
> +to communicating with an open-ended
> +group of hosts on the local network.
>  .PP
>  Some other BSD sockets implementations provide
>  .B IP_RCVDSTADDR

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------4OEGrm8LtK6uWpl90jPV7sm3--

--------------482Dq4jiSwqrjr1R9NKL51pW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmQ5pN4ACgkQnowa+77/
2zLrrw//UbdxNe2Jsgq9xR6PBut1DLAVjX0vs+cZ8B+7j6IsJHIYXrx2gzTKnG9H
Wt3LSKTDoGbgv2iNfoRiRZrXsDPGXfD0BR5uQoKYTHvDnL56aJ7B7byvWVBTS5Y5
f+X77OsIYD3PaGl3jgyB2FZbOKKzHiXyK/aH5Fk4dTAx1VtEdWBVDUuwXY8IYJrQ
lFOy8Qvuuad/QBsE4lPIk+JTxDuz3/ZyQvFbGQJAp+B2HyAJznRKgsMgdOM4jFY6
b9UxftATSYzm/wv8Whzbg93TbOrS0T6vRs5SqsRGMUKCSqeq1D7+e4TyJWx5IieB
UB0C4QSlVaMum5LdX7lVjKLas+yCu2L5NQdZ9ByzAtTXR7ISc/eyvYQoLzPj7ccL
6AAkLkmzKRPS7kVzHs9FiNnSyfWoce2QJuVzAxAGScWNTiooVMe7gy3y8kCSvyV+
85OCIX3479WpBSegbMsSZUOtb9uxps1Zk0B89qo3x85POw8s9V+6xw1wnL06EOd9
ZgAwG/6mYZzuGrYjPt+CQCNxh1EGrwjcRmEnaPL116Zd07UXSHdExUFqA6hW9/3h
uK4/G0mm3uAvWbdIhW2AkvfLVYUqn7MrOGyEWyspr7wRVt8vs4OB4Y+mVL3EEgUY
UwqBhszhvGqffCyokbKEfbDpsHpdS32U1mu2Qg0jvCpS82dVrWo=
=LuDg
-----END PGP SIGNATURE-----

--------------482Dq4jiSwqrjr1R9NKL51pW--
