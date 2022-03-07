Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A204CEFD4
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiCGC4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiCGC4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:56:01 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C571D3AA7C;
        Sun,  6 Mar 2022 18:55:07 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id j201so7261380vke.11;
        Sun, 06 Mar 2022 18:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZgPrHzeAJCOP6RDbewZFZNPg6sTjexCTDU7DvHRterc=;
        b=eHBVjz+6qYWtc04QUQP/q+2FNvxMvEGGYoN7RYU1qaZOUUbSqeGCzMKGLd6tcgTHlS
         NixhWBvuyGWVWJd5PIwnIMCBUzjpGwyYPtDLdtsjR1icSgnKN3v6QSHIWKBA1gl39Y2z
         ZHcIseKIr4n0LcdQmIHX/eCT2sOOER5K0lrFNG5DDdodEAAEUgHEHXJdid7I4eH8QSIt
         YPzHOvTcpUpYv4TtJbUCVlKgBMVdWWwXp+I3HCFkup0WJoaHjC7n70yxVRN3WBYTohU1
         sS54vVJK5lkYV3PWLnncOFkw9tGHmHp4GOAzfPOiytK5fawo4BHJCZvgJqj3EBDOI5N2
         o6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgPrHzeAJCOP6RDbewZFZNPg6sTjexCTDU7DvHRterc=;
        b=LdDzEhmrtg9CBhFOUF/m1ZFGBiMxGfr1iLm4FpONPCgQ9wOXVEcQSDexd23OeZUg+i
         lAgyfyCGrCTzqzYVJdG7PzfBvr8T+zofwHr4VYhhG4ZluwZkyDzAnaHuEn280EpyFovO
         b3YZ71JMWw4jHt9JpF9Uns3ikunowIfL73xy4GjpUHImJnb1oBG7u5nlbn8on2F3qV3S
         hOD41Pq51ioGKm7xDFHCXCSzBoaPe0WuMpzavgSF/U41PDeu5YgA6DaQASKGN5p9Oj8h
         TmksACTAuMpEs/zXjBDOBuvc0RYY1zbWIZqRbzCEBc4Ah5UkxdSxd1uAiUxfNFKXdm0/
         sopg==
X-Gm-Message-State: AOAM5333Ak3egxb9I0c1wFwg5mCuMRDg/4yzBd4PHGQHLID3YLVfAgZF
        IGeqhVXOm3kAgE+BeXkCS+1G8UOqhO9/O9xVV28=
X-Google-Smtp-Source: ABdhPJzBPnbNMnax/tFjdYU2ASwDwGd+RP7Y5sA/kahp4rLe1MaXGqmITAhVa2GXIRqORrV76XeEjdk3wyr7DSRGwek=
X-Received: by 2002:a05:6122:a29:b0:321:dd99:acd8 with SMTP id
 41-20020a0561220a2900b00321dd99acd8mr3077254vkn.3.1646621706856; Sun, 06 Mar
 2022 18:55:06 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-6-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-6-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:55:15 +0300
Message-ID: <CAHNKnsTUSfieWKuw5WOFPidezoVWDKkLqQV6xnDs560QAGXiCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 05/13] net: wwan: t7xx: Add control port
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
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
>
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.

[skipped]

> +struct feature_query {
> +       __le32 head_pattern;
> +       u8 feature_set[FEATURE_COUNT];
> +       __le32 tail_pattern;
> +};
> +
> +static void t7xx_prepare_host_rt_data_query(struct t7xx_sys_info *core)
> +{
> +       struct t7xx_port_static *port_static = core->ctl_port->port_static;
> +       struct ctrl_msg_header *ctrl_msg_h;
> +       struct feature_query *ft_query;
> +       struct ccci_header *ccci_h;
> +       struct sk_buff *skb;
> +       size_t packet_size;
> +
> +       packet_size = sizeof(*ccci_h) + sizeof(*ctrl_msg_h) + sizeof(*ft_query);
> +       skb = __dev_alloc_skb(packet_size, GFP_KERNEL);
> +       if (!skb)
> +               return;
> +
> +       skb_put(skb, packet_size);
> +
> +       ccci_h = (struct ccci_header *)skb->data;
> +       t7xx_ccci_header_init(ccci_h, 0, packet_size, port_static->tx_ch, 0);
> +       ccci_h->status &= cpu_to_le32(~CCCI_H_SEQ_FLD);
> +
> +       ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
> +       t7xx_ctrl_msg_header_init(ctrl_msg_h, CTL_ID_HS1_MSG, 0, sizeof(*ft_query));
> +
> +       ft_query = (struct feature_query *)(skb->data + sizeof(*ccci_h) + sizeof(*ctrl_msg_h));
> +       ft_query->head_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
> +       memcpy(ft_query->feature_set, core->feature_set, FEATURE_COUNT);
> +       ft_query->tail_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);
> +
> +       /* Send HS1 message to device */
> +       t7xx_port_proxy_send_skb(core->ctl_port, skb);
> +}

