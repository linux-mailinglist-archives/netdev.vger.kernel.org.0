Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2294367ABD7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 09:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbjAYIeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 03:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbjAYIds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 03:33:48 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716B76A77
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:33:36 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w2so12883377pfc.11
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m12ICOxTmveJri2R2ed0Ea2FtI37uhPR7EGM+M28Uj0=;
        b=R/5EhroRk9K2foaBL8kGRio7wGBENprqHx9lHedwpixFFwRPEAA4avCNwb6b1aAXj5
         6Mkx1XVfJDabpGVsO7ptWiTGzurDVxyc7BgF9B5k4dlzxqyJxaq6ITL1AC2fn4iYxSku
         VFyKcMkX/OAEk11Dvh+h3sryD1JB3bbK7cPEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m12ICOxTmveJri2R2ed0Ea2FtI37uhPR7EGM+M28Uj0=;
        b=C5kmw946G8Js/wXtqKnE3sCZqdHxnntp4HUEO+8lSJ3UA8rQb7EQHI2vKRlwr5ETnP
         nqAjyLxTmQUe/1Kj2KJEAgTgyD4vnXLb6iYLvDzv1kG9CywX3fmUfp0ogixsFeJkQ0+I
         wKI/lb7vAGYguFYB63aAAG+kPTBuuvO0CCS3fb40l7NYe42Gcd0HOSatoBOjjl1xSvi1
         pKFYAID8QvEvDnSPL1W8YjBioeshUrFpAz+2r9ryQy+f/XadT2xM8T3KbFIJ/wsMPeq3
         PVt24Z76b7m9mtNJ8boMF1jiLyNMOYeDSEgV3r7LlX2aODXlOxJetg62+MMMkyzvxDp6
         LRIg==
X-Gm-Message-State: AFqh2kosBL+1IQmUuyXkTiK49YLR6VXyVuIg1JyWwMyw/2a7LzW3Ehby
        GOb7umuEYBOvoCHhNAwGk8w195bBsjXc8pzwng7qrw==
X-Google-Smtp-Source: AMrXdXulq+J/4U8OrvqWcYd56zAIiabB3aOMJs2MHCLqLmvOBgbumBAlGjZ7GfTr/8HzTd3SNOyRZSPOoMeMr0zMYU4=
X-Received: by 2002:a05:6a00:4c0b:b0:575:c692:3813 with SMTP id
 ea11-20020a056a004c0b00b00575c6923813mr3559372pfb.7.1674635615726; Wed, 25
 Jan 2023 00:33:35 -0800 (PST)
