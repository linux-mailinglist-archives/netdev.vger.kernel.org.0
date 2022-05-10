Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791735217B1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiEJN2Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 May 2022 09:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiEJNZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:25:30 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA422317D4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:18:52 -0700 (PDT)
Received: from mail-yb1-f182.google.com ([209.85.219.182]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mi2Fj-1oJdyV1dWz-00e25A for <netdev@vger.kernel.org>; Tue, 10 May 2022
 15:18:50 +0200
Received: by mail-yb1-f182.google.com with SMTP id g28so30604417ybj.10
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:18:50 -0700 (PDT)
X-Gm-Message-State: AOAM531hoRthUbkDeahBbRb08x68Kc7Y7zo4zpaRiu2nzATLnO8vAris
        Oa7mv1nOiKNbrZwqk/2RWqnF1afYIyZUmkmUAr8=
X-Google-Smtp-Source: ABdhPJw3S8h8ZtUTRxF1d/gqWWv4HoqiiLNdHw9pZZ71a9gvjaSZ2/X0c8geLVx6OiwD/bWOyWqtfgyZyea3fcMoD30=
X-Received: by 2002:a25:c50a:0:b0:647:b840:df2c with SMTP id
 v10-20020a25c50a000000b00647b840df2cmr17579194ybe.106.1652188729130; Tue, 10
 May 2022 06:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com> <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
 <bc628101-8772-9994-3aa7-c141ae151f15@gmail.com>
In-Reply-To: <bc628101-8772-9994-3aa7-c141ae151f15@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 May 2022 15:18:30 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3DiCfAj6Dk4tygzYpjccrEN60LZ8h_GP6JL2O_cCrivg@mail.gmail.com>
Message-ID: <CAK8P3a3DiCfAj6Dk4tygzYpjccrEN60LZ8h_GP6JL2O_cCrivg@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:B581Yhngv7p1FBY0hxMVxNCAXip7/gtRwkvImswtu6ZuJ1UDbXf
 auFBPk+RSNfRr0/UuIs9Ik4GdsYvr6efTMvLpGU3vBlE7tM+t1G+hImhBo5LKoLObL5RVC5
 sGGGRasX49AUyf/gE60K5VJnCgxBLu9+wzQ8tjwEHFc2j9+id9kAmad9jOhUN8s6g1WZVhn
 F1vXND4gmAtsJ3kVaLtLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:n+c5Qe9Mp4E=:zqEASc7iFUaC5QpRgC8ShG
 CceKwAptr6qRNmOrqhQlqdnvwXcPKOa/2I0nVZU6x82MKDDEGSZlogB7dU2EOVmwSSWybjs3S
 DbEwOyhTHkNCdh/TWUnOkGwiRkIGcAlrslO7iEIkGgk1FIHKlVdqv63WdKnJDHemHbfih43GX
 /najtCnIvhgYj1ob1BE/gkEmymi1aLJFPeX9u6whh5YuQpiPk2b44KAy12kgA4hQXkMubPXPE
 qbjkMelfJ4vDerQYrF1iXgT9AMmPhvndZZH9Mynerl/cU5eF9ELwGuc1wXCGRCs8Rwoq2zsrB
 Q7ye1aTXjCcNIrrvhrZrKonBQ15YhnlLi/EJJKB+TFJLPgA5vTR697hgtB8H7uBLl7HQD7Q2+
 w8z8UdRjhiDudcfsjdq70fHqSTr2XBb4owNeR6hxxhD7VaXcy6VrgCwMeyHAHPSkIqa/ZAjuq
 ZLCBmJ+pEbjJT4+qZhK7h6Gi5vRBjKy5xjpf4KaW81pOW8qeVudSgVGYztfPWr7oKqOJMXq4K
 TWHicJQY1IfjvOhV4ta3dvJ51UQrfUoo5wHk5U1DVa3GcboJ8hBjDje0xcaoTSxXzNCuUruQr
 +5QCEak/vHosk0+sB1qeKJ9FXdLjQezB/uuALpEB/DRUNSOvn0KXeQptO6/K/j3v0zYoREUxs
 bYf2GEq/0NVOtdcoNmHN1pPRVjB2IRrdcBiVcONpi3ySiaMwWK9w/DuK+pT6iaBoZ8MOLll9g
 KPM6rXlT/+7aMpuNXU1E2hVpT1h9WDFfYq6waxaPYWvNeGauySqni+8Bs1YzAGfn9VMWrMLY1
 nWBccYQAZH/U35dBIdirQoDiemG85gD7DvWPfdR/B6XAVh2aeXRACBSNo/WcTciUpjWEUTL
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 1:23 PM Rafał Miłecki <zajec5@gmail.com> wrote:
> On 6.05.2022 10:45, Arnd Bergmann wrote:
> > - The higher-end networking SoCs are usually cache-coherent and
> >    can avoid the cache management entirely. There is a slim chance
> >    that this chip is designed that way and it just needs to be enabled
> >    properly. Most low-end chips don't implement the coherent
> >    interconnect though, and I suppose you have checked this already.
>
> To my best knowledge Northstar platform doesn't support hw coherency.
>
> I just took an extra look at Broadcom's SDK and them seem to have some
> driver for selected chipsets but BCM708 isn't there.
>
> config BCM_GLB_COHERENCY
>         bool "Global Hardware Cache Coherency"
>         default n
>         depends on BCM963158 || BCM96846 || BCM96858 || BCM96856 || BCM963178 || BCM947622 || BCM963146  || BCM94912 || BCM96813 || BCM96756 || BCM96855

Ok

> > - bgmac_dma_rx_update_index() and bgmac_dma_tx_add() appear
> >    to have an extraneous dma_wmb(), which should be implied by the
> >    non-relaxed writel() in bgmac_write().
>
> I tried dropping wmb() calls.
> With wmb(): 421 Mb/s
> Without: 418 Mb/s

That's probably within the noise here. I suppose doing two wmb()
calls in a row is not that expensive because there is nothing left to
wait for. If the extra wmb() is measurably faster than no wmb(), there
is something else going wrong ;-)

