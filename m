Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC286B1A78
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 05:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCIEkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 23:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCIEkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 23:40:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1E4BF8C9
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 20:40:44 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id fd25so747742pfb.1
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 20:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678336844;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9EvcIs840oePhaKE6KWBasWpO6E57+aWNa0JTc5esk=;
        b=APoYw2uMcSCk1MtUPFh4n8bEROc7rr0Fqu30OkKggCXQpZcjtUm7a+QlkfRKibWFRz
         MDn8uwkAEoLNbxqLhjsRQDK+A+gxT8Tb3iV9J7owfhqrSSrOwrgxpRbsfCaOXybYRD8D
         IN9/m/id1KfHbI+L/azCcecUWuaaI+0C6uJqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678336844;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q9EvcIs840oePhaKE6KWBasWpO6E57+aWNa0JTc5esk=;
        b=b4iRyEXcv1+aq1oJKUVSulT9LsWgxiD3e2RFIHEcmk8LZInB3t+Q3IC3Yzg8GZRbb0
         yu2nqEDuuBnx4tlCWzcP68JxcofhEeu8TqNBst+2Vi9cDVW5JXY8vJeOVrFDP6mp86+C
         0t6C5R7VxjibNB6mKHPew8nC9hW8sNUFAPDn2aT+UVxKRBohPgzUAnLDAbzGuGPKlCNr
         o3xHdSMX8kthBJAna0rAlq21iyCbHaiJbl7mFUV5XhSGl9ZbsuJt95iVZBmrdT74jS3v
         c80fDR5flJh2oZBC2JRtMJcMiTHQIC86v0LLhFpQywq7iAnzscscGLrRjA34iwwTfGi8
         vcIQ==
X-Gm-Message-State: AO0yUKV4W0cn406iVo4U+Oe6c6elSjlgfSaxaxBjr6eRVBhLw0CwkE6a
        rBc54I+SKm1mlFz/rT99/rRocwYB0c61AzzFpvtuNA==
X-Google-Smtp-Source: AK7set8Dd97rqz1jHBV1TjPeVMwtfCAKHgowS5p+638wgyG2RTMM002V6YwMCYE61wxOuvyiPWlDPVbQfDr+HkFDDFY=
X-Received: by 2002:a05:6a00:8cd:b0:606:a4bd:8dde with SMTP id
 s13-20020a056a0008cd00b00606a4bd8ddemr8795277pfu.4.1678336844159; Wed, 08 Mar
 2023 20:40:44 -0800 (PST)
MIME-Version: 1.0
References: <20230308144209.150456-1-vadfed@meta.com>
In-Reply-To: <20230308144209.150456-1-vadfed@meta.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 9 Mar 2023 10:10:32 +0530
Message-ID: <CALs4sv3+jKGA=z-Nb1akw2h1jkL6T7VLj4pV7KVsZwx1Gt+DnA@mail.gmail.com>
Subject: Re: [PATCH net v2] bnxt_en: reset PHC frequency in free-running mode
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006e789705f6703f8e"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006e789705f6703f8e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 8, 2023 at 8:12=E2=80=AFPM Vadim Fedorenko <vadfed@meta.com> wr=
ote:
>
> +static int bnxt_ptp_adjfine_rtc(struct bnxt *bp, long scaled_ppm)
> +{
> +       s32 ppb =3D scaled_ppm_to_ppb(scaled_ppm);
> +       struct hwrm_port_mac_cfg_input *req;
> +       int rc;
> +
> +       rc =3D hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
> +       if (rc)
> +               return rc;
> +
> +       req->ptp_freq_adj_ppb =3D cpu_to_le32(ppb);
> +       req->enables =3D cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_AD=
J_PPB);
> +       rc =3D hwrm_req_send(bp, req);
> +       if (rc)
> +               netdev_err(bp->dev,
> +                          "ptp adjfine failed. rc =3D %d\n", rc);

nit: can be a single line.

> +       return rc;
> +}
> +

> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>         atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>         spin_lock_init(&ptp->ptp_lock);
>
> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
> +       if (BNXT_PTP_USE_RTC(ptp->bp)) {
>                 bnxt_ptp_timecounter_init(bp, false);
>                 rc =3D bnxt_ptp_init_rtc(bp, phc_cfg);
>                 if (rc)
>                         goto out;
>         } else {
>                 bnxt_ptp_timecounter_init(bp, true);
> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)

I understand from your response on v1 as to why it will not affect you
if a new firmware does not report RTC on MH.
However, once you update the fw, any subsequent kernels upgrades will
prevent resetting the freq stored in the PHC.
Would changing the check to if (BNXT_MH(bp)) instead be a better option?

> +                       bnxt_ptp_adjfine_rtc(bp, 0);
>         }
>
>         ptp->ptp_info =3D bnxt_ptp_caps;
> --
> 2.30.2
>

--0000000000006e789705f6703f8e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL2RK3JRJRzsJ8FxLPRvM4tcPnWeVj/+
4NKWHS2VV95PMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMw
OTA0NDA0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCEd/Pc8xatCefntrzmbpOUc+C7nZqaE3otXWK5obCYAnyQmxX7
eswclr70YIR0VAjrgWFXHDyZ6Gs2CSVovcxuPk3h7d8x/s6MMAuHDga/bEOD/eNX0PkHyq4nVn0O
yQUmUERlbz0NMLG/OR/CZMKEKMgdyWZuW/SOTkCJmnLSouaA2TYxeaFRFNbauYjAAK25QAx6Nfwn
ZXxF8OSQDPUnIhVZOLfhk3x6dBOw3Gh6gUhonX/AR67gGIw+IAd0VMrTpUPHjwmLWV9nFprHVLT8
3FnSKpLUI+OgWNZ3XWOz7bbbRsvXNXH88TYT+X59BHYVqPGZODpRheuYiwANveSA
--0000000000006e789705f6703f8e--