MIME-Version: 1.0
References: <20230124003107.214307-1-drc@linux.vnet.ibm.com> <20230124185339.225806-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20230124185339.225806-1-drc@linux.vnet.ibm.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 25 Jan 2023 14:03:24 +0530
Message-ID: <CALs4sv0=m9zXHX0j2o-36AEUNkK1PVeHM5YirRMD7GLUqU=umQ@mail.gmail.com>
Subject: Re: [PATCH v2] net/tg3: resolve deadlock in tg3_reset_task() during EEH
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, siva.kallam@broadcom.com,
        prashant@broadcom.com, mchan@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000008041b05f3127d3c"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000008041b05f3127d3c
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 25, 2023 at 12:23 AM David Christensen
<drc@linux.vnet.ibm.com> wrote:
>
> During EEH error injection testing, a deadlock was encountered in the tg3
> driver when tg3_io_error_detected() was attempting to cancel outstanding
> reset tasks:
>
> crash> foreach UN bt
> ...
> PID: 159    TASK: c0000000067c6000  CPU: 8   COMMAND: "eehd"
> ...
>  #5 [c00000000681f990] __cancel_work_timer at c00000000019fd18
>  #6 [c00000000681fa30] tg3_io_error_detected at c00800000295f098 [tg3]
>  #7 [c00000000681faf0] eeh_report_error at c00000000004e25c
> ...
>
> PID: 290    TASK: c000000036e5f800  CPU: 6   COMMAND: "kworker/6:1"
> ...
>  #4 [c00000003721fbc0] rtnl_lock at c000000000c940d8
>  #5 [c00000003721fbe0] tg3_reset_task at c008000002969358 [tg3]
>  #6 [c00000003721fc60] process_one_work at c00000000019e5c4
> ...
>
> PID: 296    TASK: c000000037a65800  CPU: 21  COMMAND: "kworker/21:1"
> ...
>  #4 [c000000037247bc0] rtnl_lock at c000000000c940d8
>  #5 [c000000037247be0] tg3_reset_task at c008000002969358 [tg3]
>  #6 [c000000037247c60] process_one_work at c00000000019e5c4
> ...
>
> PID: 655    TASK: c000000036f49000  CPU: 16  COMMAND: "kworker/16:2"
> ...:1
>
>  #4 [c0000000373ebbc0] rtnl_lock at c000000000c940d8
>  #5 [c0000000373ebbe0] tg3_reset_task at c008000002969358 [tg3]
>  #6 [c0000000373ebc60] process_one_work at c00000000019e5c4
> ...
>
> Code inspection shows that both tg3_io_error_detected() and
> tg3_reset_task() attempt to acquire the RTNL lock at the beginning of
> their code blocks.  If tg3_reset_task() should happen to execute between
> the times when tg3_io_error_deteced() acquires the RTNL lock and
> tg3_reset_task_cancel() is called, a deadlock will occur.
>
> Moving tg3_reset_task_cancel() call earlier within the code block, prior
> to acquiring RTNL, prevents this from happening, but also exposes another
> deadlock issue where tg3_reset_task() may execute AFTER
> tg3_io_error_detected() has executed:
>
> crash> foreach UN bt
> PID: 159    TASK: c0000000067d2000  CPU: 9   COMMAND: "eehd"
> ...
>  #4 [c000000006867a60] rtnl_lock at c000000000c940d8
>  #5 [c000000006867a80] tg3_io_slot_reset at c0080000026c2ea8 [tg3]
>  #6 [c000000006867b00] eeh_report_reset at c00000000004de88
> ...
> PID: 363    TASK: c000000037564000  CPU: 6   COMMAND: "kworker/6:1"
> ...
>  #3 [c000000036c1bb70] msleep at c000000000259e6c
>  #4 [c000000036c1bba0] napi_disable at c000000000c6b848
>  #5 [c000000036c1bbe0] tg3_reset_task at c0080000026d942c [tg3]
>  #6 [c000000036c1bc60] process_one_work at c00000000019e5c4
> ...
>
> This issue can be avoided by aborting tg3_reset_task() if EEH error
> recovery is already in progress.
>
> Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> ---
> History:
>
> v2: Remove tp->dev check
> ---
>  drivers/net/ethernet/broadcom/tg3.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
Thanks.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 59debdc344a5..58747292521d 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -11166,7 +11166,7 @@ static void tg3_reset_task(struct work_struct *work)
>         rtnl_lock();
>         tg3_full_lock(tp, 0);
>
> -       if (!netif_running(tp->dev)) {
> +       if (tp->pcierr_recovery || !netif_running(tp->dev)) {
>                 tg3_flag_clear(tp, RESET_TASK_PENDING);
>                 tg3_full_unlock(tp);
>                 rtnl_unlock();
> @@ -18101,6 +18101,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
>
>         netdev_info(netdev, "PCI I/O error detected\n");
>
> +       /* Want to make sure that the reset task doesn't run */
> +       tg3_reset_task_cancel(tp);
> +
>         rtnl_lock();
>
>         /* Could be second call or maybe we don't have netdev yet */
> @@ -18117,9 +18120,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
>
>         tg3_timer_stop(tp);
>
> -       /* Want to make sure that the reset task doesn't run */
> -       tg3_reset_task_cancel(tp);
> -
>         netif_device_detach(netdev);
>
>         /* Clean up software state, even if MMIO is blocked */
> --
> 2.31.1
>

--00000000000008041b05f3127d3c
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOwx8H+Sgcjc2SIy5DUxmiDpsggm7g+P
i9uoe00xAi7TMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEy
NTA4MzMzNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBBmlJovS6NOMfDubYW9nkCz1RTTq2DCpqMIlPXsTFGgSQJY306
7SBUXDqp4PlrlzAKmJH8lhxf9JG184sKJ8J0CfXSx6nvmGOfKX5zXvtiK9fU/c+Bcsk7WWxZV/nf
GYNbYUdTMPDPpOuMPcNvqPNp5dJCCUAklS+f+n0lX3RuuGJKBbhU9iZxZQFykKRQwx2Hqxtyd5zg
QmuicsciPzXxittPyE//uysDcd51CU2ERcEEM/c6pZXbSDgujBS1P5i6vj6ZgA45MtJbZczNclpN
4GmZSBvIwY4+YrM4O70Nvu0gEEbyE3yoEYeZjwbutmYSrme5KH9Lfhd9FYqkaK0t
--00000000000008041b05f3127d3c--
