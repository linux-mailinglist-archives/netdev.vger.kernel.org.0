Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4A6B35E0
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCJFFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCJFFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:05:08 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66E8D8871
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:04:57 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s17so2404178pgv.4
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678424697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qCiuzwXBkUvrJuZx24vS+2W+HBJcG7KZZUa5pdlENUk=;
        b=YEsONYDXi0VeeV9RmELF6OAzKBM+Y6Hop9I5uyo89iUjPteKOIX7B2uFMSP6ueAyOB
         5OiXNTwb6b4rAEBgOFuympkQwI2i9AfxqvBb7tVrXnFa8nD/g4v4Jrhsaz5Q8oy+hPud
         dA9LsIPg6MF3oQ/QvEznpEb/ZcOGJUqHEAPWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qCiuzwXBkUvrJuZx24vS+2W+HBJcG7KZZUa5pdlENUk=;
        b=NOVM3YWNF//HHS39N71+otbItH+j9nHhSFQ92rIZb/FjxEOch3+nMigbfiOMMFBkrK
         7xMLuPBS6TJzjKwF62VPU0I5ct4hjxZdqhTFQiPBd8FrB89AvMhxnbBArYbRwWC95zF1
         NKSbnR+ZxxD2WUIzmj9uO0F0e4QTgdPyRb8m8J2fALI/1YRv0ycNJ6YFCnloJSsNn7nh
         GzPXOhuSvvDnL3qFiyofChiOVRqxkqenJhhXvL07konBoxs6c+L+6OrDRPlI1adpinOw
         4FnxMQnrSMkINTV0KhiHCY8K1E7y4Rl3rso33Hrfc3SpjwKYV4OXViImZ66BzErE9IQo
         XphA==
X-Gm-Message-State: AO0yUKUL6bNFpBYM0NdfoTnfHxi4nU4oG9+fumy0xNl5hxcUaGU/Uwtx
        k7Q9FSpZ7ENjZ+bTvpbmMJsRE/L4pi7/d6nMQc7RrA==
X-Google-Smtp-Source: AK7set+Tee8punGB9ya1brzqPiCwjQZ5vUn3tJD76UdbrjaS/+z7GY1Fo99bqb2PSW3UUm5K6rspy/bgZx/3Zx2qYPk=
X-Received: by 2002:a62:d115:0:b0:593:af1e:15b with SMTP id
 z21-20020a62d115000000b00593af1e015bmr9882566pfg.4.1678424696985; Thu, 09 Mar
 2023 21:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20230309215347.2764771-1-vadfed@meta.com>
In-Reply-To: <20230309215347.2764771-1-vadfed@meta.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Fri, 10 Mar 2023 10:34:45 +0530
Message-ID: <CALs4sv2cg9ojQNn+V0sVDCW0b-ukL3xZ4jgm5qcVbx232vzJNQ@mail.gmail.com>
Subject: Re: [PATCH net v3] bnxt_en: reset PHC frequency in free-running mode
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e0449005f684b382"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e0449005f684b382
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 3:24=E2=80=AFAM Vadim Fedorenko <vadfed@meta.com> w=
rote:
>
> When using a PHC in shared between multiple hosts, the previous
> frequency value may not be reset and could lead to host being unable to
> compensate the offset with timecounter adjustments. To avoid such state
> reset the hardware frequency of PHC to zero on init. Some refactoring is
> needed to make code readable.
>
> Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clo=
ck")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 60 ++++++++++---------
>  3 files changed, 37 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 808236dc898b..e2e2c986c82b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -6990,11 +6990,9 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
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
> index dcb09fbe4007..c0628ac1b798 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -2000,6 +2000,8 @@ struct bnxt {
>         u32                     fw_dbg_cap;
>
>  #define BNXT_NEW_RM(bp)                ((bp)->fw_cap & BNXT_FW_CAP_NEW_R=
M)
> +#define BNXT_PTP_USE_RTC(bp)   (!BNXT_MH(bp) && \
> +                                ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
>         u32                     hwrm_spec_code;
>         u16                     hwrm_cmd_seq;
>         u16                     hwrm_cmd_kong_seq;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
> index 4ec8bba18cdd..a96adde97e60 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -63,7 +63,7 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_=
info,
>                                                 ptp_info);
>         u64 ns =3D timespec64_to_ns(ts);
>
> -       if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> +       if (BNXT_PTP_USE_RTC(ptp->bp))
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
> +       if (BNXT_PTP_USE_RTC(ptp->bp))
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
> +       if (BNXT_PTP_USE_RTC(bp))
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
> +       if (!bp->ptp_cfg || !BNXT_PTP_USE_RTC(bp))
>                 return -ENODEV;
>
>         if (!phc_cfg) {
> @@ -932,13 +937,14 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>         atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>         spin_lock_init(&ptp->ptp_lock);
>
> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
> +       if (BNXT_MH(bp)) {

Using BNXT_MH(bp) inside bnxt_ptp_init() will not work because
bnxt_ptp_init() is being called much before we determine it is an MH
system.
I may have alluded to this change in v2 comments but I realize that we
don't have the MH determined yet. I am sure your test would not pass
with this patch.
We plan to make that change in the upstream driver to move the
bnxt_ptp_init() to a later point, after we know the type of host.
For now, I think you can simply call bnxt_ptp_adjfine_rtc(bp, 0); when
you see it is a non-RTC host. Much like in v2, except the condition.

if (BNXT_PTP_USE_RTC(ptp->bp)) {
        bnxt_ptp_timecounter_init(bp, false);
        rc =3D bnxt_ptp_init_rtc(bp, phc_cfg);
        if (rc)
           goto out;
} else {
        bnxt_ptp_timecounter_init(bp, true);
        bnxt_ptp_adjfine_rtc(bp, 0);
}

Rest everything looks OK.

> +               bnxt_ptp_timecounter_init(bp, true);
> +               bnxt_ptp_adjfine_rtc(bp, 0);
> +       } else {
>                 bnxt_ptp_timecounter_init(bp, false);
>                 rc =3D bnxt_ptp_init_rtc(bp, phc_cfg);
>                 if (rc)
>                         goto out;
> -       } else {
> -               bnxt_ptp_timecounter_init(bp, true);
>         }
>
>         ptp->ptp_info =3D bnxt_ptp_caps;
> --
> 2.34.1
>

--000000000000e0449005f684b382
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICHRcWnloZiWjqdmIzUsW8UpOi6BYIav
+j+lKFp7FXxcMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMx
MDA1MDQ1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAalk2ULY02BuKrTM/LLCIZLT9VqXK1lQ2dDa0NXt0E4X723rAb
MbTtEIEcypKNR/xWCQ5XBaW/jUt2A6V9xXZhGHLki4Jvk1AIOLknbp5vPjv6nr1vAUb5DdRBGbW2
LZZ8J+ZQhrLSWcIR6s9LB518aFs2ZL/XSeVdcUi2EtP4+bL+G1nQGutqiDJMBzY/SSrn1jJL+XOS
BQGIygLLh8dTt/W7aa6pnfjqQf3iTFhycxXsU79hREEZIOnOez7BIuI2vXKLi5v87cHqZD51jFZc
JeNntGR/34S0mtpdFnGlRFbzpZQHmSAT5QBIL/h8fVJvlkZmzq6qLhcXhxHpQtdW
--000000000000e0449005f684b382--
