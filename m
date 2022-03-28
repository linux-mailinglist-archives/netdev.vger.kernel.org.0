Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108DD4E8E43
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiC1Gke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbiC1Gke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:40:34 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C295D14014
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:38:53 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d15so11526934qty.8
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0vyZa2tX477lcRfnhuo8fXCFXWi0h5QpupTh9oH+zqU=;
        b=JjLfDBxH2DFQwKZfgcjJYCzjDPl9GcbOn7wIBUO5Q1NsQ4M6HV0Gwmaf+P8ysx93pM
         Q6J0QNlP7YFd0wqtdo7ber3axwGdfudK8JilUBEziiIEBf2og9sZ/is9flKdD1QAKvdF
         6ynpj+xJY89pYiHRnqx7GoldTJr7nbHo371cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0vyZa2tX477lcRfnhuo8fXCFXWi0h5QpupTh9oH+zqU=;
        b=3I1RUKjnosrKcPc/i2Siwabapags09+u9qOL6GFZuZD+wbALBnaivL4C2J3Z56HzWe
         DRmAiHrTcRrQOcstKJ3V4odxJa85dO9hGdc/L52FXTBN8h0GLlXy+E6ZFv9EhYptI/Oy
         q7NtdJgumFs0adwQ9eHAz6gqBosI4r3S1orusHvABvpPn7V+aFciatMmk5BpknOHjtiX
         XmJjgWtdWXDrxfkXN4EAXebpw59w/MIhFmM+orMK5pLTDfqZPMWeuuBCB8rrXtb+Yx7a
         30pivxXP3kwl2farqXIXh7oyAL4PEsfc+n5wkk63yPOeeHMC3QZzMAQkm2TDCdnwyliK
         D8ww==
X-Gm-Message-State: AOAM533D/x1bpVv8MBqkbr925MeyY/QdPdHjQbHq8BO9vuisZWEvYcgD
        xNkm7ekYmZPzSDWuERnl2WQkeveKZQabbsy2InZ74A==
X-Google-Smtp-Source: ABdhPJxRtJ31r2ZQWG9zQMC3PyItt9zxrqKs24ymt0rPZsS2FOiMT0mP+547yWswizb03lxz74Z37OiDguJFbPbastQ=
X-Received: by 2002:a05:622a:11d2:b0:2e0:bbbd:5a2b with SMTP id
 n18-20020a05622a11d200b002e0bbbd5a2bmr20063424qtk.233.1648449532799; Sun, 27
 Mar 2022 23:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Mon, 28 Mar 2022 12:08:42 +0530
Message-ID: <CALs4sv2X4_VWkqDmA7E3Wi6CBFrAok+s-_MiL=S=a9uiP07otA@mail.gmail.com>
Subject: Re: [PATCH v3] net: bnxt_ptp: fix compilation error
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000da3ad105db4190a6"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000da3ad105db4190a6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2022 at 11:57 AM Damien Le Moal
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
> Change the TSIO_PIN_VALID() function to also check that a pin ID is not
> negative and use this macro in bnxt_ptp_enable() to check the result of
> the calls to ptp_find_pin() to return an error early for invalid pins.
> This fixes the compilation error.
>
> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
> Changes from v2:
> * Restore the improved check in TSIO_PIN_VALID() and use this macro to
>   return an error early in bnxt_ptp_enable() in case of invalid pin ID.
> Changes from v1:
> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigned
>   value.
>
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 +++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
> index a0b321a19361..9c2ad5e67a5d 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -382,7 +382,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
>         struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnxt_p=
tp_cfg,
>                                                 ptp_info);
>         struct bnxt *bp =3D ptp->bp;
> -       u8 pin_id;
> +       int pin_id;
>         int rc;
>
>         switch (rq->type) {
> @@ -390,6 +390,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
>                 /* Configure an External PPS IN */
>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
>                                       rq->extts.index);
> +               if (!TSIO_PIN_VALID(pin_id))
> +                       return -EOPNOTSUPP;

Thanks. Could we now remove this check from the function bnxt_ptp_cfg_pin()=
 ?

>                 if (!on)
>                         break;
>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
> @@ -403,6 +405,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
>                 /* Configure a Periodic PPS OUT */
>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
>                                       rq->perout.index);
> +               if (!TSIO_PIN_VALID(pin_id))
> +                       return -EOPNOTSUPP;
>                 if (!on)
>                         break;
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.h
> index 373baf45884b..530b9922608c 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
> @@ -31,7 +31,7 @@ struct pps_pin {
>         u8 state;
>  };
>
> -#define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
> +#define TSIO_PIN_VALID(pin) ((pin) >=3D 0 && (pin) < (BNXT_MAX_TSIO_PINS=
))
>
>  #define EVENT_DATA2_PPS_EVENT_TYPE(data2)                              \
>         ((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE)
> --
> 2.35.1
>

--000000000000da3ad105db4190a6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDEdgvFOHITddmlGSQTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE5NDZaFw0yMjA5MjIxNDUzMjhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFBhdmFuIENoZWJiaTEoMCYGCSqGSIb3DQEJ
ARYZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAN3mGiXPVb6+ePaxZyFGa/u3ZQh4rPCPD3Y8Upnh+EXdw4OgeXtu+l2nXqfB7IXOr2pyGzTe
BnN6od1TYmyK+Db3HtaAa6ZusOJXR5CqR3Q3ROk+EiRUeIQBesoVvSLiomf0h0Wdju4RykCSrh7y
qPt77+7MGWjiC6Y82ewRZcquxDNQSPsW/DztRE9ojqMq8QGg8x7e2DB0zd/tI9QDuVZZjeSy4ysi
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPh0tWz38g5AdRVmIKy5xTipdsUBUziv
8cHjfpJGjoD9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
ODA2Mzg1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCzcPVpPCKPfNKkdnwVzIDauRmcpebCNrQzp1SbAK+nGIKOo1HL
9QqFtrGfStc9HQEr5py8zrtZOFbnwHA8xaMlydJ9igJ5SIE33Xm2GoQ/TaOxlWt/dPh/mGKJZXXP
yYsLu+E7Q8h3vEebZGsJo/0xobKQ6MuNFqrhMshlbvr4OzLkFlZZog7GWUwxJIcAkOENiN4ILH4D
KK5iZuEi1zTcKYCKhwZcAZ1nr70JcgonEO2b2mca0prspcX+SvlEyF6fZmbwtnyN0EoUf7Pgerk8
DrtNXSvo46mG7zQs1nkI9XXRmMCqsgNR7sqSw/3H8AsUAHd0cY54TQglMrWWRYE7
--000000000000da3ad105db4190a6--
