Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D931732DCB6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbhCDWJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241291AbhCDWJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:09:23 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0200C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:08:42 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k12so26294225ljg.9
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQzzpQRDq3BboysdZruMiC3Se7y7eNICbRZtHByTqMk=;
        b=NJO2j/ikNf8x/SaVM6raNaGtK59C9bLdTlxIooC8wnbAxcqcJtTwZ1JTr+RZh5e99s
         tNNWaVLAVmOOo/vG6v4Rm2oqpgy1fTY8bnEAdiXJoVyWdcbe7ZTy1Nt3+/4+i1uDKQZX
         +vOg8hkFIEd5lZbPmf50rpqskzDidS+zvW024=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQzzpQRDq3BboysdZruMiC3Se7y7eNICbRZtHByTqMk=;
        b=gt5EyxqRO9LSAW8up6Dm5ehslnn588iDoSrbpwy9jv6e47L0biEXbRDWX44KGwxvN7
         VSB7VYT56xjuNxK+zC897DiTspZik8N+dRP99EEa3ic7CzGpftHpbX6/gkJMJdpgQh3s
         G5GNgV0L54L/LJg4bx+6+6WATceneSKssnRZifkKUHGgw58HdQcqKGX1/RNtNo/u49rJ
         bnm+juOlfKwr78fwW4tisWr/phvEUDtrzyQtTIrHaygfEDtFKUutTN6ZGGpAQsYWSfnJ
         Xhr8B6nFA7ELZKyDNWENXQj+uiYTZrIzMWFh85IWp0Iq5VicHu6JinVspsebxLXhY5oG
         BXUQ==
X-Gm-Message-State: AOAM531cHFeBu2W9G9Gj+sy3rwD1BNEDxDhKe9kMA29a1vVUNaxs4x1j
        ftYhLSJqclS8LRz80K+PWgZeQfkhu8Cj2GVRs39HFw==
X-Google-Smtp-Source: ABdhPJzAnKdCL2MBNUYzdcmpZZ+lw/GAjYMIMze5DAdv4n3VBvtkENafTlcY+CU/fxtYnwTJp8eWED4qcMsI99zU07Y=
X-Received: by 2002:a2e:2f05:: with SMTP id v5mr3414337ljv.279.1614895721232;
 Thu, 04 Mar 2021 14:08:41 -0800 (PST)
MIME-Version: 1.0
References: <20210304090933.3538255-1-danieller@nvidia.com>
In-Reply-To: <20210304090933.3538255-1-danieller@nvidia.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 4 Mar 2021 14:08:04 -0800
Message-ID: <CAKOOJTwxMGL-uQ7VQZy1XGHddU5MWY-FnWDMwiFX8nS=Gu_E=Q@mail.gmail.com>
Subject: Re: [PATCH net] ethtool: Add indicator field for link_mode validity
 to link_ksettings
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>, f.fainelli@gmail.com,
        acardace@redhat.com, irusskikh@marvell.com, gustavo@embeddedor.com,
        magnus.karlsson@intel.com, ecree@solarflare.com,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d4c16205bcbd352e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d4c16205bcbd352e
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 4, 2021 at 1:13 AM Danielle Ratson <danieller@nvidia.com> wrote:

> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -130,6 +130,7 @@ struct ethtool_link_ksettings {
>         } link_modes;
>         u32     lanes;
>         enum ethtool_link_mode_bit_indices link_mode;
> +       bool link_mode_valid;
>  };

Why isn't this handled the same way as is done for lanes, with a
cap_link_mode_supported bit in ethtool_ops? This would be more
consistent from a driver API perspective. Then,
linkmodes_prepare_data() can set link_mode to -1 for drivers that
don't claim to supply link_mode.

Regards,
Edwin Peer

--000000000000d4c16205bcbd352e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
CdFrNJPZh3pPkCH0IKX6CImmyf+CyRknDRWPFgQvGmDe4kLDdPKXPTfXE0pGT27moNdaDiXvUvxt
XeKr13glJBx57n5ozOGoTKmI3V/0Pm+lfngViwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUoRyjOYXxPkXMBZPbsbAaSBKr4MEwDQYJ
KoZIhvcNAQELBQADggEBALIQiUvJC5+niEMS+nj0JKY9DdbREqHy2QyKJokwEbvuTemRjzzAad8x
oFtYsqkKca5WMV9A7zKalx2I2pRFK7xU5CwvSmNyfULHPxHb9B9KPuZ0htbtYptYPuygXLS5UrU6
nAO/qVpSFm11J9qSg2Tf6jN7yyAx/HLoM8uxnF3csFNBVyLssCrOJIkzQfRVgccOkm4EheBIXZZ+
/rXxlnHpIINzM6psnEe5UxvnwD6al47UBF9KswS5uyI2kJWzVw2/5iDRmJn6dhhWah3W8KDsTBl0
Ubfa6OVikUM8sf9aZkU2j4JEpaSTHAAj6fRPAgBYM1E4CbU2QeL/wpDwlI4xggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwl1owS4QyKKm0xatYwDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPFMf0FWMzyhGX14uFozs1oE3OeU65CUPALntvcJ
InZhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMwNDIyMDg0
MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQAGlwBUIfm4ChzUyEGF6Wfbyt+7w89vEv+fkD1Wjfz+PAEe7abGYBA9SFOv
xpSERQ7A5H9GmGYJDzkBRoV5kETdZ0i31+eUtPWfaKwQH16NYGPlzzhWkgPHXTFNdKv8Yf7Mi4Fy
Lyp0blA2MDcAjPe9E7Rdazwwz9ky1jO9gbE6zcjjFIjONiMiZEnoKaUc2P+4WyWvosgco2DQyLTi
MRBMjfz1rRLhbyb8nwj+XubHQrFTUVVHh49ODej1F+jn9zikqqMVXmgve5zrhMcoooN9i/XV3jeo
0bjklqGOm2dllCGI8u1/VjjUXiTX6NSnD7KLCR0RVMVDtyZlfffeELaB
--000000000000d4c16205bcbd352e--
