Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917136AC97D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCFRMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCFRMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:12:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5899B30E8A
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 09:12:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so9408733pjp.2
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678122677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6R4JXR8QbsDzrgnp3iE0NQ8tLZpucpzfh1OV98jPX58=;
        b=DfCR+2hP1FJpcqYSwXNy5nfgQBHF7B03SBenQT+NPdXWDWN2ghkmtOYBco0brqvoy8
         2RqlxfSxukn/lhQg+4hAmZa/WrvWrT5lUUozn+2R0xGVpy1czrZopkWze1fY6PFTTz3v
         3e0aGmaCr3XeU5ftqBlilNDQCUQY1iojJ/Ao0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678122677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6R4JXR8QbsDzrgnp3iE0NQ8tLZpucpzfh1OV98jPX58=;
        b=t0Fa1EajlkIL8KliNC1G2XxvgYRR76H55Q5F1l4nKXt6Kb8ibLzBu2grWJtlmusOc/
         jKDuYlhqEPKdUs917YwVMG8NYTqTnGJo1tHlV/fbhuYtuPAOB9T5LCMLMdLN6oedV/4R
         zCd2gDGwDH4xyt3ZkHOCOK4Yd78KaWfhTPCMipsDU993wsFa6Of079hlgBiZ3r9P7sLN
         5f2Pg6TpAFssu/zM8bVcxjRD6Tx3uHk5ksMP5iWyvc8t5taCcDPvVybgAFpu8scQsoe0
         sPxZYGktoNrE1djinKDfb+hxPPAQcLigXaIAmo4sh+ML5sEK/CeRidZuO+gbQTCxrHkH
         RvcQ==
X-Gm-Message-State: AO0yUKVJoncdREGidC6ErEz0J51/MAov9gDmxNmJR5nLPYG2+BbY93IC
        8UYQitnCYXCxKRBGjBENntVDT6KqvJWCzSr8speLWg==
X-Google-Smtp-Source: AK7set8q2lExQmx+Mx9cqtMED45NSb1tzQT64b+EA2Tg7Pj3lmpztpsiGLFzGC87IDkAlQ+FQ0U9TD2MIpIlAqKv6po=
X-Received: by 2002:a17:902:efce:b0:19b:5233:51d8 with SMTP id
 ja14-20020a170902efce00b0019b523351d8mr4754851plb.13.1678122676631; Mon, 06
 Mar 2023 09:11:16 -0800 (PST)
MIME-Version: 1.0
References: <20230306165344.350387-1-vadfed@meta.com>
In-Reply-To: <20230306165344.350387-1-vadfed@meta.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Mon, 6 Mar 2023 22:41:04 +0530
Message-ID: <CALs4sv1A1eTpH45Z=kyL3qtu7Yfu8JRW6Wc2r1d+UxjvB_EEEA@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000109f8f05f63e625b"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000109f8f05f63e625b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 6, 2023 at 10:23=E2=80=AFPM Vadim Fedorenko <vadfed@meta.com> w=
rote:
>
> When using a PHC in shared between multiple hosts, the previous
> frequency value may not be reset and could lead to host being unable to
> compensate the offset with timecounter adjustments. To avoid such state
> reset the hardware frequency of PHC to zero on init. Some refactoring is
> needed to make code readable.
>
Thanks for the patch.
I see what you are trying to do. But I think we have some build issues
with this.
Haven't looked at the whole patch, but one error I can spot is down at
the bottom.

> Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clo=
ck")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 57 +++++++++++--------
>  3 files changed, 36 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 5d4b1f2ebeac..8472ff79adf3 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -6989,11 +6989,9 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
>                 if (flags & FUNC_QCFG_RESP_FLAGS_FW_DCBX_AGENT_ENABLED)
>                         bp->fw_cap |=3D BNXT_FW_CAP_DCBX_AGENT;
>         }
> -       if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST)) {
> +       if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
>                 bp->flags |=3D BNXT_FLAG_MULTI_HOST;
> -               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> -                       bp->fw_cap &=3D ~BNXT_FW_CAP_PTP_RTC;
> -       }
> +
>         if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
>                 bp->fw_cap |=3D BNXT_FW_CAP_RING_MONITOR;
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.h
> index dcb09fbe4007..41e4bb7b8acb 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -2000,6 +2000,8 @@ struct bnxt {
>         u32                     fw_dbg_cap;
>
>  #define BNXT_NEW_RM(bp)                ((bp)->fw_cap & BNXT_FW_CAP_NEW_R=
M)
> +#define BNXT_PTP_RTC(bp)       (!BNXT_MH(bp) && \
> +                                ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
>         u32                     hwrm_spec_code;
>         u16                     hwrm_cmd_seq;
>         u16                     hwrm_cmd_kong_seq;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
> index 4ec8bba18cdd..99c1a53231aa 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -63,7 +63,7 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_=
info,
>                                                 ptp_info);
>         u64 ns =3D timespec64_to_ns(ts);
>
> -       if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> +       if (BNXT_PTP_RTC(ptp->bp))
>                 return bnxt_ptp_cfg_settime(ptp->bp, ns);
>
>         spin_lock_bh(&ptp->ptp_lock);
> @@ -196,7 +196,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *pt=
p_info, s64 delta)
>         struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnxt_p=
tp_cfg,
>                                                 ptp_info);
>
> -       if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> +       if (BNXT_PTP_RTC(ptp->bp))
>                 return bnxt_ptp_adjphc(ptp, delta);
>
>         spin_lock_bh(&ptp->ptp_lock);
> @@ -205,34 +205,39 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *=
ptp_info, s64 delta)
>         return 0;
>  }
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
> +       return rc;
> +}
> +
>  static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled=
_ppm)
>  {
>         struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnxt_p=
tp_cfg,
>                                                 ptp_info);
> -       struct hwrm_port_mac_cfg_input *req;
>         struct bnxt *bp =3D ptp->bp;
> -       int rc =3D 0;
>
> -       if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
> -               spin_lock_bh(&ptp->ptp_lock);
> -               timecounter_read(&ptp->tc);
> -               ptp->cc.mult =3D adjust_by_scaled_ppm(ptp->cmult, scaled_=
ppm);
> -               spin_unlock_bh(&ptp->ptp_lock);
> -       } else {
> -               s32 ppb =3D scaled_ppm_to_ppb(scaled_ppm);
> -
> -               rc =3D hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
> -               if (rc)
> -                       return rc;
> +       if (BNXT_PTP_RTC(ptp->bp))
> +               return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
>
> -               req->ptp_freq_adj_ppb =3D cpu_to_le32(ppb);
> -               req->enables =3D cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP=
_FREQ_ADJ_PPB);
> -               rc =3D hwrm_req_send(ptp->bp, req);
> -               if (rc)
> -                       netdev_err(ptp->bp->dev,
> -                                  "ptp adjfine failed. rc =3D %d\n", rc)=
;
> -       }
> -       return rc;
> +       spin_lock_bh(&ptp->ptp_lock);
> +       timecounter_read(&ptp->tc);
> +       ptp->cc.mult =3D adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
> +       spin_unlock_bh(&ptp->ptp_lock);
> +       return 0;
>  }
>
>  void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2)
> @@ -879,7 +884,7 @@ int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg)
>         u64 ns;
>         int rc;
>
> -       if (!bp->ptp_cfg || !(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
> +       if (!bp->ptp_cfg || !BNXT_PTP_RTC(bp))
>                 return -ENODEV;
>
>         if (!phc_cfg) {
> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>         atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>         spin_lock_init(&ptp->ptp_lock);
>
> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
> +       if (BNXT_PTP_RTC(ptp->bp)) {
>                 bnxt_ptp_timecounter_init(bp, false);
>                 rc =3D bnxt_ptp_init_rtc(bp, phc_cfg);
>                 if (rc)
>                         goto out;
>         } else {
>                 bnxt_ptp_timecounter_init(bp, true);
> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> +                       bnxt_ptp_adjfreq_rtc(bp, 0);

You meant bnxt_ptp_adjfine_rtc(), right.
Anyway, let me go through the patch in detail, while you may submit
corrections for the build.

>         }
>
>         ptp->ptp_info =3D bnxt_ptp_caps;
> --
> 2.30.2
>

--000000000000109f8f05f63e625b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJqy57uJLCywVzLBy9ygWPgfRrvR2R54
KJ9GM9ohdY6wMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMw
NjE3MTExN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBoOA4XwmUORSBaOspP+diFqhGnPVmqx49Zi47k82HnIoTcYZ4K
B5Cs+MUnMN+eeCP7PDfTzrc+xT+uLwn5c9qoY+aFKPQzWHunZ3xW71oMVqqc51mzKNro92Z3+v2v
yswT39wS4CB9SS2FQq8cJRdQiDjSX1cCPkkNHhOremv1l9NfgZCdDzYInmvcWAYWidWWzvAv/Gfe
J2KMuZLuIM6tJZFXJXkoReLPkIARZNC0JD/FC73l/M/imJfvZwMfww5CEwoX99CUHq5yRDycRkp7
1Hji0aSiJ1dZOrUV76FPyCjP0y3GayLqHDLgXvzBKPI3KcM6C4FQnHWhR7rB6U9y
--000000000000109f8f05f63e625b--
