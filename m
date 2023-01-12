Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF53C66847B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbjALUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbjALUxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:53:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFCD1C921
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:46 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d15so21365255pls.6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9hAjA8C+hyDdtu2MQLNhFHaEPH8W1DKYFXi7D7K4ZtI=;
        b=MKuiClMU4IwVit7ezFtn/cV5JB79ncmiZoZHO7o/xpQ3sY2tzvI8jS9cCGtpG0UFP/
         RNzOL8ZByxb5GlGbLqLDJUJYSJGNndDksms2byk9LOfg8MxdMlQP+M3BkYNG0nHQSWik
         tI9Q2GkQal+v45i55vh8z7QcKKK4tzIQDcWCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hAjA8C+hyDdtu2MQLNhFHaEPH8W1DKYFXi7D7K4ZtI=;
        b=AIYg+T+Rrl0fjWLNllL8TyhkUgoXwKYmoNTeeMG/M2zVEoZzKbDuqBK+NWVtwwCGT5
         W0Euh8i88tNECqLjVn35OHpKBqPn8qooJyaWOC76Na99R/K29czAykg16bKsJwXrugZB
         cDVTi4obuVDFB5NFEj+OZheJ04x57nACNdNp0SVv6bvR4Tqt0tlp3GIFIs1ptIuDaloJ
         28a8T4HQxff00bv2JpCIKlXZGIjvI+2G5aQFlfx/2AWqGY7cm81YM5MvJhazpkh2D+Sv
         eeHKJoHEGAs3sr6ZlpVRDs+C6mS1VH1YAbrWUzreaw3GZxufAk8sVwBJfIqsppeHAeJg
         x+sg==
X-Gm-Message-State: AFqh2krewkk8nq/tub5MjNtLGUeP5IkbP+jDigHroi3K7NSW/kyp62Fb
        Xqk4VwrGAA8iHfe2KNKGgGe0vw==
X-Google-Smtp-Source: AMrXdXsMsXRnUWE3oubpq9lcu71Ou6zbVZgrdkLlgr3ci8hyefpkyvLc1dobAgiShuKFSk2KDCaoBA==
X-Received: by 2002:a17:902:e1c4:b0:194:5de5:e0ad with SMTP id t4-20020a170902e1c400b001945de5e0admr3149996pla.47.1673555385123;
        Thu, 12 Jan 2023 12:29:45 -0800 (PST)
Received: from C02GC2QQMD6T.wifi.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 129-20020a630887000000b004777c56747csm10283855pgi.11.2023.01.12.12.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 12:29:44 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: [PATCH net-next v7 0/8] Add Auxiliary driver support
Date:   Thu, 12 Jan 2023 12:29:31 -0800
Message-Id: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000044bf0105f216faeb"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000044bf0105f216faeb
Content-Transfer-Encoding: 8bit

Add auxiliary device driver for Broadcom devices.
The bnxt_en driver will register and initialize an aux device
if RDMA is enabled in the underlying device.
The bnxt_re driver will then probe and initialize the
RoCE interfaces with the infiniband stack.

We got rid of the bnxt_en_ops which the bnxt_re driver used to
communicate with bnxt_en.
Similarly  We have tried to clean up most of the bnxt_ulp_ops.
In most of the cases we used the functions and entry points provided
by the auxiliary bus driver framework.
And now these are the minimal functions needed to support the functionality.

We will try to work on getting rid of the remaining if we find any
other viable option in future.

v1->v2:
- Incorporated review comments including usage of ulp_id &
  complex function indirections.
- Used function calls provided by the auxiliary bus interface
  instead of proprietary calls.
- Refactor code to remove ROCE driver's access to bnxt structure.

v2->v3:
- Addressed review comments including cleanup of some unnecessary wrappers
- Fixed warnings seen during cross compilation

v3->v4:
- Cleaned up bnxt_ulp.c and bnxt_ulp.h further
- Removed some more dead code
- Sending the patchset as a standalone series

v4->v5:
- Removed the SRIOV config callback which bnxt_en driver was calling into
  bnxt_re driver.
- Removed excessive checks for rdev and other pointers.

v5->v6:
- Removed excessive checks for dev and other pointers
- Remove runtime interrupt vector allocation. bnxt_en preallocates
interrupt vectors for bnxt_re to use.

v6->v7:
- Removed incorrect usage of inline
- Updated Kconfig to select AUXILIARY BUS support
- Addressed various comments including removal of unnecessary forward
  declaration, using static functions where possible, unnecessary jump,
  cleanup logic, etc..
- Added Leon's Reviewed-by, to the commit log in the patches, from
  previous version.

Please apply. Thanks.

The following are changes since commit 55b98837e37da723c8b73ec0b48fe68c682b57d7
  Merge branch 'vsock-update-tools-and-error-handling'
and are available in the git repository at:
  https://github.com/ajitkhaparde1/net-next/tree/aux-bus-v7


Ajit Khaparde (7):
  bnxt_en: Add auxiliary driver support
  RDMA/bnxt_re: Use auxiliary driver interface
  bnxt_en: Remove usage of ulp_id
  bnxt_en: Use direct API instead of indirection
  bnxt_en: Use auxiliary bus calls over proprietary calls
  RDMA/bnxt_re: Remove the sriov config callback
  bnxt_en: Remove runtime interrupt vector allocation

Hongguang Gao (1):
  bnxt_en: Remove struct bnxt access from RoCE driver

 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |  10 +-
 drivers/infiniband/hw/bnxt_re/main.c          | 635 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 489 ++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  57 +-
 7 files changed, 494 insertions(+), 723 deletions(-)

-- 
2.37.1 (Apple Git-137.1)


--00000000000044bf0105f216faeb
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
XzCCBVUwggQ9oAMCAQICDAzZWuPidkrRZaiw2zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODE4NDVaFw0yNTA5MTAwODE4NDVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHDAaBgNVBAMTE0FqaXQgS3VtYXIgS2hhcGFyZGUxKTAnBgkq
hkiG9w0BCQEWGmFqaXQua2hhcGFyZGVAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEArZ/Aqg34lMOo2BabvAa+dRThl9OeUUJMob125dz+jvS78k4NZn1mYrHu53Dn
YycqjtuSMlJ6vJuwN2W6QpgTaA2SDt5xTB7CwA2urpcm7vWxxLOszkr5cxMB1QBbTd77bXFuyTqW
jrer3VIWqOujJ1n+n+1SigMwEr7PKQR64YKq2aRYn74ukY3DlQdKUrm2yUkcA7aExLcAwHWUna/u
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGbj1jtC+XSj2H0g+UWV
uFbQi7xsqzf8TXNMRzx/PHq8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExMjIwMjk0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCc804pPL9H9cEqTOsKqYlw7lkxZ8OQI9FxxG+2
gVPTjXv328EjXg0B9AZc3XoaEsGQbGMf9nl4U+IeX01/VDxT73xI7YqsY4laIFSnKuvhbZm4BVCV
HWLOi5chS6EXwDElwHFHhAmCgAYdon9AlxWB1x9bN0ZWIPl1qb1JXUrsQRKf8RERA0KT/9GvkG+Q
MCyVF2GVOlr0fDsBETl7Qp5Py17xS+0kHSaEII1uHPF2E0uKO6rlaFnllc9Go7EgKmLiIw57bUZh
VlFdP6hXQwBb+Wtw9DvipbDFJa/0NK0Kk/PRy9n+IyLgh7GIPnTQlzuExFi8Qi72hen3Z2/+tQXA
--00000000000044bf0105f216faeb--
