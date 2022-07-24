Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D214B57F7A0
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiGXXPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiGXXPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:15:06 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF2210FEC
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d10so8923868pfd.9
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:subject:date:message-id:mime-version;
        bh=QZwR/s5NLpC1VStrgBMYxzhnMsWHriDLuCRWdtzNULg=;
        b=DtzRKnq93CzV4WaIK3+bmrNcXtKmrvV5WKsx2RX6dJwgkn6yjrDKOQAC79ODc5fzv5
         O9j1epyO8ZSFNh5zM7gWcxQagvEyrB8sycHKKwizY3QNLJn7dFzzxdoyLqoLkzo6fGMx
         RqTv2xfx3/c0LZdO8FtTNRsFI7eHUEXEA4i9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=QZwR/s5NLpC1VStrgBMYxzhnMsWHriDLuCRWdtzNULg=;
        b=Z33Gi8V005G8zH3ebJaLlGtLzHxoYnpPCSJtY50adGoisbfmCnyn5rQcgrPRzn1+uQ
         bVWyAkU5h06xbUFjWKQqOM9o4LmIm8DsT6qyWhQdEoIzwb4V/fMiVTbLcqCukbrP7iKR
         SacjFYcN9odgVxZ4S1+tmVezqTTvk67uQCGV63cLqUVUqcAQdUqWWcBWLWdA6kHsc2p+
         xCoa3aUUbWAM9j4iGrTDjmeMI0t82zABj7c+q7rHWKYMe/zloTwfh+kE8e3YpKs1aJ/f
         LTNOJO5/Eb0CgWQ7R+NG5BDJ2CCTaob6iTKlQmQx0CNCfzxJF/6v6R8h8l90s5D7S7d5
         PERA==
X-Gm-Message-State: AJIora/V1hQ1OqiCKnhEzAUBWkdKS9qrLgXTG2OwQ4p2Ngjx+xT+tvka
        agLA8vwMaATeix4jlZYL4B3kl7+6FxBdOA==
X-Google-Smtp-Source: AGRyM1uMJLDU39gQzGt6eANPLxTuT8Gqct1PY35tMNr0owb8XzNEm25ZPPBNI2F3y0m7lakZFzg6Gw==
X-Received: by 2002:a63:8b4a:0:b0:41a:64fa:400e with SMTP id j71-20020a638b4a000000b0041a64fa400emr8725634pge.397.1658704504851;
        Sun, 24 Jul 2022 16:15:04 -0700 (PDT)
Received: from localhost.localdomain ([136.52.99.246])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902d5cb00b0016a6cd546d6sm7661395plh.251.2022.07.24.16.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:15:04 -0700 (PDT)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        selvin.xavier@broadcom.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
Subject: [PATCH 0/2] Add Auxiliary driver support
Date:   Sun, 24 Jul 2022 16:14:56 -0700
Message-Id: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d2110005e4953c25"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d2110005e4953c25
Content-Transfer-Encoding: 8bit

Add auxiliary device driver for Broadcom devices.
The bnxt_en driver will register and initialize an aux device
if RDMA is enabled in the underlying device.
The bnxt_re driver will then probe and initialize the
RoCE interfaces with the infiniband stack.

Please apply.

Ajit Khaparde (2):
  net/bnxt: Add auxiliary driver support
  RDMA/bnxt_re: Use auxiliary driver interface

 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
 drivers/infiniband/hw/bnxt_re/main.c          | 405 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 200 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   8 +-
 6 files changed, 339 insertions(+), 299 deletions(-)

-- 
2.32.1 (Apple Git-133)


--000000000000d2110005e4953c25
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBVUwggQ9oAMCAQICDBCmE9BT7srhoNHDEDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE4MjdaFw0yMjA5MjIxNDUxNDlaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHDAaBgNVBAMTE0FqaXQgS3VtYXIgS2hhcGFyZGUxKTAnBgkq
hkiG9w0BCQEWGmFqaXQua2hhcGFyZGVAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAwXsxfYF9jpj9zve1vXxD491SrWDVlcmLMdnOS1c7POMC8lbbgvp1o2kIu/3n
xCVFTai5H6rHZgrFItNNVZ+XaJW9Ob9eiSuXdnAu5gVdTb+IFAf4S/PT2LXzpP07M7vyvm/yvA+8
HtVfapzqqTNYdNVUpq28MYsKEWbnyK94x5+C3oCAV4bpNnMoPNtKrMhvOdpTREQRyew8hyy3/Mz7
RIaCW0xx+14NTQe17dkH6CEEpmCjejneq/FU0gmbuorwHoP9mOiqeh23/ZKVpmFO/eiDtvMNAMDW
6LzhOk/pMklUPTHu/gQNW3OQebyhyFUHiBSp8rDkfWZT57Asd0PtdQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUPHif0ihgndR0
h7r3sANaOIu2yM8wDQYJKoZIhvcNAQELBQADggEBAAEuLXDnP0Xd2zAMpQobXLUyqbpqGMO6ycQc
Xq4H2YYlSNKVwPA+ZAVdUOzbSimBKlx8mzAEHkI3Ll1yXlYeT4UwkfWV9fioyGuQelLN1sGzi5bm
WEpaSIbR1eiJMtzxUPwpRTn19gHZVueIot2Gw0fEYgHiMJpUr6xBWv2QNXULu/E8qvbXIRh2iycq
5rWFggX/JHglO8nVqzb1ImzqzVMFnDN15h3j8ryy2MIvZ8VDQRP7l81IXaTvVwaKpWMgV6rfQOi6
aOQZuOKkad7qoCkS5N2oSsvxi+rZtDaJJNsDjs05y5JZZQtBlfAmdYS+mmvkPjZ1iaLTzk59o/Yo
fNkxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQphPQ
U+7K4aDRwxAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJ/08UpAeQ9Ui3d1VI33
hoPo/znJAf3kUiOle4UbRlK+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyNDIzMTUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQByj4Ps8CwhLg0LSYg7v1dNm9FBgBybFr5FR9VD
40DcxpuQXfuaz9GStPHxsX+FM0ejFHt/w4lfhxqgy/oL+pS3ziaIqdq4DfqvvsnweS/qCFYZKK6j
3kR5vfJ3ItuZc32ZxrlmSMquyV5jRUOHePKZK8koTuYY0AImOBsWRxmKtbj/YnPewqTdDOlQ//js
bFoQX/vezee2aJf9UmcZt34b75c7l4kfrXyIrMtyt2cNexCVo2Vja4eVZ++uxX+KwGetcBJkxVu/
vGqaUw8L/NxeDSAx/7vuKP4kuhsSNtlhK6qI8ZthCMCUAIOxk28EfgHe9sOzpWICBWWw4mA/9xwH
--000000000000d2110005e4953c25--
