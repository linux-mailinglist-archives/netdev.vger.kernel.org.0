Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4BA2FDFEC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 04:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404617AbhATXzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403961AbhATXV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 18:21:57 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096A3C061799
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:36:17 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id o13so36387385lfr.3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zh8A37CX/yeW023ifjqcf3kYsgAXQRkXtksns1PdcI8=;
        b=OwWY2znojlMll1ePcUe+Wwe+TZ77kzwL0EDAWr2h7KMopAGkL/BtWTJoYANK3X1lOV
         DEkJHip5r/G8ngXlAQhNfHnQ+WtschniK6GstfzsAp4L4SWb6s8wt/Opsfg6sMDJj6ek
         bGX2VWSBOvv8Rqz4FEOYGX0+KXZxVRg8gdoVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zh8A37CX/yeW023ifjqcf3kYsgAXQRkXtksns1PdcI8=;
        b=gSOkMmv08l5Qsor0QX7B2Bo4yOPnayynLIM5mteXPYadGcKfapd5FSaUYfwmuRakww
         Mkxoo0d5v8+yDQNhTKmN32t/9k4BcDwNJcIZMMgXbzeQKWUkARdB7R2HGrR3SydHgkg/
         rH+aUn70oJNuPTlRC1gwbK71eG0RfT4mBwHubXMYsY/kN4Robk19g4GzP1NpbJb5csES
         EQoYM2EXDLGAHMcZp/kWfiWX8jEuY9mLj0I6XZdAqpVhoa39DBiDHZfTvmiwCbPYAqBv
         AOOjIBhmbYSkxNg3E+TcFsjt0t1Y94kiVRDHtAbyDGm4XTOAyeKtSzG8X9e2Cn6+QrZQ
         lwmg==
X-Gm-Message-State: AOAM533n2Q2RPGiZsAVxbF/qprFBzMIlUTFvCIrRu3JX4anKRyBe/wI6
        3CpColcEHmZPt3fsKBbkp7BfgbmuzBCx+pMjd66Ahw==
X-Google-Smtp-Source: ABdhPJz7ZeElaAeP19itwfrJemifWqCYRhI1IB3zTRuefLiBUeSYLE2CMdN9jxXISjYTiUrhk4ayHSZeNvjOdnSeOxM=
X-Received: by 2002:ac2:4f88:: with SMTP id z8mr4925673lfs.141.1611182175410;
 Wed, 20 Jan 2021 14:36:15 -0800 (PST)
MIME-Version: 1.0
References: <20210120093713.4000363-1-danieller@nvidia.com> <20210120093713.4000363-2-danieller@nvidia.com>
In-Reply-To: <20210120093713.4000363-2-danieller@nvidia.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 20 Jan 2021 14:35:39 -0800
Message-ID: <CAKOOJTxG2_fV3kSuTpeVLOwSXBug==zaEzQVnn6O3Tsy=Hh9AQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/7] ethtool: Extend link modes settings uAPI
 with lanes
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        Michal Kubecek <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000040e99c05b95c95eb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000040e99c05b95c95eb
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 20, 2021 at 3:21 AM Danielle Ratson <danieller@nvidia.com> wrote:

> -#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
> +#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
>         [ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
>                 .speed  = SPEED_ ## _speed, \
> +               .lanes  = _lanes, \
>                 .duplex = __DUPLEX_ ## _duplex \
>         }

What about:

#define __DECLARE_LINK_MODE_LANES(_type, _lanes)        \
static const u32 __LINK_MODE_LANES_ ## _type = _lanes;

