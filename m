Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC8C641774
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 16:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLCPPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 10:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLCPPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 10:15:05 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB031F2EE
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 07:15:03 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id o127so9378021yba.5
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 07:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XbJVjC3ztRQIX2P5NRw4729hPeQ7PLFIQm1ereaj+pU=;
        b=P/6O4YXc8GAEgbHJoPDU3c7NOkaEl6gKExQnF+XrKpEjepTt7IQe8VFpMgFJjdycKH
         d0W3KgKewifxCuGGzk1GU+KSMJcGGvpD71t4hKEWx8CDgGCpDzIL3ro0i35MQBVhq6HI
         ZSwhE0PyC5Z+dIlK2ddNN9uLkT4lwwcQ5sgFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbJVjC3ztRQIX2P5NRw4729hPeQ7PLFIQm1ereaj+pU=;
        b=DlOvM1iODO16vXNVpPE7xEjw3mHAN/+/Ad/LAToopN1MMhOOvmikVoiUNlH5C/BDqE
         Y9EqasAwyfKiOpsWLD3o5G1TPum69HEHuTeeP6j76rIIYjiuPoEbzrC+N6htE07ycirz
         wMfmM4nzIaFZIRApo3161xIQlMQAP9TBUf1tLUwOg505O1qSp3rm3kIF0foOjuEruGw7
         lKCmZIFkmkcppuU1aRhvwKEJXmAbYRdVQIssgNFGx0Brb+TlXZkl4xwgv/Je8HLJUDCi
         wU5wXfWdzdGSbjlVknkY18ASzWzhvdjKDwtz0lq12diGqdDKesnpP2TpjK+nkHfevTSg
         EhXg==
X-Gm-Message-State: ANoB5pmrnQKXsUQUWPpYLBJDE0ShIEgFuMEERif78Ds/TUPoeISAY+Et
        R0unJP7gdzSChAS9fa9e+jlJv8cGLrTzMEnd6EWdhQ==
X-Google-Smtp-Source: AA0mqf5aqKzttjrnb1OqvrG8kkaEEKNzEoqCcvs4iNMNIbXy21HLZHeOxKS9r/iLT7Q1DHMLtmZiuFuwFQoJhRb9n/I=
X-Received: by 2002:a25:2c6:0:b0:6fb:42d2:69e4 with SMTP id
 189-20020a2502c6000000b006fb42d269e4mr14292885ybc.436.1670080502548; Sat, 03
 Dec 2022 07:15:02 -0800 (PST)
MIME-Version: 1.0
References: <20221203094125.602812-1-liuyongqiang13@huawei.com>
In-Reply-To: <20221203094125.602812-1-liuyongqiang13@huawei.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Sat, 3 Dec 2022 20:44:51 +0530
Message-ID: <CALs4sv2DR2yoUi07aTsMVHiTCNPSBZXWsZOTKsBfLRfgUbOH=g@mail.gmail.com>
Subject: Re: [PATCH] net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq
To:     Yongqiang Liu <liuyongqiang13@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vlomovtsev@marvell.com, zhangxiaoxu5@huawei.com,
        weiyongjun1@huawei.com, sgoutham@marvell.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000020643405eeedebbe"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000020643405eeedebbe
Content-Type: text/plain; charset="UTF-8"

On Sat, Dec 3, 2022 at 3:11 PM Yongqiang Liu <liuyongqiang13@huawei.com> wrote:
>
> The nicvf_probe() won't destroy workqueue when register_netdev()
> failed. Add destroy_workqueue err handle case to fix this issue.
>
> Fixes: 2ecbe4f4a027 ("net: thunderx: replace global nicvf_rx_mode_wq work queue for all VFs to private for each of them.")
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> ---
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> index 98f3dc460ca7..f2f95493ec89 100644
> --- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> +++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
> @@ -2239,7 +2239,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         err = register_netdev(netdev);
>         if (err) {
>                 dev_err(dev, "Failed to register netdevice\n");
> -               goto err_unregister_interrupts;
> +               goto err_destroy_workqueue;
>         }
>
>         nic->msg_enable = debug;
> @@ -2248,6 +2248,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>         return 0;
>
> +err_destroy_workqueue:
> +       destroy_workqueue(nic->nicvf_rx_mode_wq);
>  err_unregister_interrupts:
>         nicvf_unregister_interrupts(nic);
>  err_free_netdev:
> --
> 2.27.0
>
Looks good to me.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

--00000000000020643405eeedebbe
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
XzCCBUwwggQ0oAMCAQICDBX9eQgKNWxyfhI1kzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODE3NDZaFw0yNTA5MTAwODE3NDZaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFBhdmFuIENoZWJiaTEoMCYGCSqGSIb3DQEJ
ARYZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAK3X+BRR67FR5+Spki/E25HnHoYhm/cC6VA6qHwC3QqBNhCT13zsi1FLLERdKXPRrtVBM6d0
mfg/0rQJJ8Ez4C3CcKiO1XHcmESeW6lBKxOo83ZwWhVhyhNbGSwcrytDCKUVYBwwxR3PAyXtIlWn
kDqifgqn3R9r2vJM7ckge8dtVPS0j9t3CNfDBjGw1DhK91fnoH1s7tLdj3vx9ZnKTmSl7F1psK2P
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKRibDU2SltuHobBJU2e5M5LENUK63BM
eTijJzGH5R9FMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
MzE1MTUwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBuV3u25qI0frBZFFxj7NsXCOkwEscWr6ieGuBD3/oeL8+mMCNT
54x8hOhru4HT2xCwoiqjzjvXGb5AFU9IQ79UuK0weWQ4o8yAH1nKlYZg3Gf8HgYTyt9W3bY5oYTO
tHbI6hMKFVilckSAw9SLGP+0TJJWYE5xuk6PK5a/Gs5A/8RCNn6JhGeLb8SHsnra2zyllAA504Jp
yNCNDdUX+F007yKd/rPqOgZTSWTwv3BQGv1kfC7eFv/1lu0eUqCycv3iYH3qqKywHkMLJ+V91I1/
TCEZiKhD0FkGYpxBdzkSEShWjOfTeKrkc9m9GMwM1jA4wtHRxsaTmfgqhcv3yzUD
--00000000000020643405eeedebbe--
