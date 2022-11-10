Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9C623B37
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiKJFYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKJFYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:24:15 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD2911A1A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:24:14 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id z17so537521qki.11
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 21:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rMPhJdVI5n8/pq6oYB9r7wEAfEK5nzmGyckM1o0mGvo=;
        b=Ex4r9t5FoG5jooOcKCHGWnL3sJLO3x0EybwEkGIXwB4ahi3+/3SboVTfkVdZfnoh0c
         w1TyVb+uvJ3BUednAvHzHXPOqm8uuFlReJ868MhIuZVSgW0CkH/1vsd0FrsTh8blTlV0
         mpR6TsHFAX49NWisvEd20AtLdOvAaBdm/WoK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMPhJdVI5n8/pq6oYB9r7wEAfEK5nzmGyckM1o0mGvo=;
        b=BPHvj338rncsIt9ngnSPYtQYTlcTA9CTFAjoopJrMIcyf31/aFFTxcAu66pRfL+MG1
         jvZmytRZ4CyPVud+BRdaja3gJUTKa7AvBUR4zE6lncHhdm5lWfTbrB4aGeTbbM/1B2h/
         EZHMj6kKIjNVMzRx6DuqriFOfF29W9LtRdBhPiX0zkiTwHtuJ1e4gQ/YdyGRfVl/wWZd
         FsgCl12RifjIFEa5/3/+fvjTG9sOU2EZem8twZAybztOVrtvGYIZUwujML+nshf2cm/6
         2o6b4Ta7M5mybZn1HO93Mf0AOCRRUtYJ0YTRTB2U6I64cxn8+yAZ3SJ6qhCTJjp7IQtn
         /PKw==
X-Gm-Message-State: ACrzQf1iiGIgC6R1xwBgnf6ZEEmHkBAA7aDwUNbWT0DCpVD+MPmsNuAN
        zxbbDlDAiF+FnnzUmtER+IrzBdw9xi/LYSpLFshzKA==
X-Google-Smtp-Source: AMsMyM5MqT3wvGBkCsgV6geyC4e2ip3yuIzOuz1WgUPON/wQKfw+XZJJUyAXBx48SBpnVZo42fdqPmwZvIby2KXKszE=
X-Received: by 2002:a05:620a:2589:b0:6ab:91fd:3f7 with SMTP id
 x9-20020a05620a258900b006ab91fd03f7mr46768452qko.104.1668057853482; Wed, 09
 Nov 2022 21:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20221109230945.545440-1-jacob.e.keller@intel.com> <20221109230945.545440-8-jacob.e.keller@intel.com>
In-Reply-To: <20221109230945.545440-8-jacob.e.keller@intel.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 10 Nov 2022 10:54:02 +0530
Message-ID: <CALs4sv3NLBXTAczVUDvwWj2AHOTdEvgij=u4VsK3XDPRzCPSsA@mail.gmail.com>
Subject: Re: [PATCH net-next 7/9] ptp: bnxt: convert .adjfreq to .adjfine
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d7528d05ed16fbfc"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d7528d05ed16fbfc
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 10, 2022 at 4:40 AM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
> When the BNXT_FW_CAP_PTP_RTC flag is not set, the bnxt driver implements
> .adjfreq on a cyclecounter in terms of the straightforward "base * ppb / 1
> billion" calculation. When BNXT_FW_CAP_PTP_RTC is set, the driver forwards
> the ppb value to firmware for configuration.
>
> Convert the driver to the newer .adjfine interface, updating the
> cyclecounter calculation to use adjust_by_scaled_ppm to perform the
> calculation. Use scaled_ppm_to_ppb when forwarding the correction to
> firmware.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 22 +++++--------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> index 460cb20599f6..4ec8bba18cdd 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -205,7 +205,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
>         return 0;
>  }
>
> -static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
> +static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
>  {
>         struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
>                                                 ptp_info);
> @@ -214,23 +214,13 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
>         int rc = 0;
>
>         if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
> -               int neg_adj = 0;
> -               u32 diff;
> -               u64 adj;
> -
> -               if (ppb < 0) {
> -                       neg_adj = 1;
> -                       ppb = -ppb;
> -               }
> -               adj = ptp->cmult;
> -               adj *= ppb;
> -               diff = div_u64(adj, 1000000000ULL);
> -
>                 spin_lock_bh(&ptp->ptp_lock);
>                 timecounter_read(&ptp->tc);
> -               ptp->cc.mult = neg_adj ? ptp->cmult - diff : ptp->cmult + diff;
> +               ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
>                 spin_unlock_bh(&ptp->ptp_lock);
>         } else {
> +               s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
> +
>                 rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
>                 if (rc)
>                         return rc;
> @@ -240,7 +230,7 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
>                 rc = hwrm_req_send(ptp->bp, req);
>                 if (rc)
>                         netdev_err(ptp->bp->dev,
> -                                  "ptp adjfreq failed. rc = %d\n", rc);
> +                                  "ptp adjfine failed. rc = %d\n", rc);
>         }
>         return rc;
>  }
> @@ -769,7 +759,7 @@ static const struct ptp_clock_info bnxt_ptp_caps = {
>         .n_per_out      = 0,
>         .n_pins         = 0,
>         .pps            = 0,
> -       .adjfreq        = bnxt_ptp_adjfreq,
> +       .adjfine        = bnxt_ptp_adjfine,
>         .adjtime        = bnxt_ptp_adjtime,
>         .do_aux_work    = bnxt_ptp_ts_aux_work,
>         .gettimex64     = bnxt_ptp_gettimex,
> --
> 2.38.0.83.gd420dda05763
>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

--000000000000d7528d05ed16fbfc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDrfgSZ7vEPh0FqoMEXy+OQQZCWhRR8v
7IBmM2X609F9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEx
MDA1MjQxM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAFS3muJVo5weL4jxKtshyk1Rnu3ks/A9aSuSbQwa6X2JS0GFl9
qq8J6DzrrWKM2CiuwtoxFh+znSR/dd9Vrx9Bhmsobr1Cnf4I0Xg3eZNmCyCYN7XTQcKsPXTvjJxI
x0Xx48bEjYIhz/NQ8rltyzx80CtEhFfK37wJHJlCh7OKeXTsFZoNv7Ymy0w8YCGDOvlaFHrpZmsz
kFj5AFIgYsjgt9nfvwQBGOvPza5J+TeUL/ywOE/qW17d1nHujsVixxJ5RHMQ/28iueQDUz9PKhJr
JIVJ2ZQ+jfjYvqr1PfB+WvpBKzTuaaq5Awv2ylF+UNp3zTiHCfT51AC+MtuFitTR
--000000000000d7528d05ed16fbfc--
