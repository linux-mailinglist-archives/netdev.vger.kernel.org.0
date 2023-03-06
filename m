Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7D96AC0EB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjCFN3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjCFN3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:29:48 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4B323C67;
        Mon,  6 Mar 2023 05:29:47 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j3so5648486wms.2;
        Mon, 06 Mar 2023 05:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678109385;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+A6+GVBnqurJN8jDNHasURTm7oa9E+9ptvyGimTjoCw=;
        b=qOIWW5vrtgdybPxQwC9Rsn6WmDV6ZIP6L0a1pkWXd3ORQzV0BgVeBZVTGYY+5b0A/n
         SJogArWu5ZM4TUpRXPo393KEUwVzgAqYpLxK5iXFhNf1A+FJu4c4Valp9sw3BICyCPc5
         YvnTz5KXaCxTUW6EWriar6KSwNqyG0302FvGxCTn8WKBYaGBEiSEz404HNEjHq7pglHw
         iMamKVAWSAA1tkZUVpIBQ4ZKNS/mPsPdHj1/ML6LhnH8H6t3AD7dvk4a9GOVVBiTGZFy
         abTVdb7gKU9HYkwoG76r465SvWyo6I/FsrOIJsyjpCO7jfqkw3SHowB0RVptfgTAHk3z
         yQyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678109385;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+A6+GVBnqurJN8jDNHasURTm7oa9E+9ptvyGimTjoCw=;
        b=joDDhSKU6PrPHzPkjhcpunXxjHnbqOGOKQXcL/ZuWwEFXo8rZkRlfb5wbw7pcUzXB4
         cTQUjE1CG2ReMdK6umHiB8eOGW9YzmzW+VWYttXggHe7ROMtoVuQ06rJJIE54PDMrXJU
         3pjICiKsSywOhPfDC8LUvcnazJLl7/GYxavcDe1gcJxy3cakSLmbNFj+IYNKtnZWQ1fp
         FGQl7xKSSdsAtGvFDFfxpw7yPHO5o0Cd9bbC0GlVRoK8LqV4YDSpZRBHutrousmWNm8y
         GfzmCkpmxunBxqPENXqTSmh9im61k4vcLZkyhFtxlFqpUBUE7b33cTzNgWmCb7otog8c
         0Qcg==
X-Gm-Message-State: AO0yUKVRe/EKu73zwxRby8G/rbGUF+IjE8GAbiw9Ub8uucQw7XZ0Muiw
        nKEvyekDPLFbtqDAb847p5hAPMe5Bi8=
X-Google-Smtp-Source: AK7set9uYv50mhFRczx0Atjb1uklf/2k+ryDYsfzAGWRT/xZytGBjJF5h4TMjEVPiAR05M6O/BL0yg==
X-Received: by 2002:a05:600c:190b:b0:3eb:38e6:f64f with SMTP id j11-20020a05600c190b00b003eb38e6f64fmr9211182wmq.8.1678109385595;
        Mon, 06 Mar 2023 05:29:45 -0800 (PST)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id f13-20020a7bcd0d000000b003db01178b62sm13805703wmj.40.2023.03.06.05.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:29:45 -0800 (PST)
Message-ID: <467173ec-1ea5-9501-fa3d-369814e61f38@gmail.com>
Date:   Mon, 6 Mar 2023 14:29:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Simon Horman <simon.horman@corigine.com>,
        linux-man@vger.kernel.org
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eSZ0q03qftXHMHLvZrsEwfjw"
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
--------------eSZ0q03qftXHMHLvZrsEwfjw
Content-Type: multipart/mixed; boundary="------------8QkuRuLnfg0eth6tc62xu62u";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: pabeni@redhat.com, netdev@vger.kernel.org,
 Willem de Bruijn <willemb@google.com>,
 Simon Horman <simon.horman@corigine.com>, linux-man@vger.kernel.org
Message-ID: <467173ec-1ea5-9501-fa3d-369814e61f38@gmail.com>
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>

--------------8QkuRuLnfg0eth6tc62xu62u
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Willem,

