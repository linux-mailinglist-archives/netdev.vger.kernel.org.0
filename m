Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD42A655DA2
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 17:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiLYQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 11:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiLYQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 11:31:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5005114B
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 08:31:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ge16so5303951pjb.5
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 08:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=evsJtBXmZFYV5w0j7RwUn02fRzW76H4z6fgKEi67ofQ=;
        b=h/2CCItyqoK1hFChlkW+7FaB8r/3MYlztemzPh2Qk/mEJwZaNH3uK4j35HWUkO1ONw
         KCo/sZ8VnUzslJVllPXIgHsF6WxuI86EqW/SWCuTubcfjTacPhxIZzU2H9WgM3OxVPF7
         VaS6JT8UOoFOdAjI2SepIEddSa1AcO1OPw5Ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evsJtBXmZFYV5w0j7RwUn02fRzW76H4z6fgKEi67ofQ=;
        b=oi9oLyiISA2BXQCe/n4wGTarQQ9J3YiGjxGC4gOpmxUKUKSpHQD8Qtu9L9OynMQ6SY
         e2GUZIz5kh8pud/LvFxQtmEzEowAKrvkhr9bvon6sHa9KttIQvoEvTLAYNhkGq3mEQ9E
         32Yf8svUaR3LTjSH55RPLChdiaRX6wvm+QfsR8ovAHabIc3Ifh6fu1mEM6R3WqGCCf37
         j4NxWkB2pNEkW9a020rmUTvHlhtMQvftnqlGrpwHIr1Zy47CP5KhXlACAGLTBz7ANdCu
         LcGe3Py1rabJZ4OIJoYO/JMU2Xbsw1K1InJOqz8Sgk8KZSLS24BGZfv0NLr9bHKPoFG1
         SkNA==
X-Gm-Message-State: AFqh2krPAoJ4UqKGPj0a0VGRnJYk5zaNfZeSsS9dwgVULm4ryPBtLuX2
        GYuCp4KJPvWcFLOdVLrcUiVpE2QTqqUbN/7UvzGoZkH/viSBiA==
X-Google-Smtp-Source: AMrXdXsmXEbmI056D1fsZsm3Brc1ZAsRy94APhIiLAmEaKX/ic6SHTelKfPYnHrBVdaygzvQSavKqwb6fh16mn/WVQM=
X-Received: by 2002:a17:90a:8a91:b0:219:1c3f:985d with SMTP id
 x17-20020a17090a8a9100b002191c3f985dmr1288231pjn.111.1671985860052; Sun, 25
 Dec 2022 08:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20221223005645.8709-1-gakula@marvell.com>
In-Reply-To: <20221223005645.8709-1-gakula@marvell.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Sun, 25 Dec 2022 22:00:48 +0530
Message-ID: <CALs4sv3CZjrcC0nqH=RtTBp_aJ3Dd9Q-f7DJUo-+rq-vjVHA4Q@mail.gmail.com>
Subject: Re: [PATCH net] octeontx2-pf: Fix lmtst Id used in aura free
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000048c8c205f0a98bc0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000048c8c205f0a98bc0
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 23, 2022 at 6:27 AM Geetha sowjanya <gakula@marvell.com> wrote:
>
> Current code uses per_cpu pointer to get the lmtst_id mapped to
> the core on which aura_free() is executed. Using per_cpu pointer
> without preemption disable causing mismatch between lmtst_id and
> core on which pointer gets freed. This patch fixes the issue by
> disabling preemption around aura_free.
>
> This patch also addresses the memory reservation issue,
> currently NIX, NPA queue context memory is being allocated using
> GFP_KERNEL flag which inturns allocates from memory reserved for
> CMA_DMA. Sizing CMA_DMA memory is getting difficult due to this
> dependency, the more number of interfaces enabled the more the
> CMA_DMA memory requirement.
>
> To fix this issue, GFP_KERNEL flag is replaced with GFP_ATOMIC,
> with this memory will be allocated from unreserved memory.
>
> Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")