I do not care too much, but this code and many other places could be
greatly simplified. It looks like the modem communication protocol has
a layered design, skb and its API are also designed to handle layered
protocols. It just needs to rearrange the code a bit.

For example, to avoid manual accounting of each header in the stack,
skb allocation can be implemented using a stack of allocation
functions:

struct sk_buff *t7xx_port_alloc_skb(int payload)
{
    struct sk_buff *skb = alloc_skb(payload + sizeof(struct ccci_header), ...);
    if (skb)
        skb_reserve(skb, sizeof(struct ccci_header));
    return skb;
}

struct sk_buff *t7xx_ctrl_alloc_skb(int payload)
{
    struct sk_buff *skb = t7xx_port_alloc_skb(payload + sizeof(struct
ctlr_msg_header), ...);
    if (skb)
        skb_reserve(skb, sizeof(struct ctrl_msg_header));
    return skb;
}

Message sending operation can also be perfectly stacked:

int t7xx_port_proxy_send_skb(*port, *skb)
{
    struct ccci_header *ccci_h = skb_push(skb, sizeof(*ccci_h));
    /* Build CCCI header (including seqno assignment) */
    ccci_h->packet_len = cpu_to_le32(skb->len);
    res = cldma_send_skb(..., skb, ...);
    if (res)
        return res;
    /* Update seqno counter here */
    return 0;
}

int t7xx_ctrl_send_msg(port, msg_id, skb)
{
    int len = skb->len; /* Preserve payload len */
    struct ctrl_msg_header *ctrl_msg_h = skb_push(skb, sizeof(*ctrl_msg_h));
    /* Build ctrl msg header here */
    ctrl_msg_h->data_length = cpu_to_le32(len);
    return t7xx_port_proxy_send_skb(port, skb);
}

So the above features request becomes as simple as:

void t7xx_prepare_host_rt_data_query(struct t7xx_sys_info *core)
{
    struct feature_query *ft_query;
    struct sk_buff *skb;

    skb = t7xx_ctrl_alloc_skb(sizeof(*ft_query));
    if (!skb)
        return;
    ft_query = skb_put(skb, sizeof(*ft_query));
    /* Build features request here */
    if (t7xx_ctrl_send_msg(core->ctl_port, CTL_ID_HS1_MSG, skb))
        kfree_skb(skb);
}

Once the allocation and sending functions are implemented in a stacked
way, many other places can be simplified in a similar way.

[skipped]

> +static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
> +                                enum t7xx_fsm_event_state event_id,
> +                                enum t7xx_fsm_event_state err_detect)
> +{
> +       struct t7xx_sys_info *core_info = &md->core_md;
> +       struct device *dev = &md->t7xx_dev->pdev->dev;
> +       struct t7xx_fsm_event *event, *event_next;
> +       unsigned long flags;
> +       void *event_data;
> +       int ret;
> +
> +       t7xx_prepare_host_rt_data_query(core_info);
> +
> +       while (!kthread_should_stop()) {
> +               bool event_received = false;
> +
> +               spin_lock_irqsave(&ctl->event_lock, flags);
> +               list_for_each_entry_safe(event, event_next, &ctl->event_queue, entry) {
> +                       if (event->event_id == err_detect) {
> +                               list_del(&event->entry);
> +                               spin_unlock_irqrestore(&ctl->event_lock, flags);
> +                               dev_err(dev, "Core handshake error event received\n");
> +                               goto err_free_event;
> +                       } else if (event->event_id == event_id) {
> +                               list_del(&event->entry);
> +                               event_received = true;
> +                               break;
> +                       }
> +               }
> +               spin_unlock_irqrestore(&ctl->event_lock, flags);
> +
> +               if (event_received)
> +                       break;
> +
> +               wait_event_interruptible(ctl->event_wq, !list_empty(&ctl->event_queue) ||
> +                                        kthread_should_stop());
> +               if (kthread_should_stop())
> +                       goto err_free_event;
> +       }
> +
> +       if (ctl->exp_flg)
> +               goto err_free_event;
> +
> +       event_data = (void *)event + sizeof(*event);

In the V2, the event structure has a data field. But then it was
dropped and now the attached data offset is manually calculated. Why
did you do this, why event->data is not suitable here?

> +       ret = t7xx_parse_host_rt_data(ctl, core_info, dev, event_data, event->length);
> +       if (ret) {
> +               dev_err(dev, "Host failure parsing runtime data: %d\n", ret);
> +               goto err_free_event;
> +       }
> +
> +       if (ctl->exp_flg)
> +               goto err_free_event;
> +
> +       ret = t7xx_prepare_device_rt_data(core_info, dev, event_data, event->length);
> +       if (ret) {
> +               dev_err(dev, "Device failure parsing runtime data: %d", ret);
> +               goto err_free_event;
> +       }
> +
> +       core_info->ready = true;
> +       core_info->handshake_ongoing = false;
> +       wake_up(&ctl->async_hk_wq);
> +err_free_event:
> +       kfree(event);
> +}

