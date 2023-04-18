Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99FF6E5E7C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjDRKTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDRKTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:19:39 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F9A61A7
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:19:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id vc20so16849088ejc.10
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1681813158; x=1684405158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qrZZDhnTRsh8UXDemggcIk9KLAcSTPNlDtBu/X6RMw0=;
        b=IWt5qDGbp7rnb92IGDSximfKwE30HGh0hxJhAPS6sDYZbV1SozOpc/1Eez7+yCvEU/
         +AjS6Ne0VVE00yb2a8crAk05+zE8/1ogJeq8HF0xbOBrfSoL0JHoNDMrpJvRqyRPtOhS
         8KTTPa3ILArnfacBcrUbBYgwHJHIqmvSUTQE4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681813158; x=1684405158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qrZZDhnTRsh8UXDemggcIk9KLAcSTPNlDtBu/X6RMw0=;
        b=G+TtM5hms2LhRMkfgzz7eE0LFpUNcKenwt5eBPbIU44roTt09iVTKHIayfqoa/BAE9
         MaERQi9vCNVt+WN9o0waoJLZoFk3ty2v1wmQL8bTPu9K/5m5TXDpxHFxBd61QmOZWiKC
         dndIqGhipysV3xHci/CsxmXAoGFdAh2zBEaVNBIM+9lNMQXEzI9zq6ru8vfRw6USFaYL
         o8eFoKe14AwCYxPLLklHpsu8hsxQR8Fa8rTr2KbYr3NKPCtLZbKoHkTKR/dUwnbjxzak
         BcSLel8tyyKwoUg+99+Yf8znc39YxZcCB4n6yjXlK+ojHYHQG9XLmtvI3Np9SBKXYiD/
         2MCg==
X-Gm-Message-State: AAQBX9cnxn3rmmEbnXQRutB/Id5qum3OVGv9a84CnHOLbb4XS5ch1/6h
        rC1i0TgYOWCafCIip8NJWEkaj0eWUVooc3c1Y/kbGvRIPoqxb6c8
X-Google-Smtp-Source: AKy350ZnXE+AAi9/u9vwcPS3pqwRJoM65vYMSrVjCh1ghHyDp3YmZHoTB4+0DIpy3Z2+Yl8VD/mbkUnQciE7kcTTCIs=
X-Received: by 2002:a17:906:4bc5:b0:94f:24d:ef6f with SMTP id
 x5-20020a1709064bc500b0094f024def6fmr10302377ejv.52.1681813157677; Tue, 18
 Apr 2023 03:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230417152805.331865-1-kuba@kernel.org>
In-Reply-To: <20230417152805.331865-1-kuba@kernel.org>
From:   Somnath Kotur <somnath.kotur@broadcom.com>
Date:   Tue, 18 Apr 2023 15:49:05 +0530
Message-ID: <CAOBf=mvGmmd+LirDD_5PpiTjNg3JWNJuYnh_-RLtRkR5mp84Bg@mail.gmail.com>
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all mappings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dd4a8c05f999a3f4"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dd4a8c05f999a3f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 17, 2023 at 8:59=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
> to a few more drivers (possibly as a copy'n'paste).
>
> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
> the rarity of these platforms is likely why we never bothered adding
> the attribute in the page pool, even though it should be safe to add.
>
> To make the page pool migration in drivers which set this flag less
> of a risk (of regressing the precious sparc database workloads or
> whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
> page pool DMA mappings.
>
> We could make this a driver opt-in but frankly I don't think it's
> worth complicating the API. I can't think of a reason why device
> accesses to packet memory would have to be ordered.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> ---
>  net/core/page_pool.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 2f6bf422ed30..97f20f7ff4fc 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool *pool,=
 struct page *page)
>          */
>         dma =3D dma_map_page_attrs(pool->p.dev, page, 0,
>                                  (PAGE_SIZE << pool->p.order),
> -                                pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC)=
;
> +                                pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC =
|
> +                                                 DMA_ATTR_WEAK_ORDERING)=
;
>         if (dma_mapping_error(pool->p.dev, dma))
>                 return false;
>
> @@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool *pool, s=
truct page *page)
>         /* When page is unmapped, it cannot be returned to our pool */
>         dma_unmap_page_attrs(pool->p.dev, dma,
>                              PAGE_SIZE << pool->p.order, pool->p.dma_dir,
> -                            DMA_ATTR_SKIP_CPU_SYNC);
> +                            DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDER=
ING);
>         page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
>         page_pool_clear_pp_info(page);
> --
> 2.39.2
>
Acked-by: Somnath Kotur <somnath.kotur@broadcom.com>

--000000000000dd4a8c05f999a3f4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
nSGLsSobByQoGh1GyLfFTXI7QOGn/6qvrJ7x9Oem5V7miUTD0wGAIozD7MCVoluf5Psa4Q2a5AFV
gROLty059Ex4oK55Op/0e3Aa/a8hZD/tPBT3WE70owdiCwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpzb21uYXRoLmtvdHVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUabMpSsFcjDNUWMvGf76o
yB7jBJUwDQYJKoZIhvcNAQELBQADggEBAJBDQpQ1TqY57vpQbwtXYP0N01q8J3tfNA/K2vOiNOpv
IufqZ5WKdKEtmT21nujCeuaCQ6SmpWqCUJVkLd+u/sHR62vCo8j2fb1pTkA7jeuCAuT9YMPRE86M
sUphsGDq2ylriQ7y5kvl728hZ0Oakm3xUCnZ9DYS/32sFGSZyrCGZipTBnjK4n5uLQ0yekSLACiD
R0zi4nzkbhwXqDbDaB+Duk52ec/Vj4xuc2uWu9rTmJNVjdk0qu9vh48xcd/BzrlmwY0crGTijAC/
r4x2/y9OfG0FyVmakU0qwDnZX982aa66tXnKNgae2k20WCDVMM5FPTrbMsQyz6Hrv3bg6qgxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgx6wAr6NdQY0sTG
G7cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICFP39Uj3ADrJnQZlAXz2FACpRXj
RgN8UtAYl7yknkokMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIz
MDQxODEwMTkxOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBIrtrQiCJR/xT1qDgooSIL6O/sjvB3CQSt/F3ULmWCLRN7
K/xCQrhfvjyPGtgqfAAqDw4AbGwZv0kq0P5JO66Gadx2XJOKe3RsnP77yX4eh7NOx0V0V16hhzVz
aUbcvo0Gqm0bXfQ0U8pumhN/iiPM9OtVutlPNh5olJvnoAyvMKDyI4OMzqI6IbiCOtdjZMBW/fyo
keae1VQezfZ+0vvvdO9yaDY1MGSYdJvdaevCZHt/2otXgKQZVv8KjJSqYKV0ifSDyu0OgkaZaysf
Y+tYkc8vrAjxgVUNv8ljQUcLZSqfkPvL44lw5XXeNVJo+O56lBPrNJyI26/c4Tbf+q3k
--000000000000dd4a8c05f999a3f4--
