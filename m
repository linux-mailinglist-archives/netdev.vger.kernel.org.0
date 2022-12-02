Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1D640190
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiLBIH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbiLBIHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:07:52 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E6B1A3A0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:07:49 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id d128so5111557ybf.10
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K+hf5Y5YyKiVN6X/Dvd6I1S8lMvxLcWO/6uXk7uOdTc=;
        b=dwSDKnsDu7zz5XgE+wTSpS7FF6LmvgHy/4qOo+M+/SJXt44L6JN2iXH2y214YjSj0u
         7meS9QHjJRNijk0kn+2vqzA1LwVtvpZeiwS6xJbuDHceOUatVKnpDFs+3IivlMj2dw33
         u5Sq/+pQ7ucn7PQ7r4lpd9TZrUfff3ij8fj0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+hf5Y5YyKiVN6X/Dvd6I1S8lMvxLcWO/6uXk7uOdTc=;
        b=Vsx1uEbdUSG9PF1wEqQsFZRrvVG5ZVpk05Ej+V33QsAJ5B0dNkgNuL1xwbnlxhpRRH
         n8Bgjg8aUY8igehfDFOA6Pfsq8diqswi6k+nTGU13O/Wf0RNEDbe5lfB4wtXGw1bOIOO
         C/16E9X+usGdRQjPTuRSpNg5Tmqarf3SmXqmok2hKUCwvvgxQ+2WwBCF6Y0Kp6vFVlVU
         xk/5OLIqqPjX/I5X/TwIU/McGonAbDgm80ZQOqhNr18PwRVjiftFJEWJ/Ls2RDvAt/4F
         aeQtMZ2IwQRsKlBszp/XZpgVbtMIekPnXmU/GpC+FgK3rv1xOQZGz58xNg14mj9wNdOr
         A9bg==
X-Gm-Message-State: ANoB5pneNk5LBcGeCw5/DwbqKco1SGnQ9/JBnL/oNwixVeM/CeWttfgV
        fXJZie6qJiX0J3jj1XzlViR+mxEqxDgoavzCNHmIsA==
X-Google-Smtp-Source: AA0mqf74M8ikolS1J/n6aVJWEyFxrAxwvTJm27le1NzNbssFmVfFoX386kHpGQIiuftsKD+1id56N1XEMwc4Kaz+PQM=
X-Received: by 2002:a25:dcca:0:b0:6fb:67c7:33e9 with SMTP id
 y193-20020a25dcca000000b006fb67c733e9mr941536ybe.70.1669968468967; Fri, 02
 Dec 2022 00:07:48 -0800 (PST)
MIME-Version: 1.0
References: <67ca94bdd3d9eaeb86e52b3050fbca0bcf7bb02f.1669908312.git.lorenzo@kernel.org>
In-Reply-To: <67ca94bdd3d9eaeb86e52b3050fbca0bcf7bb02f.1669908312.git.lorenzo@kernel.org>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Fri, 2 Dec 2022 13:37:38 +0530
Message-ID: <CALs4sv0fjaaYf-s6b_ArT2U8=0ySLUZEwvgM2rZ-f1F8ap3+fg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix sleep while atomic
 in mtk_wed_wo_queue_refill
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000670dd905eed3d504"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000670dd905eed3d504
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 1, 2022 at 8:57 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> In order to fix the following sleep while atomic bug always alloc pages
> with GFP_ATOMIC in mtk_wed_wo_queue_refill since page_frag_alloc runs in
> spin_lock critical section.
>
> [    9.049719] Hardware name: MediaTek MT7986a RFB (DT)
> [    9.054665] Call trace:
> [    9.057096]  dump_backtrace+0x0/0x154
> [    9.060751]  show_stack+0x14/0x1c
> [    9.064052]  dump_stack_lvl+0x64/0x7c
> [    9.067702]  dump_stack+0x14/0x2c
> [    9.071001]  ___might_sleep+0xec/0x120
> [    9.074736]  __might_sleep+0x4c/0x9c
> [    9.078296]  __alloc_pages+0x184/0x2e4
> [    9.082030]  page_frag_alloc_align+0x98/0x1ac
> [    9.086369]  mtk_wed_wo_queue_refill+0x134/0x234
> [    9.090974]  mtk_wed_wo_init+0x174/0x2c0
> [    9.094881]  mtk_wed_attach+0x7c8/0x7e0
> [    9.098701]  mt7915_mmio_wed_init+0x1f0/0x3a0 [mt7915e]
> [    9.103940]  mt7915_pci_probe+0xec/0x3bc [mt7915e]
> [    9.108727]  pci_device_probe+0xac/0x13c
> [    9.112638]  really_probe.part.0+0x98/0x2f4
> [    9.116807]  __driver_probe_device+0x94/0x13c
> [    9.121147]  driver_probe_device+0x40/0x114
> [    9.125314]  __driver_attach+0x7c/0x180
> [    9.129133]  bus_for_each_dev+0x5c/0x90
> [    9.132953]  driver_attach+0x20/0x2c
> [    9.136513]  bus_add_driver+0x104/0x1fc
> [    9.140333]  driver_register+0x74/0x120
> [    9.144153]  __pci_register_driver+0x40/0x50
> [    9.148407]  mt7915_init+0x5c/0x1000 [mt7915e]
> [    9.152848]  do_one_initcall+0x40/0x25c
> [    9.156669]  do_init_module+0x44/0x230
> [    9.160403]  load_module+0x1f30/0x2750
> [    9.164135]  __do_sys_init_module+0x150/0x200
> [    9.168475]  __arm64_sys_init_module+0x18/0x20
> [    9.172901]  invoke_syscall.constprop.0+0x4c/0xe0
> [    9.177589]  do_el0_svc+0x48/0xe0
> [    9.180889]  el0_svc+0x14/0x50
> [    9.183929]  el0t_64_sync_handler+0x9c/0x120
> [    9.188183]  el0t_64_sync+0x158/0x15c
>
> Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Looks OK to me.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

