Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE3623B35
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiKJFXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiKJFXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:23:25 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7BB2193
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:23:24 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id cg5so419293qtb.12
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 21:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1VDfIprlCipKFy9lGTTY7vXy/jQ7xzYlHqSLaLpYJNI=;
        b=QB6Inl9BKGoFTHRZO7wisto2+PA7kQnDa1P6LHEq79Zjax5mYdY/GOw3lRul5Fg7kO
         cKGHCVU5cVJ9qtN4PEMNONQXgUE7BdvHRStOaDXVEANAsHwLpi2vztpd5FXo1d9G79ST
         zF22VM4brTWvWWPoZ/r2ZuzhVFNIg8dDM2ppQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VDfIprlCipKFy9lGTTY7vXy/jQ7xzYlHqSLaLpYJNI=;
        b=cB1u/zcZnMDKA/HyOW2Qzs1J5dhfIcGbNwB3OJ9RrmRls1Q7/ckaGyduW8YuFebff1
         nz0oNg4+GIaTwllMTaosFw4h2L1HpcyhqboD2BBHJW/2IgCYUMvyRyGyHzJVdflxKsuC
         ZiksgOpdYv2GqNY2Aqgaxqes1d5LqZC2okYrED5d3b+0BAfawFzbSDBdViF8UZs7LUwq
         HI5QzyI2TjebVtSlQkg4VUPqrzvaM5EpAw+yOI+z0HHWNg5/FlGkd4ezhw+ToswKu3zg
         Qufut+qLMyQcDcxtoLhyWGHpSwFjlTcI9G3fNig1DmMBRGkXoQr0jF36zYMfOUfWZhcb
         corw==
X-Gm-Message-State: ACrzQf2BlOotTiN8rBEfwlSkY4/DaxUytwSQTSUKtPenUw7hiH0fi7Tz
        Is7YZ08U25UeLdmjjIGJsGOB3E511jLxrTyEkoeyMw==
X-Google-Smtp-Source: AMsMyM4uKyhZd+JBKrtgnSnjw9RDAKOXxfQIyvn6pSmKzPzl3o50z5rQi1gyhmzP8Be8N5ohOI0aj3Moc2hm08Y4rSU=
X-Received: by 2002:ac8:4243:0:b0:3a5:1ac5:490d with SMTP id
 r3-20020ac84243000000b003a51ac5490dmr49188403qtm.269.1668057803392; Wed, 09
 Nov 2022 21:23:23 -0800 (PST)
MIME-Version: 1.0
References: <20221109230945.545440-1-jacob.e.keller@intel.com> <20221109230945.545440-4-jacob.e.keller@intel.com>
In-Reply-To: <20221109230945.545440-4-jacob.e.keller@intel.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 10 Nov 2022 10:53:12 +0530
Message-ID: <CALs4sv36OqxUm0gKsX3wBRZRaVUw1YSLjKsUc-FoXLypCWE2KA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/9] ptp: tg3: convert .adjfreq to .adjfine
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000da9efd05ed16f86c"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000da9efd05ed16f86c
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 10, 2022 at 4:40 AM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
> The tg3 implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
>
> Convert this to the newer .adjfine, using the recently added
> diff_by_scaled_ppm helper function to calculate the difference and
> direction of the adjustment.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
> Cc: Prashant Sreedharan <prashant@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 4179a12fc881..59debdc344a5 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -6179,34 +6179,26 @@ static int tg3_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
>         return 0;
>  }
>
> -static int tg3_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
> +static int tg3_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  {
>         struct tg3 *tp = container_of(ptp, struct tg3, ptp_info);
> -       bool neg_adj = false;
> -       u32 correction = 0;
> -
> -       if (ppb < 0) {
> -               neg_adj = true;
> -               ppb = -ppb;
> -       }
> +       u64 correction;
> +       bool neg_adj;
>
>         /* Frequency adjustment is performed using hardware with a 24 bit
>          * accumulator and a programmable correction value. On each clk, the
>          * correction value gets added to the accumulator and when it
>          * overflows, the time counter is incremented/decremented.
> -        *
> -        * So conversion from ppb to correction value is
> -        *              ppb * (1 << 24) / 1000000000
>          */
> -       correction = div_u64((u64)ppb * (1 << 24), 1000000000ULL) &
> -                    TG3_EAV_REF_CLK_CORRECT_MASK;
> +       neg_adj = diff_by_scaled_ppm(1 << 24, scaled_ppm, &correction);
>
>         tg3_full_lock(tp, 0);
>
>         if (correction)
>                 tw32(TG3_EAV_REF_CLK_CORRECT_CTL,
>                      TG3_EAV_REF_CLK_CORRECT_EN |
> -                    (neg_adj ? TG3_EAV_REF_CLK_CORRECT_NEG : 0) | correction);
> +                    (neg_adj ? TG3_EAV_REF_CLK_CORRECT_NEG : 0) |
> +                    ((u32)correction & TG3_EAV_REF_CLK_CORRECT_MASK));
>         else
>                 tw32(TG3_EAV_REF_CLK_CORRECT_CTL, 0);
>
> @@ -6330,7 +6322,7 @@ static const struct ptp_clock_info tg3_ptp_caps = {
>         .n_per_out      = 1,
>         .n_pins         = 0,
>         .pps            = 0,
> -       .adjfreq        = tg3_ptp_adjfreq,
> +       .adjfine        = tg3_ptp_adjfine,
>         .adjtime        = tg3_ptp_adjtime,
>         .gettimex64     = tg3_ptp_gettimex,
>         .settime64      = tg3_ptp_settime,
> --
> 2.38.0.83.gd420dda05763
>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

--000000000000da9efd05ed16f86c
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIE7d4qCMvhonQrGQKTXTUOeKi9zbjbPf
wX2b5LNzqy1UMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEx
MDA1MjMyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAPLzb/szR2jkCD4Rx7UKL/0kho/LzktUrYM/Sv/bK2VPwpcj7D
hWmCmMD4DVisYcO1r1u+wPHpvoXv1+Z1LKs7VkYT9o4z6qQ7M0buqy5dsc3gpr+oOIto1I+DCG0K
vAC5OWlQUEHE2OBYMBTosfi4CKkCQX6txAPTGraTrtjToUpH8+ieee4VZFZpTTMg2T6pb8qI+sjF
uG3yxrnSsYSpF7MgAskkM5lGMXanbwS/aXmLldEbDJnk9ZSSTgieT7Tb9XnNmGyhx1/kxZ4iWu6s
+S+dVtNL4bzWIrPLU3yJjmkSkbgpwoXGpND18aTHME8Atha2X0b5+MvxqY9x/mpg
--000000000000da9efd05ed16f86c--
