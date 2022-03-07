Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D84CEFDE
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiCGC7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCGC7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:59:35 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F68BF2;
        Sun,  6 Mar 2022 18:58:41 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id u82so1186567vsu.0;
        Sun, 06 Mar 2022 18:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o5Q1nnb2KChMtUMZ+eOFeK1yXw1TUkKBnnEUojew08s=;
        b=Kx42WW9tVpNSWY3OdkLK26+bUEfdf6gOJyrvBNeAon+7T8x2iV/a43UVGJT2d0mELf
         3Vf/n16DuZTwZyPzZ1lLg8quFrEzlT2IGx/wFjLzTIf/0ZlaCyYrxwUDgvh7pXSRgei2
         pbohWq9BHtr0f5tGNir2md6+xNnvTjNk3bm+je+q2Q8U1flPsi1+9bQvHOXoUgppSVY7
         sbbHc9l96Es2kuygayFH0MEHx2p41HTx2cffvIUL+fEoJQ76DaNyc+r6/38yr1++BQUV
         dHkXprXlEtCIvTFPtL3f0UOlJTp3OL7yilnGdsoorOCVUQZEL7QmI7k/OSZpixKRbOPz
         FqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5Q1nnb2KChMtUMZ+eOFeK1yXw1TUkKBnnEUojew08s=;
        b=n122SfD/xuLzGXrkAQCA6dtpXUE8GuU9anbwnN8KB0dPd7MiA2tvpGe2GNXd2AMNrU
         cTE+JbtKI0SbwgC74fO2CdT+hT1OVuHYCrP0YpIQEfgGamuzLJZvALdP62/zkgul/fOy
         +mrFWfvdUVZSo6brAdjpfxIp5fRxb3RNyEmaNk/N4tArNYd8akoNgmEBwkt6YvvOgAkb
         aO7P/BphbWaAVOpeWk07C9DJOS+lz/ThYDBsBUNaLWI05aj6dA16FP0BLYSPccOq0qS7
         Iny/+toiCg5pEPWmLgVZTkzqVSUYzI4NEJmawm9A/8aOj8WkSCVloduV32xpI0HlE0v8
         r+nw==
X-Gm-Message-State: AOAM533UcUVuTtTbLWp2zciyLmMQbQKGhPgt8WDoe6x97I84jGvM8OzH
        48vUBErw38r1r8Hvf5HBO0kBYaR0nnTSgPohSqJO4ksJZ/k=
X-Google-Smtp-Source: ABdhPJw1oZAd3NJJPDCYm+N6flBMAIZq3wTV+hSwEfbPXJ/HqUAHq7EZlsIKzY9f+RyEstB12GgW07Sp7b/qii01k2k=
X-Received: by 2002:a67:cd85:0:b0:320:7c27:4377 with SMTP id
 r5-20020a67cd85000000b003207c274377mr3383376vsl.32.1646621920780; Sun, 06 Mar
 2022 18:58:40 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-9-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-9-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:58:49 +0300
Message-ID: <CAHNKnsTZ57hZfy_CTv8-AXuXJEuYVCaO0oax03eMMYzerB-Oyw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 08/13] net: wwan: t7xx: Add data path interface
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
>
> DPMAIF TX
> Exposes the `dmpaif_tx_send_skb` function which can be used by the
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

[skipped]

> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
> ...
> +#ifndef __T7XX_DPMA_TX_H__
> +#define __T7XX_DPMA_TX_H__

Maybe __T7XX_HIF_DPMAIF_H__ ?

[skipped]

> +struct dpmaif_tx_queue {
> +       unsigned char           index;
> +       bool                    que_started;
> +       atomic_t                tx_budget;
> +       void                    *drb_base;
> +       dma_addr_t              drb_bus_addr;
> +       unsigned int            drb_size_cnt;
> +       unsigned short          drb_wr_idx;
> +       unsigned short          drb_rd_idx;
> +       unsigned short          drb_release_rd_idx;
> +       void                    *drb_skb_base;
> +       wait_queue_head_t       req_wq;
> +       struct workqueue_struct *worker;
> +       struct work_struct      dpmaif_tx_work;
> +       spinlock_t              tx_lock; /* Protects txq DRB */
> +       atomic_t                tx_processing;
> +
> +       struct dpmaif_ctrl      *dpmaif_ctrl;
> +       spinlock_t              tx_skb_lock; /* Protects TX thread skb list */
> +       struct list_head        tx_skb_queue;

Should this be the sk_buff_head struct? So you will be able to use a
regular skb_queue_foo() functions and have the embedded spinlock?

> +       unsigned int            tx_submit_skb_cnt;
> +       unsigned int            tx_list_max_len;
> +       unsigned int            tx_skb_stat;
> +};

[skipped]

