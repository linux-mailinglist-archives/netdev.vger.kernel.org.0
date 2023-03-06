Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B936AC17D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjCFNiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCFNiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:38:04 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348768685;
        Mon,  6 Mar 2023 05:38:03 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l1so8798587wry.12;
        Mon, 06 Mar 2023 05:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678109881;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC2BDk0t1UFRGr/Jhnehs62wFldMDAYr2fKYa8X3+VE=;
        b=VSBeNMTxsp1zuGfgKOhdXwpInqAnoPZdyklKuCzbvp6KofssUqBL+sl0kLAnFE8fTc
         LcWSgPLOPWbPxlOuP22K6AULvEeskitleEYu5oFotpkdd77vmCGcxgrhQ3WIAfB0olnV
         gMTOFwoB9WqziIrrigTZQH6V46/XTYoCIVl/LH2mhS5Po1qbUorhmzf/vPALt/esSTeM
         4OJ6BiTwlbiic8fsaK4kr5UCk4NmsXuKiCKnZJHRvh2MsMg29Ib9jBkPyM/GZHWOVpET
         JYV4S2yWp731E4TCKPAa9MyjjlzWafR8xUxEi/blEFJywKqSa1aUgwx0W+J+01fUcH8o
         lDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678109881;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WC2BDk0t1UFRGr/Jhnehs62wFldMDAYr2fKYa8X3+VE=;
        b=K0h1p2h5s6xMzaqbAOWWAH5poRbI2VQLq4yxCENUYKJMNgtCQgU+fEbx/ik2WTyA3R
         CcucaZJf/jA3NB7ta34ClO6TNGoumAB6YRm3eb4TXylpgeBVBwkAv0Rz4x1WayL68R7V
         FwnaXKV2wUf0RZQwWoI5/JIbGhs+RdidYgoBVQBkceUBrjFJtdlKeApSCpzzvRQAXsWc
         cHzPuNk74NaXl4qTtnGyLGCoZnFF9GZtIXUsF8Uamo06ttqgWX7I9/aB9IN4K7xPCH1H
         Yof5QJnDrKu2yf1/g3vyeuH5GF4j9U4p6B2o90YdcPDSjUsbXlaNDP22Zi+WwBU4rDlE
         g2aQ==
X-Gm-Message-State: AO0yUKVMOwjlvhE0xiLWltm+37co3rpp6xWzeHZyVLs3wW0Mjhd+42RM
        R9ZldrLTu1vCjB0sJQKW59s=
X-Google-Smtp-Source: AK7set+XOuRRiEW4odHhDwEzQPC4LcVl9G9IQgGknKn3TuQso15mokiEp9wgWz6gyOfgRIY8PRUfQQ==
X-Received: by 2002:adf:cc86:0:b0:2c7:a3b:4e76 with SMTP id p6-20020adfcc86000000b002c70a3b4e76mr8749896wrj.6.1678109881585;
        Mon, 06 Mar 2023 05:38:01 -0800 (PST)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id a7-20020a5d4d47000000b002c5706f7c6dsm9917321wru.94.2023.03.06.05.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:38:01 -0800 (PST)
Message-ID: <cf3aa207-7423-f04a-ad02-4eda85f58301@gmail.com>
Date:   Mon, 6 Mar 2023 14:37:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH manpages v2 2/2] udp.7: add UDP_GRO
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org
Cc:     mtk.manpages@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Simon Horman <simon.horman@corigine.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------sAQXjHV2hMfGm8oE6OL5pL8Z"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------sAQXjHV2hMfGm8oE6OL5pL8Z
Content-Type: multipart/mixed; boundary="------------eX1P2I0UECjx6v2ZthatbZ7F";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 linux-man@vger.kernel.org
Cc: mtk.manpages@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
 Willem de Bruijn <willemb@google.com>,
 Simon Horman <simon.horman@corigine.com>
Message-ID: <cf3aa207-7423-f04a-ad02-4eda85f58301@gmail.com>
Subject: Re: [PATCH manpages v2 2/2] udp.7: add UDP_GRO
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>

