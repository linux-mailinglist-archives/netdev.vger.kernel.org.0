Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F29E4E9019
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbiC1I2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239407AbiC1I2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:28:20 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ECCBF5B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 01:26:40 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id b17so1631751qvf.12
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 01:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yo6pI4GVP2+hoOcNJLPJfIH9MO7K7mycgPhZjPvNArQ=;
        b=Lyc/jxqOxPJMBJUmlGo3ZY4rE46HrS5wQH0RM18xIQTYlk/T9VeaXpkUw+z2xr4rqa
         5rmvW1hF/l21U/ZRh38BVa9vKR/JsuNV2Oy+Tw2HZ5URD08IYVFQRxUmGLqE+veJhpCl
         eLDEF38EwCWbIbBD9rE7aIi7cIAU+LISi8Ys0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yo6pI4GVP2+hoOcNJLPJfIH9MO7K7mycgPhZjPvNArQ=;
        b=UBFmZ8b702nBFV/TVx6+QOIdoeGqLgMOSv4LscKsgAi1ABjGWde45KFP1mgZy5tUI3
         ftUXmIbHFI5Nc6tP/SfRiPi+7k13PHEkZE6IXf3WRp0gSvuS0iDgO8uqXpOjadh0gQ2C
         iK2jx/+3quR9YQWViTm9EQA5dLdG2nbK1c5XkM0r5R2tdjBMFB52fyfeg+97mbT/iWPG
         MHkIaY/zdtBnbVD+53I1PNnf1yp81+vko1eagmy7PdBt7Late3ElU3Jber2UEaMxbEcn
         ESnjX+xrxpv6OB4sz39ZjEIwmQUEkc/2tace4jKQty6y5/Vym+HjXsZrCP/medjPFNWP
         akkA==
X-Gm-Message-State: AOAM530VWDDww3UCj2Zaa5APaA13ut/08gJarh8k1BBsKLqwgCkaUssq
        E6ZGDIvLL58qJFD9uWsVNMNBr1fWr1KVm2KONGm8V0uYn1M=
X-Google-Smtp-Source: ABdhPJxBFGJ3c/nEY3bjS53WzkGP4vYvGmYckU1uKiAy3Uxkh0/vwS7StIUbTyDKRB8T0rQVHr6JfBZ0wbArNul0k2M=
X-Received: by 2002:a05:6214:4016:b0:441:28be:7c45 with SMTP id
 kd22-20020a056214401600b0044128be7c45mr20184862qvb.80.1648455998894; Mon, 28
 Mar 2022 01:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
 <CALs4sv2X4_VWkqDmA7E3Wi6CBFrAok+s-_MiL=S=a9uiP07otA@mail.gmail.com> <03676250-34b4-27ac-4f50-4d507266c7a6@opensource.wdc.com>
In-Reply-To: <03676250-34b4-27ac-4f50-4d507266c7a6@opensource.wdc.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 28 Mar 2022 01:26:28 -0700
Message-ID: <CACKFLi=wzz5GrBUgc1dCNGUuKs0HdrVo_m4LonJF-9sO3kkf5Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: bnxt_ptp: fix compilation error
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004677f405db431299"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004677f405db431299
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2022 at 12:01 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 3/28/22 15:38, Pavan Chebbi wrote:
> > On Mon, Mar 28, 2022 at 11:57 AM Damien Le Moal
> > <damien.lemoal@opensource.wdc.com> wrote:
> >>
> >> The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
> >> CONFIG_WERROR is enabled. The following error is generated:
> >>
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function =E2=80=98bn=
xt_ptp_enable=E2=80=99:
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
> >> subscript 255 is above array bounds of =E2=80=98struct pps_pin[4]=E2=
=80=99
> >> [-Werror=3Darray-bounds]
> >>   400 |  ptp->pps_info.pins[pin_id].event =3D BNXT_PPS_EVENT_EXTERNAL;
> >>       |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
> >> In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20=
:
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
> >> referencing =E2=80=98pins=E2=80=99
> >>    75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
> >>       |                        ^~~~
> >> cc1: all warnings being treated as errors
> >>
> >> This is due to the function ptp_find_pin() returning a pin ID of -1 wh=
en
> >> a valid pin is not found and this error never being checked.
> >> Change the TSIO_PIN_VALID() function to also check that a pin ID is no=
t
> >> negative and use this macro in bnxt_ptp_enable() to check the result o=
f
> >> the calls to ptp_find_pin() to return an error early for invalid pins.
> >> This fixes the compilation error.
> >>
> >> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> >> ---
> >> Changes from v2:
> >> * Restore the improved check in TSIO_PIN_VALID() and use this macro to
> >>   return an error early in bnxt_ptp_enable() in case of invalid pin ID=
.
> >> Changes from v1:
> >> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigne=
d
> >>   value.
> >>
> >>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 +++++-
> >>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 2 +-
> >>  2 files changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/n=
et/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> index a0b321a19361..9c2ad5e67a5d 100644
> >> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> @@ -382,7 +382,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
> >>         struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnx=
t_ptp_cfg,
> >>                                                 ptp_info);
> >>         struct bnxt *bp =3D ptp->bp;
> >> -       u8 pin_id;
> >> +       int pin_id;
> >>         int rc;
> >>
> >>         switch (rq->type) {
> >> @@ -390,6 +390,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
> >>                 /* Configure an External PPS IN */
> >>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
> >>                                       rq->extts.index);
> >> +               if (!TSIO_PIN_VALID(pin_id))
> >> +                       return -EOPNOTSUPP;
> >
> > Thanks. Could we now remove this check from the function bnxt_ptp_cfg_p=
in() ?
>
> Having a quick glance at all the call sites, it looks like it would be OK=
.
> But may be in a different patch ?
>

Yes, we can improve it later in a separate patch.  Thanks.

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

--0000000000004677f405db431299
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJQUOnrFsX4k+R+5T/vvWbNmltKOV20A
vRkzs2RVJiNMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
ODA4MjYzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDNXiT/KnKfwZIFPWaxDKcifzSRLj8Nc3yUw8pMj13ClWlyrFkQ
VqzzRmFmr8V22eZDIl9L+TVN7jqq4FPvmtSH3NuGgd1NlaFLvMl75tWjm8D2ybDc5WqUQbu9Kp1S
0FgQ1ckgtbhA/8unvXvJOgd68UcrDkxJcJaDdZOeND54ymvntjnJ2WOPtnpGLwGqp7b6AaEmGivj
IPRF8RvyljZWHC56AQIy/0k+cGFskEiNn4OGbt4xO/jKZuFO8gVUtKbh/DLzhhXh88kiLxvTsysr
xKt42lyvG58k3z0hTw61HRSoFJ34tzld9Mu86kHItbYawKMAI2fX4bVveoTX/Uqq
--0000000000004677f405db431299--
