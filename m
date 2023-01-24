Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863DC6791DF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjAXHZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjAXHZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:25:35 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A88A1204E
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:25:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso1093529pjj.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fSg1nNIuo297DIJDZ0wONRtki+fvRQBRUUvAyixHMeU=;
        b=eULOVgtQS9gHzuft5jfAT/K1GnB1o7qvSkWcK+IyHmAobvgx/tmCIR92f5NLLB/fKq
         UlygJmO35eeilszE6O/WThv9RWvk/Ev2JsBfWFb1/ayV/Uj01fS8EvtuRc6LeTunuvyV
         0E/9dWEGTF3dQU2UKoDRaiZX+4s+EoxpDvBYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSg1nNIuo297DIJDZ0wONRtki+fvRQBRUUvAyixHMeU=;
        b=b06ygEI7QuLky0Zh8m/GpmFk3WMSt+gjIpKhdwUltgHZSrTOYfmBrED4hTwEJfF+Hj
         qKca+jG0eOfgZ89hjh2+FrOWQRpSMr+dmn5VmuMfu0K9d6waXAmr0yJF8FHL2vdL3cBG
         OzB00FgB9T/C6jBEdR8OZvoGweYGgpI5Y7WZJ2w3fhVzYuYX9ciraOZSVeNNwoDFXe5H
         G+r5k98YnVWQnqsxrMpkkLvxCP1BdEdfSaljvbH4AHMNs9DOQAzPr9EKe0+bcHJ1tKMS
         1DztLaYcZMbs2Pcm8ftPI1bPM1SzpFm8ynGA8dZJvVTrs09bcxrZ+OuZkXkUjltIPDq9
         nihw==
X-Gm-Message-State: AFqh2kpERtEK7+TmdX9E23h9RjTOgaJIIlmfYy0EKZ3Ysipn+c/oFw3Q
        wg7TXR04RfK50jQTlnYd0BBdZbO80DQcXD4dh83OUg==
X-Google-Smtp-Source: AMrXdXvShSudGBZRTMLModzl4johCJlSjrQlH3asmbn+mXk/YlH0RYESXv7hCWQf1s67ucCfzMyVJcUW0+UIfsB7DfA=
X-Received: by 2002:a17:90a:f3c9:b0:226:d7e8:e11c with SMTP id
 ha9-20020a17090af3c900b00226d7e8e11cmr3249345pjb.111.1674545134519; Mon, 23
 Jan 2023 23:25:34 -0800 (PST)
MIME-Version: 1.0
References: <20230124003107.214307-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20230124003107.214307-1-drc@linux.vnet.ibm.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 24 Jan 2023 12:55:22 +0530
Message-ID: <CALs4sv1OYthkDYBbj9i-jytWo7VZ2rL9VcHiWP55svVX8R20RQ@mail.gmail.com>
Subject: Re: [PATCH] net/tg3: resolve deadlock in tg3_reset_task() during EEH
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ecd6b805f2fd6b34"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ecd6b805f2fd6b34
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 6:01 AM David Christensen
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
> Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
> Cc: Prashant Sreedharan <prashant@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 59debdc344a5..ee4604e6900e 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -11166,7 +11166,8 @@ static void tg3_reset_task(struct work_struct *work)
>         rtnl_lock();
>         tg3_full_lock(tp, 0);
>
> -       if (!netif_running(tp->dev)) {
> +       // Skip reset task if no netdev or already in PCI recovery
> +       if (!tp->dev || tp->pcierr_recovery || !netif_running(tp->dev)) {

Thanks for the patch. Can we not use netif_device_present() here?

>                 tg3_flag_clear(tp, RESET_TASK_PENDING);
>                 tg3_full_unlock(tp);
>                 rtnl_unlock();
> @@ -18101,6 +18102,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
>
>         netdev_info(netdev, "PCI I/O error detected\n");
>
> +       /* Want to make sure that the reset task doesn't run */
> +       tg3_reset_task_cancel(tp);
> +
>         rtnl_lock();
>
>         /* Could be second call or maybe we don't have netdev yet */
> @@ -18117,9 +18121,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
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

--000000000000ecd6b805f2fd6b34
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKZ6NDirPLO36m1Grn89+t7xgnpgWYY1
cHT07ub7W+s+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEy
NDA3MjUzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCAFlz2kOHxWuGQYdquQ7OgAU/kX9ndbIfDS0UI1Afaww643X0K
8cmC/MrcF6ct3DDM0ZFSqwff4Iz5n1wnLNDFsJ3qqKk97Z4iOkMBPbtJcf+gzfcy9agoE/XoAUCr
xCpwMDcg6yqpmyHImefyPiaLYGr4AgL+yQyCIpbrM1BxmWCbiqWMCtwP3d5QkL2WwHlgaWz3U22R
7enAe1+SI0+iKI1lrOfGi+UIG71TsS/Jbtdn6OW00S+XuL1KUfMDPFGnMCtQqqkcFKdRq2u0PHg+
L0wjiC0k3zY7+vacVPbvsbZ/Q6vzeZjsdCZho1yFx8d0ASYaqhie+sYlhNlkkN6J
--000000000000ecd6b805f2fd6b34--