--------------eX1P2I0UECjx6v2ZthatbZ7F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Willem,=20

On 3/2/23 16:48, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
>=20
> UDP_GRO was added in commit e20cf8d3f1f7
> ("udp: implement GRO for plain UDP sockets.")
>=20
>     $ git describe --contains e20cf8d3f1f7
>     linux/v5.0-rc1~129^2~379^2~8
>=20
> Kernel source has example code in tools/testing/selftests/net/udpgro*
>=20
> Per https://www.kernel.org/doc/man-pages/patches.html,
> "Describe how you obtained the information in your patch":
> I reviewed the relevant UDP_GRO patches.
>=20
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Patch applied.  BTW, it was cmsg(3), not (7) :)

Cheers,

Alex

>=20
> ---
>=20
> Changes v1->v2
>   - semantic newlines: also break on comma
>   - remove bold: section number following function name
> ---
>  man7/udp.7 | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/man7/udp.7 b/man7/udp.7
> index 6646c1e96bb0..a350a40da340 100644
> --- a/man7/udp.7
> +++ b/man7/udp.7
> @@ -232,6 +232,20 @@ calls by passing it as a
>  .BR cmsg (7).
>  A value of zero disables the feature.
>  This option should not be used in code intended to be portable.
> +.TP
> +.BR UDP_GRO " (since Linux 5.0)"
> +Enables UDP receive offload.
> +If enabled,
> +the socket may receive multiple datagrams worth of data as a single la=
rge
> +buffer,
> +together with a
> +.BR cmsg (7)
> +that holds the segment size.
> +This option is the inverse of segmentation offload.
> +It reduces receive cost by handling multiple datagrams worth of data
> +as a single large packet in the kernel receive path,
> +even when that exceeds MTU.
> +This option should not be used in code intended to be portable.
>  .SS Ioctls
>  These ioctls can be accessed using
>  .BR ioctl (2).

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------eX1P2I0UECjx6v2ZthatbZ7F--

--------------sAQXjHV2hMfGm8oE6OL5pL8Z
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmQF7LcACgkQnowa+77/
2zJXhxAAgjDvX9hFPmk1MGQ/tcaioZLs8JCZDHTRNM9gQtQkJ8WH28+Ojb7lgBev
KtmcX8ORO8vzfuv9fsrfcKqU4FjVUoV0e4pIBNdP05YjnPRqXSpSWQWLMzLV11Li
7eEdkSl/a4Nrge/OM01UXXe3ypiogGea+PQ9I3sU1gMYnturSMMPTOAjR68HOxDE
FvNhl+LV4YHmDCnSqvhggXZqFg+ch3b96lj65HZOcHVeM7f01RHPWeBMqn9pLldC
oIGJsJd6oQ0Ck92qs1tf4z+r1iwBUSOhp0GIRDAryFJUCeZpOje2ptMjCzhfFquD
hg8jJNeuLF3UWLJRDH5r/taswhKbKgCtVzqQU6889CTikJYKwk0D1hsnc4Ra02SW
m+djVvXI2sfYENaz4wHiRhqu+39uenV/PXYLGqbRJimFi+jg37X6txf/uz7Dz152
hJSIMyq+DN/twdVFcBucNFry7rimrqMEiwsk4Gp8u/M45XN/IzN9FWgLjW9hI+Yh
C6sixXJgqT/nrmGOXu9TVa5bQkgcKGl2Zh5i0fc6WoGWhvX8HHf5RxIGY+ZWkfOe
hVS1i7S4xu3u5WPHkwtmdqClO6XSQCu2FM3tkQqBIAh0k2izAWrQZhmOw/2wmQZk
EKMO1IPkfEQ0XWbjk9+P8LSFGts6zQgW4IEdiYiDXsBoYdZuDvE=
=zNgt
-----END PGP SIGNATURE-----

--------------sAQXjHV2hMfGm8oE6OL5pL8Z--
