Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB665BCA3
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbjACJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjACJBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:01:09 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73929DFCD
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:01:04 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 124so20111540pfy.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zaMFiJ4An+xK/9Xz8K5zV0eaiWDnKxoZ5zO0OhBB83E=;
        b=SEWKzmmYi5qCZBoNPUajuq+tWfOnB4QVIkGbfX+S5WNl5VJ4i2ckIOIjsdqPdovU0t
         XK3tiAUCsaI0fyo1wVgHRNjugmhuvqM5hGOXtJacWKK7zrbJeOUPxIG1hytjqM8R7073
         8VcdD/6SBsIPAOoxBPIzmIWSbJVPaYiTKvwaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zaMFiJ4An+xK/9Xz8K5zV0eaiWDnKxoZ5zO0OhBB83E=;
        b=xG/IT4d3Q0KelwtSrV5h0JIjNvNEVDyVO6A2LGfjPUAp6Br0y/irGHTGUTA0auMg8q
         S7GIcC6foF9B/rfHaybJ3AAFoH/QKtFadpRdiHVTcmqsERB4RRmYFZUYPgjBlWgW+kZp
         1kcglTL52ci5m6SsuIWpugqebkgxn52/84DKj2R5RRrQ5w1EffacYcU3Zh9XVHT6zUem
         sznjI1VzrQSZSWG0Br61tADaKVlAluWDjvUSdwixBVS1OWlzS+16Sxm2BJ0fQ2596kty
         q2UOoetO2IaJh1Gd4nHa+7oTD79xEN4Ye4M9EBiKSVtunlBQ+vUa8O20FGKbicYXywLm
         wIuw==
X-Gm-Message-State: AFqh2krKJNG85VurZ09bQxxjlJ/9YUkNrd99FL3esk68F8L6WvFIPk71
        EFPCjCxHN6dLzGsFGwSLj5dSm9Ls5vZvKZx9P/aRvQ==
X-Google-Smtp-Source: AMrXdXvocEWe5ARuGEGCBx87YhxDtQUGRJBRoSPN/WqSj/spVUuw8smthrxFH2sARgXk5ncAtVaP9FzDhTjRU5nYRPM=
X-Received: by 2002:a05:6a00:2487:b0:57a:a199:902f with SMTP id
 c7-20020a056a00248700b0057aa199902fmr2904612pfv.52.1672736463368; Tue, 03 Jan
 2023 01:01:03 -0800 (PST)
MIME-Version: 1.0
References: <20230103040917.16151-1-gakula@marvell.com>
In-Reply-To: <20230103040917.16151-1-gakula@marvell.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 3 Jan 2023 14:30:52 +0530
Message-ID: <CALs4sv2ivFBfYA0K-ghN3oy-OAXo-zQfyzHXHpm9eTpiPuw5pw@mail.gmail.com>
Subject: Re: [PATCH net] octeontx2-af: Fix QMEM struct memory allocation
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bcd07b05f1584eb9"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bcd07b05f1584eb9
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 3, 2023 at 9:39 AM Geetha sowjanya <gakula@marvell.com> wrote:
>
> Currently NIX, NPA queue context memory is being allocated using
> GFP_KERNEL flag which inturns allocates from memory reserved for
> CMA_DMA. Sizing CMA_DMA memory is getting difficult due to this
> dependency, the more number of interfaces enabled the more the
> CMA_DMA memory requirement.
>
> To address this issue, GFP_KERNEL flag is replaced with GFP_ATOMIC,
> with this memory will be allocated from unreserved memory.
>
> Fixes: 7a37245ef23f ("octeontx2-af: NPA block admin queue init")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
> index 8931864ee110..4b4be9ca4d2f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
> @@ -61,7 +61,7 @@ static inline int qmem_alloc(struct device *dev, struct qmem **q,
>         qmem->entry_sz = entry_sz;
>         qmem->alloc_sz = (qsize * entry_sz) + OTX2_ALIGN;
>         qmem->base = dma_alloc_attrs(dev, qmem->alloc_sz, &qmem->iova,
> -                                    GFP_KERNEL, DMA_ATTR_FORCE_CONTIGUOUS);
> +                                    GFP_ATOMIC, DMA_ATTR_FORCE_CONTIGUOUS);

I am not understanding the problem this change is solving. Can you
describe the issue in some detail?
What do you mean when you say GFP_ATOMIC allocates the memory from
unreserved memory?

>         if (!qmem->base)
>                 return -ENOMEM;
>
> --
> 2.25.1
>

--000000000000bcd07b05f1584eb9
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGLLKocO1SZ40DesW2jav8jk+MtLtDRd
FPvXVJHULAjrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEw
MzA5MDEwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBX2FOTZkS+R5YWZk4CrUupKoy2vB7opEvqzMp69OmhxozAL52d
JCLzjqa0twbbOl3oyM3LI2ny5o09szPYM45qWoeDHDY9DZhYa1hxg8zU0A2gH2vXkhm//15QmBVU
NawafjofQfJhbI/aMac5HqymmL0upRNnBcwuk4dMd+/4eRwvLTMaixgdzNBYWW1lXLAJp9j3q/O4
BxtZ/KwB/RhX6Tkbi54vEP3+N3/w5B+2m/+7YAfAGX63sOoRh41DDIcGVhX6bp0zXGdbXI69zC50
dcwede9rS1AVpZN8VdcDIJUpSVcZ7lX4BYrjwVfMjAoQQyEe6jQixQ+n7puxRx0j
--000000000000bcd07b05f1584eb9--