>  drivers/net/ethernet/mediatek/mtk_wed_wo.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> index 4754b6db009e..a219da85f4db 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> @@ -133,17 +133,18 @@ mtk_wed_wo_dequeue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q, u32 *len,
>
>  static int
>  mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
> -                       gfp_t gfp, bool rx)
> +                       bool rx)
>  {
>         enum dma_data_direction dir = rx ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>         int n_buf = 0;
>
>         spin_lock_bh(&q->lock);
>         while (q->queued < q->n_desc) {
> -               void *buf = page_frag_alloc(&q->cache, q->buf_size, gfp);
>                 struct mtk_wed_wo_queue_entry *entry;
>                 dma_addr_t addr;
> +               void *buf;
>
> +               buf = page_frag_alloc(&q->cache, q->buf_size, GFP_ATOMIC);
>                 if (!buf)
>                         break;
>
> @@ -215,7 +216,7 @@ mtk_wed_wo_rx_run_queue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
>                         mtk_wed_mcu_rx_unsolicited_event(wo, skb);
>         }
>
> -       if (mtk_wed_wo_queue_refill(wo, q, GFP_ATOMIC, true)) {
> +       if (mtk_wed_wo_queue_refill(wo, q, true)) {
>                 u32 index = (q->head - 1) % q->n_desc;
>
>                 mtk_wed_wo_queue_kick(wo, q, index);
> @@ -432,7 +433,7 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
>         if (ret)
>                 goto error;
>
> -       mtk_wed_wo_queue_refill(wo, &wo->q_tx, GFP_KERNEL, false);
> +       mtk_wed_wo_queue_refill(wo, &wo->q_tx, false);
>         mtk_wed_wo_queue_reset(wo, &wo->q_tx);
>
>         regs.desc_base = MTK_WED_WO_CCIF_DUMMY5;
> @@ -446,7 +447,7 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
>         if (ret)
>                 goto error;
>
> -       mtk_wed_wo_queue_refill(wo, &wo->q_rx, GFP_KERNEL, true);
> +       mtk_wed_wo_queue_refill(wo, &wo->q_rx, true);
>         mtk_wed_wo_queue_reset(wo, &wo->q_rx);
>
>         /* rx queue irqmask */
> --
> 2.38.1
>

--000000000000670dd905eed3d504
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILNcCCnedK/xQjPcu4gD81rlUCFnHUXB
KeAc/Hec0c10MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
MjA4MDc0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB1XrkWRVrOJP/S/jPG2toH1CnL/Fgc7M4HuKr7J1O6hKEPbEXl
KI8bbELTqhdnc8cBu6aWmqCIXdo8lFUb/oflmdRClB01fiEvrHepRoP5tS8Gt5Fb2ED/3C4x534Q
kkWPupiW9Whdh8F5kdrGMyhzFdNFV0b1wSuJh2XvtAXSG8z/KswT71gCn9ZPY3czAuD4UsgCdKvz
h09Iqx5Wqvrus3AEnKHQXzvNQdTnqBymLKXCxEHycHZ6Nw0ATqEhbdFqqvgLSBPp2E8XlCcHcqXR
F/yS+vW7eXKExJBoZmGNiUvhE+v2gwBE9OClLRhT4B8qDVbVbuekZH8gMVTlauQm
--000000000000670dd905eed3d504--
