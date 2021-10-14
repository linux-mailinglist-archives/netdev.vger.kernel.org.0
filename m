Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA4D42DA89
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJNNgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 09:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhJNNf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 09:35:59 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD91C061762
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 06:33:54 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id cv2so3722502qvb.5
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6BcmqvnYViEIh48To1seJSXIijn4d6ZSZ7k3f+Yktoo=;
        b=WyR7VMh0hbMsAtleInHlYp/PyzHfcoWba5Lblnza+Ml+5P7u5g4w/o2lKo0X4Wq0BN
         qLDsAYwzNK72LEcoabc6Fdpv08rdjj2b2vzCA0a4BqTXEBAEX4b/7aXxpslEYSTX8DXo
         7CEVgpzsIwww1pqHMh6nl/0NwzWLRl4x+jXI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6BcmqvnYViEIh48To1seJSXIijn4d6ZSZ7k3f+Yktoo=;
        b=BYFhGGcIHls8cg5Y/0vY1fd/m/STk5ov7RFIq6UROyXIew4d9Zc8xa8fYwFXyR7RLn
         OkHouZSYRBtiGGQvtmp3FNYncudLQ8R5icsem52t/JFg/hFZTUOtsajs9tK58ixzuEBt
         V7emAODhib5bPln7K2xfv0nq4rd/Mi8iHPmsRCLKyH79XI9GLjfvln9Ygdh462B4XnmI
         tbsTpNrrpoFYeUZJ55fEKBdcxvvAdNdBlCsTSy835PEUsV3BJnlpOLNdXaghr85uc3k0
         WksfDWZHc21Mlc0Y/cVV2fuFM0dm7p/fLAeyWE4B8YLwYeZBzZNfN5KChCMNSGipb1/R
         ko0w==
X-Gm-Message-State: AOAM532SvXn1FeC472eOUZlwiNyFIZslU60cAiTE2D/5WnYRlqWtJyXb
        Ts8sPvKeERjPBOf0bmp+5P2BNA==
X-Google-Smtp-Source: ABdhPJw5LsNyTAGPpiW66Ow6a1r04mwufMVin71Cm8de/KShizf497R610ZNXNOKwBKSNIfUWlFr1w==
X-Received: by 2002:a05:6214:506:: with SMTP id v6mr5264835qvw.52.1634218428689;
        Thu, 14 Oct 2021 06:33:48 -0700 (PDT)
Received: from bill-the-cat (2603-6081-7b01-cbda-0d65-5385-0e85-d408.res6.spectrum.com. [2603:6081:7b01:cbda:d65:5385:e85:d408])
        by smtp.gmail.com with ESMTPSA id p19sm1431432qtk.20.2021.10.14.06.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:33:47 -0700 (PDT)
Date:   Thu, 14 Oct 2021 09:33:43 -0400
From:   Tom Rini <trini@konsulko.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        U-Boot Mailing List <u-boot@lists.denx.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
Message-ID: <20211014133343.GA7964@bill-the-cat>
References: <20211013232048.16559-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="19yxUJAiKHVhK1FQ"
Content-Disposition: inline
In-Reply-To: <20211013232048.16559-1-kabel@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--19yxUJAiKHVhK1FQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 01:20:48AM +0200, Marek Beh=FAn wrote:

> Add device tree bindings for U-Boot environment NVMEM provider.
>=20
> U-Boot environment can be stored at a specific offset of a MTD device,
> EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a file on a
> filesystem.
>=20
> The environment can contain information such as device's MAC address,
> which should be used by the ethernet controller node.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>
> ---
>  .../bindings/nvmem/denx,u-boot-env.yaml       | 88 +++++++++++++++++++

We already have a vendor prefix for U-Boot, "u-boot" which should be
used here.

--=20
Tom

--19yxUJAiKHVhK1FQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEGjx/cOCPqxcHgJu/FHw5/5Y0tywFAmFoMbQACgkQFHw5/5Y0
tyzETwv/WiHjFPTYHkbLH/q0GQ+AwOlojn0s5gVYnJG4xnsqkk1WYj9Af4u4Cky1
wi0nv4tTbfrOMuJx7gdNpkDIpuBeqKEwu1OrgWurONDFDjgXMzywHG0dZvPdt7M7
jFrGUlWhrv4wq5B5D9G+MKGrhAqpUi2ROfMZ7x6h7DPxa+wLRDPzrKeqRcGNQ1zP
X6/Oz+H79f+gbDUc2OosGaTKWA+I1tJ8MNXJxXme6eO2uugqFwNIqptQOsM0KtTD
dflVWpiyVRVgHPfuGikeKjYq5HNsY0nna5OPQbvPErsoW+RJCYXmrkIa5doKH8wJ
EjUsTD/H1T8ur91xlM7ys3uzNzd/poozOAxGTRLGvwxRamuRvf55PmhhYGCXcd8i
3IVrPz06/ItwmysTUfbThBAoRreDprfY/tKxqdoMt9sUh9V11cpw2jjfhTOmu7vX
cTOg2Nq67+3h6XEyy/raYFGxcuVm1gSpDbPPFYTlxQN1shQXqERTMAtDh/iJnvYP
G5d3MLRV
=zlwI
-----END PGP SIGNATURE-----

--19yxUJAiKHVhK1FQ--
