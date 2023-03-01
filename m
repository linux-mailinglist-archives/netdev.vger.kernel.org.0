Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4456A7638
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCAVf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 16:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCAVf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 16:35:57 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D3231E3;
        Wed,  1 Mar 2023 13:35:55 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k37so9526780wms.0;
        Wed, 01 Mar 2023 13:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DeOoRTCEVkow8hedgErTLZBFh/zEnfd1ox1XO8mCE8=;
        b=cul+e1AFLQrQoQAweKbgk5aAOAUzQeL+jJ1yEYOngbQGrh1g6Wab277fxqLY7Fyq0g
         8aaHPBMk6gLgxOio+YXpducjA1vyncSl20dNKmYkWcXmf/Y4XdXJ6Gytp300CpABwxdl
         3o46+PQgVigD6HI30736nU1hN8mLDSEqxRNKufJhuW3tybGFKB8gBtff/JyyztmOllQO
         GVFJ55OcQ3UHW9P6//pYqqYnhGLexqyF1PPuhg4Wm/41uJ6Bqt5J3adhGdQPe7QNPHBl
         kO6jtyU0yLPCpYX+8waj1n8zK1YJxvN096UySJLKURp3uD50/ZLTz5XHCk/bLrBtNPdP
         46Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1DeOoRTCEVkow8hedgErTLZBFh/zEnfd1ox1XO8mCE8=;
        b=OIqYs9KZ3ncZan/gT9s3iL4U4lyIqyO3eRvnf+kwNtlQXfTyODTAoivFKQLJkUhdR2
         HF+ybIoRVB7ZX4dG7NJykTmQZ3emoWiKsBr9P03FqmnIn7C0sc2s2t6gXpzYD4JfsI9p
         IkneRARvF9bfmacndogttXWoJPOwMa+dFAOdLO7aTBZnLNs8vTiYTtCU8pxOShhFQoGV
         r7+Cwn6I3YTaZF/68mkCJGsAIpartGI5lIo4pdUBDjACAkczFGCB2A81pQ5TqKvHZChV
         XWv62l2nI2ckb6YkVwpVDvDHBbR3QBaKqCBnBjxkkQCPAHc3UpvY/2pr3u1JgxvlpPSl
         oO2A==
X-Gm-Message-State: AO0yUKXtPbvg57fe+JicE19ZOLYIt59Q5IovSKoeFANvBYSzCuvy1ZwK
        7lqeYtBC9poKScCtDsRRhH4OjDVRJ38=
X-Google-Smtp-Source: AK7set/VLJdFJWrMyjWAMWsukxXj5M4Xim1HsdNEtiLlWz5MwOvyp7Men9NowVhOVOaNY35riQ/zaQ==
X-Received: by 2002:a1c:cc0a:0:b0:3ea:ea6b:f9ad with SMTP id h10-20020a1ccc0a000000b003eaea6bf9admr5964125wmb.31.1677706554395;
        Wed, 01 Mar 2023 13:35:54 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id hn6-20020a05600ca38600b003e22508a343sm747937wmb.12.2023.03.01.13.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 13:35:53 -0800 (PST)
Message-ID: <7d4571c6-b708-c63b-5a5c-2b2d4f963914@gmail.com>
Date:   Wed, 1 Mar 2023 22:35:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH manpages 1/2] udp.7: add UDP_SEGMENT
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org
Cc:     pabeni@redhat.comm, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
References: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AAfoGPbn0liB40h1p45O0na1"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AAfoGPbn0liB40h1p45O0na1
Content-Type: multipart/mixed; boundary="------------byzYXQpnh2SzIh0WsWOLGXr0";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 linux-man@vger.kernel.org
Cc: pabeni@redhat.comm, netdev@vger.kernel.org,
 Willem de Bruijn <willemb@google.com>
Message-ID: <7d4571c6-b708-c63b-5a5c-2b2d4f963914@gmail.com>
Subject: Re: [PATCH manpages 1/2] udp.7: add UDP_SEGMENT
References: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com>

--------------byzYXQpnh2SzIh0WsWOLGXr0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Willem,

