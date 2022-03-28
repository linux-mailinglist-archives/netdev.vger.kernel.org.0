Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D914E8DDC
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbiC1GMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbiC1GMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:12:35 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1FE51599
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:10:52 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id kc20so11118715qvb.3
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/loVBHE0ejWwrxnuiLHuSrJcUE2a5XO+FR0vTlfHxig=;
        b=Tz3rI0daJk9dnAWZHOfJzjZVoBcOD04Gs4/Ii109IGtQgsGLnFHWxtVfW/sEL6dkh5
         s+EV3xNJ2dSH4N0A7mVWd8ExTxSy1SHQLU1YOsGWX3dBzwCPR8xw6Xmk2NmRdyOn7S0q
         QYD+U8d3SfVVgsEJRxQvJCyVqfbp0mLoJ7Rh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/loVBHE0ejWwrxnuiLHuSrJcUE2a5XO+FR0vTlfHxig=;
        b=St5+kVObjmzh+62JSMJk62tcEaYm3TOdAai2cDc4Pn9sKgVZQC2PfgI/YWw/qVLBgT
         K33VVF8fJo5mCW+qL98auGei7COTV3JYGQMoKxTmJJUkKZm/UUHhXdJ44Ds5QoLG4BEW
         IQjhEFStx9nZaCu7uTNPWY9qVvczbP75tQrTQMreMxkAn5DmpbM2GQLLt5h9gtISIR+Z
         4VUwgSRSvRAX+h+2oI9vUTLTjeVbn7pcZcNxL4sX5zo0n+98f4hlK4FnhaOnM1wGMVHS
         019wakpIJfacfV9mOZBlH/yBD65euQu4/3Dt5UM5eIK5ou3TROX1pRMq1mbzCEYiVPZl
         Lfvw==
X-Gm-Message-State: AOAM533M+79ZLhLmhS/607RBC7GnLNbPnpdbyxm2r8JM/6hS2gVNEAee
        Y71t2u1mCkQTp0zdDiZ7QNW+YDV7MhQhJp563HJuVanui3R3Xw==
X-Google-Smtp-Source: ABdhPJzRkXBtBMQ3+BXdlMpIjvwD6IoNf7wfJY7nIlPI9CeXfHTMumFMP/S+j8juLWY3LZikabtCglj51177CGuHDN4=
X-Received: by 2002:ad4:5848:0:b0:441:4092:c385 with SMTP id
 de8-20020ad45848000000b004414092c385mr19738564qvb.24.1648447851781; Sun, 27
 Mar 2022 23:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
 <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com> <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
In-Reply-To: <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Mon, 28 Mar 2022 11:40:40 +0530
Message-ID: <CALs4sv3Wm+oNVZcnWScEk0f3zfLcnApn90iTPt0kSvhuzjXk1Q@mail.gmail.com>
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a7b77b05db412cde"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a7b77b05db412cde
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2022 at 11:14 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 3/28/22 14:36, Michael Chan wrote:
> > On Sun, Mar 27, 2022 at 8:35 PM Damien Le Moal
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
> >> Use the TSIO_PIN_VALID() macroin bnxt_ptp_enable() to check the result
> >> of the calls to ptp_find_pin() in bnxt_ptp_enable() to fix this
> >> compilation error.
> >>
> >> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> >> ---
> >> Changes from v1:
> >> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigne=
d
> >>   value.
> >>
> >>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/n=
et/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> index a0b321a19361..3c8fccbb9013 100644
> >> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> >> @@ -390,7 +390,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
> >>                 /* Configure an External PPS IN */
> >>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
> >>                                       rq->extts.index);
> >> -               if (!on)
> >> +               if (!on || !TSIO_PIN_VALID(pin_id))
> >
> > I think we need to return an error if !TSIO_PIN_VALID().  If we just
> > break, we'll still use pin_id after the switch statement.
> >
> >>                         break;
> >>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_I=
N);
> >>                 if (rc)
> >> @@ -403,7 +403,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
> >>                 /* Configure a Periodic PPS OUT */
> >>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
> >>                                       rq->perout.index);
> >> -               if (!on)
> >> +               if (!on || !TSIO_PIN_VALID(pin_id))
> >
> > Same here.
>
> The call to bnxt_ptp_cfg_pin() after the swith will return -ENOTSUPP for
> invalid pin IDs. So I did not feel like adding more changes was necessary=
.
>
> We can return an error if you insist, but what should it be ? -EINVAL ?
> -ENODEV ? -ENOTSUPP ? Given that bnxt_ptp_cfg_pin() return -ENOTSUPP, we
> could use that code.

Would it not be better if we add a check only to validate the
ptp_find_pin is not returning -1
explicitly? TSIO_PIN_VALID validates just the MAX side. So I think
adding a check for -1 only
is valid and won't duplicate the code inside the two functions.

>
> >
> >>                         break;
> >>
> >>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_O=
UT);
> >> --
> >> 2.35.1
> >>
>
>
> --
> Damien Le Moal
> Western Digital Research

--000000000000a7b77b05db412cde
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
MjHtaKp4bqyoZGmz/QLIf3iYE8N/j4l3nASfKLlxomJthuh0xS34f5+M+q361VT2RQFR2ZNQFb7f
u2AmJ7NZqhqVl/nlRPbwLl/nxV03XFhDLEhyLbRKuG8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUW6H0m/TK4GBYA6W3b8Soy869
jBwwDQYJKoZIhvcNAQELBQADggEBADBUMB9YQdlXyJbj8JK/hqrxQKEs3OvpoVm65s7Ws/OD1N+T
t34VwsCr+2FQPH693pbmtIaWRVg7JoRBb+Fn27tahgcRLQeJCU33jwM0Ng3+Jcyh/almUP+zN7a1
K8FRTPOb1x5ZQpfNbAhen8hwr/7uf3t96jgDxt4Ov+Ix86GZ0flz094Z/zrVh73T2UCThpz1QhxI
jy7V2rR7XHb8F3Vm33NlgRSS4+7FwV5OVWbm+PNNQDrlTBAl6PobGqt6M3TPy6f968Vr1MB2WgqW
8MnI3cvZy6tudQ1MhGmfYpx8SlvXhhwkWwhXeW7OkX3t6QalgNkliqzXRifAVFHqVrkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxHYLxThyE3XZpRkkEw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIERFeKQ5NufJiXwTkelY/O67P9I4ow1Z
AjTGBf1cB619MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
ODA2MTA1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBISRuxkqN2oeXMlgp2FJK2OQbypVL07x2VQnvHel/sYqiHZh3p
FSRt5lgZGWZKIPS4hT4boxV328MooXfzncmvVmcu4I4B6kthzEemZeXzsn0s/4qaSKmjLhdLc8+F
ykKUGOhANuTvqQd/eNEY4gkm4A7VH0+5lEBhESSuYcPZkPriA4foGs+JF+dKpcP7qA75kG4q8ydk
Hnhh2hZ4f/C2s/88KR1ZPXiWD8tNDWCAY53R9aR215+8KNpSTPADbQD+E2LxwAIedGE+bmOaN0IE
V7k1E+9yWmhadoYHbRaMYzo5qk6HSyN90D27tCilcTiAGvRHCkuO7s7UbLZuCElv
--000000000000a7b77b05db412cde--