[skipped]

> +static int port_ctl_init(struct t7xx_port *port)
> +{
> +       struct t7xx_port_static *port_static = port->port_static;
> +
> +       port->skb_handler = &control_msg_handler;

& is not necessary here and only misguides readers.

> +       port->thread = kthread_run(port_ctl_rx_thread, port, "%s", port_static->name);
> +       if (IS_ERR(port->thread)) {
> +               dev_err(port->dev, "Failed to start port control thread\n");
> +               return PTR_ERR(port->thread);
> +       }
> +
> +       port->rx_length_th = CTRL_QUEUE_MAXLEN;
> +       return 0;
> +}

[skipped]

> -static struct t7xx_port_static t7xx_md_ports[1];
> +static struct t7xx_port_static t7xx_md_ports[] = {
> +       {
> +               .tx_ch = PORT_CH_CONTROL_TX,
> +               .rx_ch = PORT_CH_CONTROL_RX,
> +               .txq_index = Q_IDX_CTRL,
> +               .rxq_index = Q_IDX_CTRL,
> +               .txq_exp_index = 0,
> +               .rxq_exp_index = 0,
> +               .path_id = CLDMA_ID_MD,
> +               .flags = 0,

Zero initializer is not needed here, a static variable is filled with
zeros automatically.

> +               .ops = &ctl_port_ops,
> +               .name = "t7xx_ctrl",
> +       },
> +};

[skipped]

> +void t7xx_port_proxy_send_msg_to_md(struct port_proxy *port_prox, enum port_ch ch,
> +                                   unsigned int msg, unsigned int ex_msg)

This function is called only from the control port code and only with
ch = PORT_CH_CONTROL_TX, so I would like to recommend to move it there
and drop the ch argument.

> +{
> +       struct ctrl_msg_header *ctrl_msg_h;
> +       struct ccci_header *ccci_h;
> +       struct t7xx_port *port;
> +       struct sk_buff *skb;
> +       int ret;
> +
> +       port = t7xx_proxy_get_port_by_ch(port_prox, ch);
> +       if (!port)
> +               return;
> +
> +       skb = __dev_alloc_skb(sizeof(*ccci_h), GFP_KERNEL);
> +       if (!skb)
> +               return;
> +
> +       if (ch == PORT_CH_CONTROL_TX) {
> +               ccci_h = (struct ccci_header *)(skb->data);
> +               t7xx_ccci_header_init(ccci_h, CCCI_HEADER_NO_DATA,
> +                                     sizeof(*ctrl_msg_h) + sizeof(*ccci_h), ch, 0);
> +               ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + sizeof(*ccci_h));
> +               t7xx_ctrl_msg_header_init(ctrl_msg_h, msg, ex_msg, 0);
> +               skb_put(skb, sizeof(*ccci_h) + sizeof(*ctrl_msg_h));
> +       } else {
> +               ccci_h = skb_put(skb, sizeof(*ccci_h));
> +               t7xx_ccci_header_init(ccci_h, CCCI_HEADER_NO_DATA, msg, ch, ex_msg);
> +       }
> +
> +       ret = t7xx_port_proxy_send_skb(port, skb);
> +       if (ret) {
> +               struct t7xx_port_static *port_static = port->port_static;
> +
> +               dev_kfree_skb_any(skb);
> +               dev_err(port->dev, "port%s send to MD fail\n", port_static->name);
> +       }
> +}

--
Sergey