> I also tried dropping bgmac_read() from bgmac_chip_intrs_off() which
> seems to be a flushing readback.
>
> With bgmac_read(): 421 Mb/s
> Without: 413 Mb/s

Interesting, so this is statistically significant, right? It could be that
this changing the interrupt timing just enough that it ends up doing
more work at once some of the time.

> > - accesses to the DMA descriptor don't show up in the profile here,
> >    but look like they can get misoptimized by the compiler. I would
> >    generally use READ_ONCE() and WRITE_ONCE() for these to
> >    ensure that you don't end up with extra or out-of-order accesses.
> >    This also makes it clearer to the reader that something special
> >    happens here.
>
> Should I use something as below?
>
> FWIW it doesn't seem to change NAT performance.
> Without WRITE_ONCE: 421 Mb/s
> With: 419 Mb/s

This one depends on the compiler. What I would expect here is that
it often makes no difference, but if the compiler does something
odd, then the WRITE_ONCE() would prevent this and make it behave
as before. I would suggest adding this part regardless.

The other suggestion I had was this, I think you did not test this:

--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1156,11 +1156,12 @@ static int bgmac_poll(struct napi_struct
*napi, int weight)
        bgmac_dma_tx_free(bgmac, &bgmac->tx_ring[0]);
        handled += bgmac_dma_rx_read(bgmac, &bgmac->rx_ring[0], weight);

-       /* Poll again if more events arrived in the meantime */
-       if (bgmac_read(bgmac, BGMAC_INT_STATUS) & (BGMAC_IS_TX0 | BGMAC_IS_RX))
-               return weight;
-
        if (handled < weight) {
+               /* Poll again if more events arrived in the meantime */
+               if (bgmac_read(bgmac, BGMAC_INT_STATUS) &
+                               (BGMAC_IS_TX0 | BGMAC_IS_RX))
+                       return weight;
+
                napi_complete_done(napi, handled);
                bgmac_chip_intrs_on(bgmac);
        }

Or possibly, remove that extra check entirely and just rely on the irq to do
this after it gets turned on again.

         Arnd