On 3/2/23 16:48, Willem de Bruijn wrote:
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

Patch applied, with some minor tweaks and Simon's review tag.

Cheers,

Alex

>=20
> ---
>=20
> Changes v1->v2
>   - semantic newlines: also break on comma and colon
>   - remove bold: section number following function name
>   - add bold: special macro USHRT_MAX
> ---
>  man7/udp.7 | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>=20
> diff --git a/man7/udp.7 b/man7/udp.7
> index 5822bc551fdf..6646c1e96bb0 100644
> --- a/man7/udp.7
> +++ b/man7/udp.7
> @@ -204,6 +204,34 @@ portable.
>  .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
>  .\"     UDP_ENCAP_L2TPINUDP rfc2661
>  .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Lin=
ux 3.16
> +.TP
> +.BR UDP_SEGMENT " (since Linux 4.18)"
> +Enables UDP segmentation offload.
> +Segmentation offload reduces
> +.BR send (2)
> +cost by transferring multiple datagrams worth of data as a single larg=
e
> +packet through the kernel transmit path,
> +even when that exceeds MTU.
> +As late as possible,
> +the large packet is split by segment size into a series of datagrams.
> +This segmentation offload step is deferred to hardware if supported,
> +else performed in software.
> +This option takes a value between 0 and
> +.BR USHRT_MAX
> +that sets the segment size:
> +the size of datagram payload,
> +excluding the UDP header.
> +The segment size must be chosen such that at most 64 datagrams are sen=
t in
> +a single call and that the datagrams after segmentation meet the same =
MTU
> +rules that apply to datagrams sent without this option.
> +Segmentation offload depends on checksum offload,
> +as datagram checksums are computed after segmentation.
> +The option may also be set for individual
> +.BR sendmsg (2)
> +calls by passing it as a
> +.BR cmsg (7).
> +A value of zero disables the feature.
> +This option should not be used in code intended to be portable.
>  .SS Ioctls
>  These ioctls can be accessed using
>  .BR ioctl (2).

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------8QkuRuLnfg0eth6tc62xu62u--

--------------eSZ0q03qftXHMHLvZrsEwfjw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmQF6rwACgkQnowa+77/
2zIgQQ/9GY1u3PY3MEo4N8uzOIeD2GDpcCojc3p1gmKDbcv037+f+YymZoKRyVhr
yECorWAvEnLMYMHAtiUrTtOIhWQk3rSc5Ay3YeqV+tj/Qz0tvmtz8mzb0NRpB/5V
oIGhEv5H1/g3fyJjhhbXQEnD0Bpf3faleMzPHVmpJJuKL80epTIb6bH/mwL/DGeZ
FMcmOvCZ1zryRa8Kr//yl8GoVqdgRHS3Xm+9efWCmXbAkA0miGlcbhmVUA2rws6s
ew5fsW5xqG1PUi0o51mVFW3rDubKUxGAIFUZ+be57SDBKFKAuZPuTlP40gZsJbtH
9SHQIUXnTMuGMZFO5FPnkge10rY9aTZvCRwQU6Onz4uUY7S+hJK9KNejo6pExsVk
1di1prsWK2kuM+NAw8lvPK4+PmvK6plGCfBkft+gdDlqxDsILY2t5Xt8lkgW65OW
8QuMgepfaOPpuKZaobRy9OV7Xxp1mQyVk4pY5pIwb0dMZhUt1xfe8mKHxmCcpCpR
SWd717uLh6iGuVLsvnRcNeDJSanl7xDRg5cEcZ5vm4R+1p10Yop9B1Zm11sL6FoA
iKCX36IjHjw2p0uiIUFEqdmtPNWFGJl4vN0KW9HRgz/17eBjlFSgpzONBl2t5bjQ
idXLL4MwCPopHIKaS8/hhwW3Lwg5Ujy/FvJ0f3rvjXChuxExcPI=
=j4CH
-----END PGP SIGNATURE-----

--------------eSZ0q03qftXHMHLvZrsEwfjw--
