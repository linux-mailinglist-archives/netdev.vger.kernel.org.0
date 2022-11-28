Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A276363A0B6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 05:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiK1E5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 23:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiK1E5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 23:57:43 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC04E5A
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 20:57:42 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id c140so11896892ybf.11
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 20:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=raRY/PnsSt1sXG08h/JJPlgv6UVslvyYu1teQHTmA1w=;
        b=gteGlmHJ3eR9jErr6a7CxSVB2ZoSxGaeK2Vkm3rFDGLzlP0TDiRo7b0Yi2wAB5reDO
         qct5SfXXnOaI3CDUuwvSwKn6tfNke4s+Ea5ccscLQOTUoyL6J66K/YVMtX/131GLsYt/
         naO9axvisrUVtzMyQ86yd07gXYKFb7pa/sOKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=raRY/PnsSt1sXG08h/JJPlgv6UVslvyYu1teQHTmA1w=;
        b=i+96HLlXlvUrvJn9gazp16/92g67SEqb7g2JGXZOV02ra92aV7QY4bSGaW91hqJ3Lb
         5csuOvX02GC22KtMh84KIZa3loPVonlrYJKpupWAlGpl8sMUZR+nOsa6WpBx9wT7xzyT
         oWTOIudHWXDjPMys23VXt3V0ucvqMy5i/KNv++zNfhCaiZE62dMc3HvRV8OleO9FFNbW
         fc2DKkzpH99eIzQ1UeYggqj/OQSpcVRbHXSr/b5IWWtXAO7f+05rAGe/Ie0jLOlTOM9G
         MZkl6UJIXLbyxuBfdpuNH27tmnxRq++Y2h6SR4+XE3DFHFNSmkFFpHigJOHU2rZ6Km7J
         5SMg==
X-Gm-Message-State: ANoB5pmo2OrSuD9GUzO2qjlkvBt4WeZlBU6oQ2xO8u2SEOh/VnHEtPSd
        NhLesHZvFL8JkfkKdFIRYXN+COylVYu5CP4jhIEz7w==
X-Google-Smtp-Source: AA0mqf7fNNsFel5LktCof5/AZLeyNSFykkANwBLI5USCzPsP1tPZlwwtWE1i2dU7jwDNRWwj2pCwtVxGc+PzOh/H9aw=
X-Received: by 2002:a25:7309:0:b0:6f3:3021:80ff with SMTP id
 o9-20020a257309000000b006f3302180ffmr13622714ybc.436.1669611461401; Sun, 27
 Nov 2022 20:57:41 -0800 (PST)
MIME-Version: 1.0
References: <7779439b2678fffe7d3e4e0d94bbb1b1eb850f5e.1669565797.git.christophe.jaillet@wanadoo.fr>
 <CALs4sv1x5kqHVu=q=kifSPXc=yhobowRvQhjkhG-3UwW2ZzbPg@mail.gmail.com>
In-Reply-To: <CALs4sv1x5kqHVu=q=kifSPXc=yhobowRvQhjkhG-3UwW2ZzbPg@mail.gmail.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Mon, 28 Nov 2022 10:27:30 +0530
Message-ID: <CALs4sv24PiCW_9svBCLF8W+rkb=w90fBCEYOuFAkozXUQu_kLQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Remove unneeded io-mapping.h #include
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000017440f05ee80b654"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000017440f05ee80b654
Content-Type: text/plain; charset="UTF-8"

Though I think having the target tree specified conventionally in the
subject line [PATCH net] would be more complying with the process.

On Mon, Nov 28, 2022 at 9:57 AM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>
> On Sun, Nov 27, 2022 at 9:47 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
> >
> > The mlx5 net files don't use io_mapping functionalities. So there is no
> > point in including <linux/io-mapping.h>.
> > Remove it.
> >
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/cmd.c  | 1 -
> >  drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 -
> >  drivers/net/ethernet/mellanox/mlx5/core/uar.c  | 1 -
> >  3 files changed, 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > index 74bd05e5dda2..597907fd63f5 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > @@ -37,7 +37,6 @@
> >  #include <linux/slab.h>
> >  #include <linux/delay.h>
> >  #include <linux/random.h>
> > -#include <linux/io-mapping.h>
> >  #include <linux/mlx5/driver.h>
> >  #include <linux/mlx5/eq.h>
> >  #include <linux/debugfs.h>
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 70e8dc305bec..25e87e5d9270 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -37,7 +37,6 @@
> >  #include <linux/pci.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/slab.h>
> > -#include <linux/io-mapping.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/delay.h>
> >  #include <linux/mlx5/driver.h>
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
> > index 8455e79bc44a..1513112ecec8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
> > @@ -31,7 +31,6 @@
> >   */
> >
> >  #include <linux/kernel.h>
> > -#include <linux/io-mapping.h>
> >  #include <linux/mlx5/driver.h>
> >  #include "mlx5_core.h"
> >
> > --
> > 2.34.1
> >
>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

--00000000000017440f05ee80b654
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDTlJDpsi9xLbFzf9dKxcGjINDooNox1
YE9doRQGXUhcMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEy
ODA0NTc0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCWNj5EM4Qi/MboBFuTWEJRqGWizf/MTy57q+p09CpRNSLN56wO
YDTlwv+nn7cbhcQS20OR5Iynyily4lk1ErwO9IV9GPabvKRu9LjxYx9U/ugup+KV+JibDuPK3ui/
uc9WrLTgDkeyCDXkcfgp8/0qDbamjWHL19tStGFoBHZH/bHa7YWbgbp6NcPaaBh5ZllMuneR2gKm
NYJS8Tk5ODbXBPT7da5LTXI8K3I39sdhdY9vUHVO80j+ZUTluZ2LhykSemHmqQtwR/Fub/3HzKDF
dHGOrWDJ/PIsJ0+4B9ZfydWdk3psfruvchN5Ps399MvBiuTStVyyitkHQw6X1Fas
--00000000000017440f05ee80b654--