> +static void t7xx_dpmaif_parse_msg_pit(const struct dpmaif_rx_queue *rxq,
> +                                     const struct dpmaif_msg_pit *msg_pit,
> +                                     struct dpmaif_cur_rx_skb_info *skb_info)
> +{
> +       skb_info->cur_chn_idx = FIELD_GET(MSG_PIT_CHANNEL_ID, le32_to_cpu(msg_pit->dword1));
> +       skb_info->check_sum = FIELD_GET(MSG_PIT_CHECKSUM, le32_to_cpu(msg_pit->dword1));
> +       skb_info->pit_dp = FIELD_GET(MSG_PIT_DP, le32_to_cpu(msg_pit->dword1));

Here you can first convert dword1 field value to a native endians and
store it in a local variable, and then use it in the FIELD_GET().

> +       skb_info->pkt_type = FIELD_GET(MSG_PIT_IP, le32_to_cpu(msg_pit->dword4));
> +}

[skipped]

> +/* Structure of DL PIT */
> +struct dpmaif_normal_pit {
> +       __le32                  pit_header;
> +       __le32                  p_data_addr;
> +       __le32                  data_addr_ext;
> +       __le32                  pit_footer;
> +};
>
> ...
>
> +struct dpmaif_msg_pit {
> +       __le32                  dword1;
> +       __le32                  dword2;
> +       __le32                  dword3;
> +       __le32                  dword4;
> +};

Just an idea. Both PIT normal (aka PD) and PIT Msg structs have the
same size and even partially share the first header bits, so why not
define both formats in a single structure using union:

struct dpmaif_pit {
    __le32 header;
    union {
        struct {
            __le32 data_addr_l;
            __le32 data_addr_h;
            __le32 footer;
        } pd;
        struct {
            __le32 dword2;
            __le32 dword3;
            __le32 dword4;
        } msg;
    };
};

Defining the format in this way eliminates the cast and allows to turn
the pit_base field from a void pointer into a struct dpmaif_pit
pointer and handle it as an array.

[skipped]

> +static void t7xx_setup_payload_drb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
> +                                  unsigned short cur_idx, dma_addr_t data_addr,
> +                                  unsigned int pkt_size, bool last_one)
> +{
> +       struct dpmaif_drb_pd *drb_base = dpmaif_ctrl->txq[q_num].drb_base;
> +       struct dpmaif_drb_pd *drb = drb_base + cur_idx;
> +
> +       drb->header &= cpu_to_le32(~DRB_PD_DTYP);
> +       drb->header |= cpu_to_le32(FIELD_PREP(DRB_PD_DTYP, DES_DTYP_PD));
> +       drb->header &= cpu_to_le32(~DRB_PD_CONT);
> +
> +       if (!last_one)
> +               drb->header |= cpu_to_le32(FIELD_PREP(DRB_PD_CONT, 1));

Empty line between DRB_PD_CONT field clean and setup looks odd.

> +
> +       drb->header &= cpu_to_le32(~(u32)DRB_PD_DATA_LEN);
> +       drb->header |= cpu_to_le32(FIELD_PREP(DRB_PD_DATA_LEN, pkt_size));
> +       drb->p_data_addr = cpu_to_le32(lower_32_bits(data_addr));
> +       drb->data_addr_ext = cpu_to_le32(upper_32_bits(data_addr));
> +}

[skipped]

> +static int t7xx_dpmaif_add_skb_to_ring(struct dpmaif_ctrl *dpmaif_ctrl, struct sk_buff *skb)
> +{
> +       unsigned short cur_idx, drb_wr_idx_backup;
> ...
> +       txq = &dpmaif_ctrl->txq[skb_cb->txq_number];
> ...
> +       cur_idx = txq->drb_wr_idx;
> +       drb_wr_idx_backup = cur_idx;
> ...
> +       for (wr_cnt = 0; wr_cnt < payload_cnt; wr_cnt++) {
> ...
> +               bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
> +               if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
> +                       dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
> +                       atomic_set(&txq->tx_processing, 0);
> +
> +                       spin_lock_irqsave(&txq->tx_lock, flags);
> +                       txq->drb_wr_idx = drb_wr_idx_backup;
> +                       spin_unlock_irqrestore(&txq->tx_lock, flags);

What is the purpose of locking here?

> +                       return -ENOMEM;
> +               }
> ...
> +       }
> ...
> +}

[skipped]

> +struct dpmaif_drb_pd {
> +       __le32  header;
> +       __le32  p_data_addr;
> +       __le32  data_addr_ext;
> +       __le32  reserved2;
> +};
> ...
> +struct dpmaif_drb_msg {
> +       __le32  header_dw1;
> +       __le32  header_dw2;
> +       __le32  reserved4;
> +       __le32  reserved5;
> +};

Like PIT, DRB can be defined using a single structure with union. With
the same benefits as for PIT.

struct dpmaif_drb {
    __le32 header;
    union {
        struct {
            __le32 data_addr_l;
            __le32 data_addr_h;
            __le32 reserved2;
        } pd;
        struct {
            __le32 msghdr;
            __le32 reserved4;
            __le32 reserved5;
        } msg;
    };
};

But it is up to you how you define and handle these formats. I just
like unions, as you can see :)

--
Sergey
