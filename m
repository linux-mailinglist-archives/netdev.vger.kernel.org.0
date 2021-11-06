Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA3446FB8
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhKFSJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhKFSJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:09:47 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF770C061570;
        Sat,  6 Nov 2021 11:07:05 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id q13so23367765uaq.2;
        Sat, 06 Nov 2021 11:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcEPzmA1L284bZR8Qr3ibGx3jhuqPyHsP2AM9zB6niA=;
        b=JDq1I74+sG/9EU6UEo47EC6OIURudmyM2IYXcQfbOZz5ngCCdM3Hiaj/UCykV4oEBb
         ZvFmONZv4evbGKhwfj17iaukfTZrc6ebl7vnz9WbgQmFIxWcYZf9BMrzAnWCEFR+pvGi
         9Sav79V5kH4QRXTtiNa/cD49RY8XW2K7QLAbFSY74hX+JZuOOhpiyynZ7FODvvYOzcO6
         pPRrxRk2unVxoC1hngAuT8KsDdbvGDL8c5L0ZA2gOdPBloZ3xjyeh4Id5re+81qWlC6L
         hw//mh3qD8acFsJiw1TI7Z/qCYtMcSSmCGnzkfoQqbMJYcuKlmPSEdcw7OWPW8u9D4NA
         PSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcEPzmA1L284bZR8Qr3ibGx3jhuqPyHsP2AM9zB6niA=;
        b=0kDPx/FLfRy3gAWN69KKc3KDDMo99z1MRJFvmDhHYtT2FGgGiMN+GKLVbNyNqYE9Bo
         KOWLMbmDbtFWCiZvFw1V7OxHRY7e3YdQJfEl4wJVmql29Dgm08rqaLO5c3cjZm0TX1Fo
         w1zNmQ7V+270ceAnj8ifJ0vJv4X91e460pc2OVA/6j6z5r+EJB4o0X9lMYO6VOm1x5Sh
         cOMSFSw1b7uJEidUGLAu9PHj0YUXoFiXvmI6mz+CBrU3ffisY4+Q8BFKJ+CQDkSl2IBc
         yPx0SnRaCzLHvShtK3xdyyhokmlml0fq6G7/19wcBKmqrPNGnONC5gNxfqb2hEf3tb3Y
         8IUA==
X-Gm-Message-State: AOAM530RIoTu+MNtAShJ2W409y5jkJM7OTcqERsyJKEitffI6pyrgCem
        hxXosjLM61BB7RGHEpT7f2ZzJFWh5Ib4w1V58IM=
X-Google-Smtp-Source: ABdhPJzldF/wP+De19wiqdyP8tlpX49DTTiELZra86AEjbeBras36VFrf1I4lRbZKBks/N/eO3Of/TQ4SqVR7JoH6sg=
X-Received: by 2002:a05:6102:3e81:: with SMTP id m1mr82967547vsv.44.1636222025036;
 Sat, 06 Nov 2021 11:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-9-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-9-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:08:07 +0300
