Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8E34E8D84
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 07:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiC1FiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 01:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiC1FiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 01:38:20 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACF1DEFD
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:36:38 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id kk12so11029889qvb.13
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMpkCPDI+m7lq6f2xjKqPknct6cP7Gm2nsb28mpcvts=;
        b=Rc7NEu4A0PbIdAO/GNyBk2ekevf45WSMrZIKAIj5m4XC9OByW+9NLVFDyWaUeJlSwc
         IY1K8gnyEyR0lzxAxB/YsV3l9INKVBu8juFSwj4o5y7F8+jUscoF3qkFi/qCq3+F9tYo
         Q2a7YbzJFbd3QmxOwbyJkaVAjHwGutULSMhRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMpkCPDI+m7lq6f2xjKqPknct6cP7Gm2nsb28mpcvts=;
        b=sEG81AFNLl4VbdO9Ruw/34Fkx3ownMwjn6saMHHWnZl4DZEJbH2cTaGiZ2IHSKTNNr
         V9racX8i0flzCOJsqGAqSCYwPxBSp5mSr5s6iVip2T6OuT7t4udZ/NC8FrTBvwrKbK5E
         MDpNmZgxHzYMM38XSlGGZWoIXwlj4NYd+WCAF3m5sU4x6XAlsU6WYEBaf39411lD1QFd
         0Tu+Ly5Tlp81BKH8stIdxmyFwzdBJ4hkIoMYnAK5/w6JrNo4MxBjWckXxhpxZtGN/bcQ
         qtYMRvmPMEEMSI44jCppzma1aRIecMOAbEkIjh9qp9hUvZ1PxyxrYce2qmdu0mwR3qpU
         /bwQ==
X-Gm-Message-State: AOAM530Z0QcyqArLxRG7Sp/ZGsRte0/z+U2rttZfCyiklJVYj2ffFDzd
        3296HCXcfRqllYtg9rlOJn0sjlJyA6tHnwl0EeNu/A==
X-Google-Smtp-Source: ABdhPJwb7D9woT/o3JlLdEmns5jVvJU48lACWJbXwWJjpkCB/IxnDTrtQj5VUpX7gf0L6wNT7Nn/JFe3eH7XE0SW8kc=
X-Received: by 2002:a05:6214:4016:b0:441:28be:7c45 with SMTP id
 kd22-20020a056214401600b0044128be7c45mr19832474qvb.80.1648445797785; Sun, 27
 Mar 2022 22:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 27 Mar 2022 22:36:26 -0700
Message-ID: <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003a5c2405db40b2c6"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003a5c2405db40b2c6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 27, 2022 at 8:35 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
> CONFIG_WERROR is enabled. The following error is generated:
>
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function =E2=80=98bnxt_=
ptp_enable=E2=80=99:
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
> subscript 255 is above array bounds of =E2=80=98struct pps_pin[4]=E2=80=
=99
> [-Werror=3Darray-bounds]
>   400 |  ptp->pps_info.pins[pin_id].event =3D BNXT_PPS_EVENT_EXTERNAL;
>       |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
> In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20:
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
> referencing =E2=80=98pins=E2=80=99
>    75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
>       |                        ^~~~
> cc1: all warnings being treated as errors
>
> This is due to the function ptp_find_pin() returning a pin ID of -1 when
> a valid pin is not found and this error never being checked.
> Use the TSIO_PIN_VALID() macroin bnxt_ptp_enable() to check the result
> of the calls to ptp_find_pin() in bnxt_ptp_enable() to fix this
> compilation error.
>
> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
> Changes from v1:
> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigned
>   value.
>
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
> index a0b321a19361..3c8fccbb9013 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -390,7 +390,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
>                 /* Configure an External PPS IN */
>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
>                                       rq->extts.index);
> -               if (!on)
> +               if (!on || !TSIO_PIN_VALID(pin_id))

I think we need to return an error if !TSIO_PIN_VALID().  If we just
break, we'll still use pin_id after the switch statement.

>                         break;
>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
>                 if (rc)
> @@ -403,7 +403,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
>                 /* Configure a Periodic PPS OUT */
>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
>                                       rq->perout.index);
> -               if (!on)
> +               if (!on || !TSIO_PIN_VALID(pin_id))

Same here.

>                         break;
>
>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_OUT)=
;
> --
> 2.35.1
>

--0000000000003a5c2405db40b2c6
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL6u4+9r3Bf77aRnnAFDCRpKw9BVc2bi
uHGcpuN7cVmxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
ODA1MzYzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC3ce0N6W6u2qWtKQx6ssHzkt86p5QZgXqhh4BsBA2wsenRDFgD
s7mG9/NJ9T/qOHVgauOkLiX+kQLY9g6GiJNbyGPalZ0dqyvEQp6QJqYsr9Ee1+PprRiqKj0Tcgqe
US3RnhIhzsJbZXGhT/csdoWM6Nclgrr95f5UGEh/a4UuulJ9uQ51pTSxAvIi/PmLFozZNvhK48BO
JHVlFyQWYxZOx2Y9iFDP1RDjGEvGabgkW6Q6frtqtTIg7Jdj6uOgO2XARbLRVioI+3OcXGi3Kcfx
NXKGT7MS28lmnEb2a2gQPVVjTVTnM0WqKUVcaP98ARLREHBkuOq7GaMpKzQVQI0C
--0000000000003a5c2405db40b2c6--