Two separate issues are being fixed. I think these two fixes should be
separate patches.

> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/common.h    |  2 +-
>  .../marvell/octeontx2/nic/otx2_common.c       | 30 +++++++++++++------
>  2 files changed, 22 insertions(+), 10 deletions(-)
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
>         if (!qmem->base)
>                 return -ENOMEM;
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 9e10e7471b88..88f8772a61cd 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -1012,6 +1012,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
>         rbpool = cq->rbpool;
>         free_ptrs = cq->pool_ptrs;
>
> +       get_cpu();
>         while (cq->pool_ptrs) {
>                 if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
>                         /* Schedule a WQ if we fails to free atleast half of the
> @@ -1031,6 +1032,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
>                 pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
>                 cq->pool_ptrs--;
>         }
> +       put_cpu();
>         cq->refill_task_sched = false;
>  }
>
> @@ -1368,6 +1370,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>         if (err)
>                 goto fail;
>
> +       get_cpu();
>         /* Allocate pointers and free them to aura/pool */
>         for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
>                 pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
> @@ -1376,18 +1379,24 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>                 sq = &qset->sq[qidx];
>                 sq->sqb_count = 0;
>                 sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
> -               if (!sq->sqb_ptrs)
> -                       return -ENOMEM;
> +               if (!sq->sqb_ptrs) {
> +                       err = -ENOMEM;
> +                       goto err_mem;
> +               }
>
>                 for (ptr = 0; ptr < num_sqbs; ptr++) {
> -                       if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
> -                               return -ENOMEM;
> +                       err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
> +                       if (err)
> +                               goto err_mem;
>                         pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
>                         sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
>                 }
>         }
>
> -       return 0;
> +err_mem:
> +       put_cpu();
> +       return err ? -ENOMEM : 0;
> +
>  fail:
>         otx2_mbox_reset(&pfvf->mbox.mbox, 0);
>         otx2_aura_pool_free(pfvf);
> @@ -1426,18 +1435,21 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
>         if (err)
>                 goto fail;
>
> +       get_cpu();
>         /* Allocate pointers and free them to aura/pool */
>         for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
>                 pool = &pfvf->qset.pool[pool_id];
>                 for (ptr = 0; ptr < num_ptrs; ptr++) {
> -                       if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
> -                               return -ENOMEM;
> +                       err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
> +                       if (err)
> +                               goto err_mem;
>                         pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
>                                                    bufptr + OTX2_HEAD_ROOM);
>                 }
>         }
> -
> -       return 0;
> +err_mem:
> +       put_cpu();
> +       return err ? -ENOMEM : 0;
>  fail:
>         otx2_mbox_reset(&pfvf->mbox.mbox, 0);
>         otx2_aura_pool_free(pfvf);
> --
> 2.25.1
>

--00000000000048c8c205f0a98bc0
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPYxTIXEZf5V5qSuWCe9XorgTgCkq72/
j98d+clOVJECMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIy
NTE2MzEwMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCYFRjlAmYmV/TMu/9FpMx1RSZ4gWRUCiegB/X7nFzzCGbf1CoI
1BFRsq/syecf2tAmjn5eI8YjuXw/lW69QZu15BI/3JkfXKlJnVT4RLxj97Q5DC6S80kNDaa1LToe
bcGXTy9RcJCOMdur4XMzXrv+7ItkSd0jXEr9yANzrHZPYkW/R6QJiXkz/VNqVRsCttzwkVIKXRxo
wqdBuDtflLQywWeJxy5QVPxhhirzq8U/SeuhA1vYgqPaE76jdYoLGfn3LhRdTqEEGz3iSSfAfZml
hZpksYil3K/VRH34zg8S+n2HlPzA9kXePSvyr/yqh9kBdYMZmn9KaXHFJ/GrbwD9
--00000000000048c8c205f0a98bc0--
