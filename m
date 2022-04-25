Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6050ECF9
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiDYX6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239121AbiDYX6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:58:25 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6BD1DB;
        Mon, 25 Apr 2022 16:55:18 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id c62so4477637vsc.10;
        Mon, 25 Apr 2022 16:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqGYIpZh9xjxFheTFMngZkBX5UaM70tPq54+VZGkNkI=;
        b=W4N7meBtQX03mBW1HI2SJG/ldyxvu97pzKiKN2SW7QTYebLDEXDIFYvOpxMSrAHRdt
         ouwc0NCRa+zDJnOATrX+23N8yFeFAtxfsmf81CtVt4NHpBJTTpTG99uDH3bNnyWVATuL
         uHM6MfiZkwoPTa7QzHzIH86JMtKIt29wXmBQ2NhCv3MpT2t5Yb1eCgFQj6axIBfZueFJ
         qWpRcNGe+V+NTWNd25r/+FP3hMmfCxuvap+ZPWISvD88ZOyyiiy4l1X2xTxd5xRRvMgt
         KPMkZKMZl8Jm93kMryhyzfGYLPe2cuCrtbuhw6xaniv4nq8xKhaM8gLJ2bXunPbw3uwH
         nkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqGYIpZh9xjxFheTFMngZkBX5UaM70tPq54+VZGkNkI=;
        b=iWJAB03FZ8A8DRP+vhd4plzet1yYPYY0Vcep6SJCniLfYHK1W7uGtoPMtbo49MDgFg
         ZZ0tOqTTOnudk6Bdc+Je4t2LgChMyfQo2dri6vBKCQi7nd8z6QiSS44OS2QHSU4zXDhA
         RSOdftbRPpeGChBWxZHvJcbSXRPlqO+/wapMrn/gejs9D+yVMC25vCFLRmY5lKSIbQ8D
         LXlGpis6m4gMZmQPqhOmJ9sXOqnn1DLFh90zVcQSzw+2k9v72jy4hnc+5cs6aX+uj7kB
         0+7Dfe1vHIt7pr6nl84xS87Wo8/KR8O7OayraFMXvnXuKk5CGXA4hutPOul3Fc6Ww6Ak
         2wVQ==
X-Gm-Message-State: AOAM531t/pXOEj0sMNkC587BVW1tMg8zSlJ9vp4S1Ne+up1ac20aH7wY
        kC029UnGHuRjey6zPslbWGKhOeAPt4f52bpwxJ4=
X-Google-Smtp-Source: ABdhPJySjyVWEvZ3Ulesmeg1eGIzZeOTdu99Ealx72DKtASwYsZkvv9XSRM4a9gxLAbIXmU3ujkrif3gWRnzVhENF74=
X-Received: by 2002:a05:6102:161e:b0:32c:d072:997b with SMTP id
 cu30-20020a056102161e00b0032cd072997bmr2224980vsb.61.1650930917944; Mon, 25
 Apr 2022 16:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-9-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-9-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:55:17 +0300
Message-ID: <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
>
> DPMAIF TX
> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
> network device to transmit packets.
> The uplink data management uses a Descriptor Ring Buffer (DRB).
> First DRB entry is a message type that will be followed by 1 or more
> normal DRB entries. Message type DRB will hold the skb information
> and each normal DRB entry holds a pointer to the skb payload.
>
> DPMAIF RX
> The downlink buffer management uses Buffer Address Table (BAT) and
> Packet Information Table (PIT) rings.
> The BAT ring holds the address of skb data buffer for the HW to use,
> while the PIT contains metadata about a whole network packet including
> a reference to the BAT entry holding the data buffer address.
> The driver reads the PIT and BAT entries written by the modem, when
> reaching a threshold, the driver will reload the PIT and BAT rings.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

and a small question below.

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
> ...
> +static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
> +                                       const unsigned int size, struct dpmaif_bat_skb *cur_skb)
> +{
> +       dma_addr_t data_bus_addr;
> +       struct sk_buff *skb;
> +       size_t data_len;
> +
> +       skb = __dev_alloc_skb(size, GFP_KERNEL);
> +       if (!skb)
> +               return false;
> +
> +       data_len = skb_end_pointer(skb) - skb->data;

Earlier you use a nice t7xx_skb_data_area_size() function here, but
now you opencode it. Is it a consequence of t7xx_common.h removing?

I would even encourage you to make this function common and place it
into include/linux/skbuff.h with a dedicated patch and call it
something like skb_data_size(). Surprisingly, there is no such helper
function in the kernel, and several other drivers will benefit from
it:

$ grep -rn 'skb_end_pointer(.*) [-]' drivers/net/
drivers/net/ethernet/marvell/mv643xx_eth.c:628: size =
skb_end_pointer(skb) - skb->data;
drivers/net/ethernet/marvell/pxa168_eth.c:322: size =
skb_end_pointer(skb) - skb->data;
drivers/net/ethernet/micrel/ksz884x.c:4764: if (skb_end_pointer(skb) -
skb->data >= 50) {
drivers/net/ethernet/netronome/nfp/ccm_mbox.c:492: undersize =
max_reply_size - (skb_end_pointer(skb) - skb->data);
drivers/net/ethernet/nvidia/forcedeth.c:2073:
(skb_end_pointer(np->rx_skb[i].skb) -
drivers/net/ethernet/nvidia/forcedeth.c:5238: (skb_end_pointer(tx_skb)
- tx_skb->data),
drivers/net/veth.c:767: frame_sz = skb_end_pointer(skb) - skb->head;
drivers/net/wwan/t7xx/t7xx_hif_cldma.c:106: return
skb_end_pointer(skb) - skb->data;
drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c:160: data_len =
skb_end_pointer(skb) - skb->data;

> +       data_bus_addr = dma_map_single(dpmaif_ctrl->dev, skb->data, data_len, DMA_FROM_DEVICE);
> +       if (dma_mapping_error(dpmaif_ctrl->dev, data_bus_addr)) {
> +               dev_err_ratelimited(dpmaif_ctrl->dev, "DMA mapping error\n");
> +               dev_kfree_skb_any(skb);
> +               return false;
> +       }
> +
> +       cur_skb->skb = skb;
> +       cur_skb->data_bus_addr = data_bus_addr;
> +       cur_skb->data_len = data_len;
> +
> +       return true;
> +}

--
Sergey