On 3/1/23 22:11, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
>=20
> UDP_SEGMENT was added in commit bec1f6f69736
> ("udp: generate gso with UDP_SEGMENT")
>=20
>     $ git describe --contains bec1f6f69736
>     linux/v4.18-rc1~114^2~377^2~8
>=20
> Kernel source has example code in tools/testing/selftests/net/udpgso*
>=20
> Per https://www.kernel.org/doc/man-pages/patches.html,
> "Describe how you obtained the information in your patch":
> I am the author of the above commit and follow-ons.
>=20
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  man7/udp.7 | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/man7/udp.7 b/man7/udp.7
> index 5822bc551fdf..ec16306df605 100644
> --- a/man7/udp.7
> +++ b/man7/udp.7
> @@ -204,6 +204,31 @@ portable.
>  .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
>  .\"     UDP_ENCAP_L2TPINUDP rfc2661
>  .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Lin=
ux 3.16
> +.TP
> +.BR UDP_SEGMENT " (since Linux 4.18)"
> +Enables UDP segmentation offload.
> +Segmentation offload reduces
> +.BR send(2)
> +cost by transferring multiple datagrams worth of data as a single
> +large packet through the kernel transmit path, even when that

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


> +exceeds MTU.
> +As late as possible, the large packet is split by segment size into a
> +series of datagrams.
> +This segmentation offload step is deferred to hardware if supported,
> +else performed in software.
> +This option takes a value between 0 and USHRT_MAX that sets the
> +segment size: the size of datagram payload, excluding the UDP header.
> +The segment size must be chosen such that at most 64 datagrams are
> +sent in a single call and that the datagrams after segmentation meet
> +the same MTU rules that apply to datagrams sent without this option.
> +Segmentation offload depends on checksum offload, as datagram
> +checksums are computed after segmentation.
> +The option may also be set for individual
> +.BR sendmsg(2)

There should be a space between the bold part and the roman part:

=2EBR foo (2)

Otherwise, it all gets printed in bold.

Cheers,

Alex

> +calls by passing it as a
> +.BR cmsg(7).
> +A value of zero disables the feature.
> +This option should not be used in code intended to be portable.
>  .SS Ioctls
>  These ioctls can be accessed using
>  .BR ioctl (2).

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------byzYXQpnh2SzIh0WsWOLGXr0--

--------------AAfoGPbn0liB40h1p45O0na1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmP/xTgACgkQnowa+77/
2zLJkA/5ASuc7CJszey1/NyCp+x+lnfm26j4W8I2LQBflg7yjIA4SEIVolI18Sab
PSo52rDMm5qCq6PQqMmbqGsmbRlr5cmMJCDe74azJfuNrr+GtrN1xc4pPXx6Qt4Q
r2PW8bcn2bChYNtY/aIFKhCnyN46HgnFUsSAOPOD/jl2O05mBGtv9omQACE/aMRm
0zd6Kg2E4HMQXt9LzoMAzJbmFhiKBFBEFXbTr7Ge8R3ycuowIvpZAUzPz+2kQBCx
xCwTX42C7nav9ljnATzmDN6Vz5Eu4FDY3FR/bUSSoPe81+4LiWm6rG2nDoZQZ5Ln
QIGO2KdeBii/3M9vPbxACTiQ9Ria8AxIN4JGqkJlYo9DvAosTfgKunxpMfuejWVF
HS+oRG1xtqMZrgmMeG5lIv7u9S7CaHotERACF7el0Iwd5qEPkryqcq/HvREn1b+R
kw3MxjNSHNAGd0yvOCJZ2FVVEP8WtHY6y7gihe+HykCDiyGSdmJ8dXL5L3+DAEDC
y8yzL7+FsuyGlQfOZNDgLXjeg5q4i0x1CJlZYthLuUclM92Bm1LsflUUWCBr+bLs
Ya5f3G1Kw36U/CPVqIv2tdA7Jvypsbymi7kB7/3NWgSBvyjlGPvPlQZxAk0dafXT
z+KIcRtWDGdlLdvCsK6vHHJHo0HFKP/6gLbyvQQDIFgvcpcejdg=
=dkNP
-----END PGP SIGNATURE-----

--------------AAfoGPbn0liB40h1p45O0na1--