Message-ID: <CAHNKnsTBbyouE1Pp-UN_b9xwWXh_cjO7UH1Xhtyv7kT3U=KFAQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/14] net: wwan: t7xx: Add data path interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
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

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
> ...
> +static int dpmaif_net_rx_push_thread(void *arg)
> +{
> ...
> +       while (!kthread_should_stop()) {
> +               if (skb_queue_empty(&q->skb_queue.skb_list)) {
> +                       if (wait_event_interruptible(q->rx_wq,
> +                                                    !skb_queue_empty(&q->skb_queue.skb_list) ||
> +                                                    kthread_should_stop()))
> +                               continue;
> +               }
> +
> +               if (kthread_should_stop())
> +                       break;

Looks like the above check is used to recheck thread state after the
wait_event_interruptible() call, so the check could be moved to the
skb_queue_empty() code block to avoid odd thread state checks.

> ...
> +static void dpmaif_rx_skb(struct dpmaif_rx_queue *rxq, struct dpmaif_cur_rx_skb_info *rx_skb_info)
> +{
> +       struct sk_buff *new_skb;
> +       u32 *lhif_header;
> +
> +       new_skb = rx_skb_info->cur_skb;
> ...
> +       /* MD put the ccmni_index to the msg pkt,
> +        * so we need push it alone. Maybe not needed.
> +        */
> +       lhif_header = skb_push(new_skb, sizeof(*lhif_header));
> +       *lhif_header &= ~LHIF_HEADER_NETIF;
> +       *lhif_header |= FIELD_PREP(LHIF_HEADER_NETIF, rx_skb_info->cur_chn_idx);

Why is the skb data field used to carry packet control data? Consider
using the skb control buffer (i.e skb->cb) to carry control data
between the driver layers to make metadata handling less expensive and
increase driver performance.

> +       /* add data to rx thread skb list */
> +       ccci_skb_enqueue(&rxq->skb_queue, new_skb);
> +}
> ...
> +void dpmaif_rxq_free(struct dpmaif_rx_queue *queue)
> +{
> ...
> +       while ((skb = skb_dequeue(&queue->skb_queue.skb_list)))
> +               kfree_skb(skb);

skb_queue_purge()

> ...
> +static int dpmaif_skb_queue_init_struct(struct dpmaif_ctrl *dpmaif_ctrl,
> +                                       const unsigned int index)
> +{
> ...
> +       INIT_LIST_HEAD(&queue->skb_list.head);
> +       spin_lock_init(&queue->skb_list.lock);
> +       queue->skb_list.qlen = 0;

skb_queue_head_init()

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
> ...
> +/* lhif header feilds */
> +#define LHIF_HEADER_NW_TYPE    GENMASK(31, 29)
> +#define LHIF_HEADER_NETIF      GENMASK(28, 24)
> +#define LHIF_HEADER_F          GENMASK(22, 20)
> +#define LHIF_HEADER_FLOW       GENMASK(19, 16)

Just place control data to the skb control buffer (i.e. skb->cb) and
define this control data as a structure:

struct rx_pkt_cb {
        u8 nw_type;
        u8 netif;
        u8 flow;
};

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
> ...
> +static int dpmaif_tx_send_skb_on_tx_thread(struct dpmaif_ctrl *dpmaif_ctrl,
> +                                          struct dpmaif_tx_event *event)
> +{
> ...
> +       struct ccci_header ccci_h;
> ...
> +       skb = event->skb;
> ...
> +       ccci_h = *(struct ccci_header *)skb->data;
> +       skb_pull(skb, sizeof(struct ccci_header));

Place this metadata to the skb control buffer (i.e. skb->cb) to avoid
odd skb_push()/skb_pull() calls.

Also this looks like an abuse of ccci_header structure. In fact it
never passed to the modem along with a data packet, but searching
through the code show this as a structure usage place.

> ...
> +int dpmaif_tx_send_skb(struct dpmaif_ctrl *dpmaif_ctrl, enum txq_type txqt, struct sk_buff *skb)
> +{
> ...
> +       if (txq->tx_submit_skb_cnt < txq->tx_list_max_len && tx_drb_available) {
> +               struct dpmaif_tx_event *event;
> ...
> +               event = kmalloc(sizeof(*event), GFP_ATOMIC);
> ...
> +               INIT_LIST_HEAD(&event->entry);
> +               event->qno = txqt;
> +               event->skb = skb;
> +               event->drb_cnt = send_drb_cnt;

Please, place the packet metadata (dpmaif_tx_event data) in the skb
control buffer (i.e. skb->cb) and use skb queue API as in Rx path.
This will allow you to avoid the per-packet metadata memory allocation
and make code simple.

> +               spin_lock_irqsave(&txq->tx_event_lock, flags);
> +               list_add_tail(&event->entry, &txq->tx_event_queue);
> +               txq->tx_submit_skb_cnt++;
> +               spin_unlock_irqrestore(&txq->tx_event_lock, flags);
> +               wake_up(&dpmaif_ctrl->tx_wq);
> +
> +               return 0;
> +       }
> +
> +       cb = dpmaif_ctrl->callbacks;
> +       cb->state_notify(dpmaif_ctrl->mtk_dev, DMPAIF_TXQ_STATE_FULL, txqt);
> +
> +       return -EBUSY;

It is better to invert the above condition, handle TXQ full situation
as a corner case and packet queuing as a normal case. I.e. instead of:

        if (have_queue_space) {
                /* Enqueue packet */
                return 0;
        }
        /* Queue full notification emitting */
        return -EBUSY;

handle queuing like this:

        if (unlikely(!have_queue_space)) {
                /* Queue full notification emitting */
                return -EBUSY;
        }
        /* Enqueue packet */
        return 0;

This is a matter of taste, but makes code more readable.

--
Sergey