#define __DECLARE_LINK_MODE_LANES_ALL(_type)            \
__DECLARE_LINK_MODE_LANES(_type, 1)             \
__DECLARE_LINK_MODE_LANES(_type ## 2, 2)        \
__DECLARE_LINK_MODE_LANES(_type ## 4, 4)        \
__DECLARE_LINK_MODE_LANES(_type ## 8, 8)

__DECLARE_LINK_MODE_LANES_ALL(CR)
__DECLARE_LINK_MODE_LANES_ALL(DR)
__DECLARE_LINK_MODE_LANES_ALL(ER)
__DECLARE_LINK_MODE_LANES_ALL(KR)
__DECLARE_LINK_MODE_LANES(KX, 1)
__DECLARE_LINK_MODE_LANES(KX4, 4)
__DECLARE_LINK_MODE_LANES_ALL(LR)
__DECLARE_LINK_MODE_LANES(LR_ER_FR, 1)
__DECLARE_LINK_MODE_LANES(LR2_ER2_FR2, 2)
__DECLARE_LINK_MODE_LANES(LR4_ER4_FR4, 4)
__DECLARE_LINK_MODE_LANES(LR8_ER8_FR8, 8)
__DECLARE_LINK_MODE_LANES(LRM, 1)
__DECLARE_LINK_MODE_LANES(MLD2, 2);
__DECLARE_LINK_MODE_LANES_ALL(SR);
__DECLARE_LINK_MODE_LANES(T, 1)
__DECLARE_LINK_MODE_LANES(X, 1)

#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)
         [ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
                 .speed  = SPEED_ ## _speed, \
                 .lanes  = __LINK_MODE_LANES ## _type, \

instead of specifying lanes for each link mode defined below?

Regards,
Edwin Peer

>  static const struct link_mode_info link_mode_params[] = {
> -       __DEFINE_LINK_MODE_PARAMS(10, T, Half),
> -       __DEFINE_LINK_MODE_PARAMS(10, T, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100, T, Half),
> -       __DEFINE_LINK_MODE_PARAMS(100, T, Full),
> -       __DEFINE_LINK_MODE_PARAMS(1000, T, Half),
> -       __DEFINE_LINK_MODE_PARAMS(1000, T, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
> +       __DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
> +       __DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
> +       __DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
>         __DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
>         __DEFINE_SPECIAL_MODE_PARAMS(TP),
>         __DEFINE_SPECIAL_MODE_PARAMS(AUI),
>         __DEFINE_SPECIAL_MODE_PARAMS(MII),
>         __DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
>         __DEFINE_SPECIAL_MODE_PARAMS(BNC),
> -       __DEFINE_LINK_MODE_PARAMS(10000, T, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
>         __DEFINE_SPECIAL_MODE_PARAMS(Pause),
>         __DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
> -       __DEFINE_LINK_MODE_PARAMS(2500, X, Full),
> +       __DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
>         __DEFINE_SPECIAL_MODE_PARAMS(Backplane),
> -       __DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
> +       __DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
>         [ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
>                 .speed  = SPEED_10000,
>                 .duplex = DUPLEX_FULL,
>         },
> -       __DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(1000, X, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
> -       __DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
> -       __DEFINE_LINK_MODE_PARAMS(2500, T, Full),
> -       __DEFINE_LINK_MODE_PARAMS(5000, T, Full),
> +       __DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
>         __DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
>         __DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
>         __DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
> -       __DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100, T1, Full),
> -       __DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
>         __DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
> -       __DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
> -       __DEFINE_LINK_MODE_PARAMS(100, FX, Half),
> -       __DEFINE_LINK_MODE_PARAMS(100, FX, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
> +       __DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
> +       __DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
>  };

--00000000000040e99c05b95c95eb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg8UO7J3s83lYcd8cb4b4V
KUGeMDnCficj2cXsPh5NaEgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIwMjIzNjE1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADVYDG9XuLpmo2fKCojSQOPzhul8ULku/f4cPcB2
rQ6k9xmsTGp6bCrcr5SH8LjYxy1Um1k7svrF9Ao1/okOI/5DkSbsfSBma6m2CEv1IMWH2aaGg4yf
2yLomjcPT8fYpy7iVR7Jn3GaP2zAyCgrKF7P7R+rjLJ2W7evAmTmOEvyzlL9y/7bv/2BJ+4AiPSn
+Yszvwas7s8EdtCH+KMWkPlxXW3RHWAkmbty8duuAthDDM7j+sKbb8Ek32aRS9awIK5OGotkYnti
o7s8b0VwV3aFMY9ZFjwZ9+ysU3QwugVlhKQPjvXMCI1R0l2+vLhv2okVWm8qPUntf/YviviaVd4=
--00000000000040e99c05b95c95eb--
