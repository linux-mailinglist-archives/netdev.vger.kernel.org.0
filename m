Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A386451D39E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390259AbiEFItd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 May 2022 04:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiEFItc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:49:32 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C10426574
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:45:47 -0700 (PDT)
Received: from mail-wr1-f54.google.com ([209.85.221.54]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mf0FY-1oKKnI25da-00gVz8 for <netdev@vger.kernel.org>; Fri, 06 May 2022
 10:45:46 +0200
Received: by mail-wr1-f54.google.com with SMTP id d5so9077935wrb.6
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 01:45:46 -0700 (PDT)
X-Gm-Message-State: AOAM530SVQ/2uXKxnjiFcNlxHYWdzW84Mc8gbE0MhLlqNhPtu51bIhaY
        BxZ6a9J16db0pkBDSp4fxqxGMStJl0eFSmrPmho=
X-Google-Smtp-Source: ABdhPJygt11vtfgOZDA/64li3bSytq5Sai/SMZi9LN5tFFy218LBJ/cSNq43PlNZujVOLppbBuC2Nr/T2xNqVf0E8Ls=
X-Received: by 2002:a5d:5986:0:b0:20c:5844:820d with SMTP id
 n6-20020a5d5986000000b0020c5844820dmr1746674wri.192.1651826746158; Fri, 06
 May 2022 01:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch> <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
In-Reply-To: <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 6 May 2022 10:45:29 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
Message-ID: <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:TB+V8e0vvjWpVjZhkXMWqd4lmSy8nlQBtRpk9bq9Lvi0yItuWbq
 JnmK9hlB/M0L9HemzynDWGP/TPAY8e88pO2A+sbzhW96tsfs13+71KdpuweyyEAFZtJVOCQ
 jk62MzE3gbYEvn9xuQe73idiDU4G6LRDlMESxEwefQTi5TAyX98J0oq/mSunM4DjgCOXL/C
 4kGGYZEcmp2pNdbwGP/hg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lOY4zUb6KBw=:b9wvx5j3vdp8qB//hnUCvC
 aXjujpilmEPutle+CldILyoD6HYSVGU2ipxPg0Z1ORiIchW7cA402x7B+Ek1yYl/2BHVyFOr/
 1aurCAphZndzO2AwmEZ8eXblHMg03KLmxlC25CMkEVO7rLVM/qU6UydO/P6gCtqE1zytd+u8i
 wD38G4SodmaVlIBC8FgeD6ZhY73vF8AmFy0iCEzUHDP3Tq8RkDJ7FKZ9rfHyEapmKr7rQMxj6
 Ih1o/N75IMGXC0fVkg3fNkw4Lc1+tC050ktlhCMIJZfutNdhrdX6SOhG36CU7BWrcnifTbrL0
 XqsUU4VyMqgqZvL1kphVKdI/L9kybzM/m22W+m1yPo3xuwK7Dh3urHsqAcDX83nF/KCK9CXNb
 6aZRnaTkILUPBqwGU3nf4pISe8hUkNxX/5PF73y0iCmlBapsgl6jun8+XhxpGEcfjze7JTi+E
 2pIuvFkAIKsWUowFKw7S5ZWmecDX0nHyTe/nA5Zmpau5HTFRi1UDodZMD7p6B2fIrbzUH24ey
 YOlg9vxFCmb02EU4sHlxCI5OzxyjB3G8ziCnn41FPRgpfozgosRTDtYp70Lurn4q8TYqoAxno
 UWdRkxCwpICtK6So87TtCyYg/RMcFQgZ1AaZRotdctmbEXaSL3eVgtibaNr3/ylxxC53FcHiB
 fySKEYzfoU/VIw4aBMEY16l76oadQu/cCij8cia+2PK3Wa4Ez90gpyrdcutA2hLFdHWSqu/9X
 SSNybA3IFvkbJOIdsF2R4TOuk1HsLQwUMXdTfIdD6lW/O9mmMcoYuO586Ti8Y06311CIlEz6x
 IMGxwEbFf1BigTogy+bfl8AOtWMDv0CUpqq0s1Y3/tSydKbcyg=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 9:44 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>
> On 5.05.2022 18:04, Andrew Lunn wrote:
> >> you'll see that most used functions are:
> >> v7_dma_inv_range
> >> __irqentry_text_end
> >> l2c210_inv_range
> >> v7_dma_clean_range
> >> bcma_host_soc_read32
> >> __netif_receive_skb_core
> >> arch_cpu_idle
> >> l2c210_clean_range
> >> fib_table_lookup
> >
> > There is a lot of cache management functions here.

Indeed, so optimizing the coherency management (see Felix' reply)
is likely to help most in making the driver faster, but that does not
explain why the alignment of the object code has such a big impact
on performance.

To investigate the alignment further, what I was actually looking for
is a comparison of the profile of the slow and fast case. Here I would
expect that the slow case spends more time in one of the functions
that don't deal with cache management (maybe fib_table_lookup or
__netif_receive_skb_core).

A few other thoughts:

- bcma_host_soc_read32() is a fundamentally slow operation, maybe
  some of the calls can turned into a relaxed read, like the readback
  in bgmac_chip_intrs_off() or the 'poll again' at the end bgmac_poll(),
  though obviously not the one in bgmac_dma_rx_read().
  It may be possible to even avoid some of the reads entirely, checking
  for more data in bgmac_poll() may actually be counterproductive
  depending on the workload.

- The higher-end networking SoCs are usually cache-coherent and
  can avoid the cache management entirely. There is a slim chance
  that this chip is designed that way and it just needs to be enabled
  properly. Most low-end chips don't implement the coherent
  interconnect though, and I suppose you have checked this already.

- bgmac_dma_rx_update_index() and bgmac_dma_tx_add() appear
  to have an extraneous dma_wmb(), which should be implied by the
  non-relaxed writel() in bgmac_write().

- accesses to the DMA descriptor don't show up in the profile here,
  but look like they can get misoptimized by the compiler. I would
  generally use READ_ONCE() and WRITE_ONCE() for these to
  ensure that you don't end up with extra or out-of-order accesses.
  This also makes it clearer to the reader that something special
  happens here.

> > Might sound odd,
> > but have you tried disabling SMP? These cache functions need to
> > operate across all CPUs, and the communication between CPUs can slow
> > them down. If there is only one CPU, these cache functions get simpler
> > and faster.
> >
> > It just depends on your workload. If you have 1 CPU loaded to 100% and
> > the other 3 idle, you might see an improvement. If you actually need
> > more than one CPU, it will probably be worse.
>
> It seems to lower my NAT speed from ~362 Mb/s to 320 Mb/s but it feels
> more stable now (lower variations). Let me spend some time on more
> testing.
>
>
> FWIW during all my tests I was using:
> echo 2 > /sys/class/net/eth0/queues/rx-0/rps_cpus
> that is what I need to get similar speeds across iperf sessions
>
> With
> echo 0 > /sys/class/net/eth0/queues/rx-0/rps_cpus
> my NAT speeds were jumping between 4 speeds:
> 273 Mbps / 315 Mbps / 353 Mbps / 425 Mbps
> (every time I started iperf kernel jumped into one state and kept the
>   same iperf speed until stopping it and starting another session)
>
> With
> echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
> my NAT speeds were jumping between 2 speeds:
> 284 Mbps / 408 Mbps

Can you try using 'numactl -C' to pin the iperf processes to
a particular CPU core? This may be related to the locality of
the user process relative to where the interrupts end up.

        Arnd
