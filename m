Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639B1510C68
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355999AbiDZXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355994AbiDZXJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:09:26 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E903586B;
        Tue, 26 Apr 2022 16:06:17 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id w21so8214uan.3;
        Tue, 26 Apr 2022 16:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M+2LynW425H8sZZr+Nji7eLzhzllLwXclikvPApWbbs=;
        b=hENXxB7YcCHl3W+jQLxJvM/1B0lvDLpy/9lpzXAG5zv3zv+lgsoUZKgNeaHV3if2Ho
         kUWpyc20TwNlxCh7nsHd/3y338ZpkcTl39og6bBcHs2jLT0Wx0oxgEZjdNQ4SyaBp+7z
         Yz1eos3lYvJXaTmLNDLUdvf8Ve2Fd2NSKBNamRYQnK+HnwHDcU2+s1wa9NbnHsVMTA88
         VuFkRX9ovVV2Kx1/i1KFp6V9kUGHUKrCixf1csBmjN7+JBJqbRdSgTt+1UYE76UGD4k0
         IH1F/WyMMsHdnq1ewV/SL/ia31b0Kyljvp0LWfYcxFBJjldwn4DffyLOxBNn4GbkUgqV
         fb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M+2LynW425H8sZZr+Nji7eLzhzllLwXclikvPApWbbs=;
        b=qGFmZo72zppV7p+BHG8h8x24Bc0apJVYXEKsRZAmWfIB1aqpRDYAD+MI6pZdxURAOM
         D6Ryo11xMF7RWe2ASK4rjE51dvFwVhJ9bnmRcxAQgu8dzm5j4lHVFQ3m5UFi/0yfIAtM
         daAwQG3WXommWGo7nYA8DYfUAGmhofjQ3bDJ2gk/sB2LhuGllyZi09lzGUgZirD635t4
         CfM/nspgUc6B0/cdtvbML1ychQd9/uLESqYICYTDcPbpIlXXCieZUm/f2Qw8wBY0URF5
         4wD2ex6vpm2Kx8dGiysF6toEck0KI/Ajsym2pVAvmmtB+R5Xt1rd9IEF92pQzr7vQ1zL
         tLhg==
X-Gm-Message-State: AOAM531KMhCkGJjTO0cULH3R0Kjur2TlqSIB0CNcliIxY/BHGjUA0WJa
        DUyibqaVRPEHW0vfgKPv/2mUT2K0KqIKDYb2PpY=
X-Google-Smtp-Source: ABdhPJysSEDQdBntu4NJysMxUiK2yp7JRTi9hNikscsmWCHwsOGwfVIKEM5p6gJLTCbbAZeDsLDzh47ILrT8qj+9abo=
X-Received: by 2002:ab0:284c:0:b0:362:88a1:979e with SMTP id
 c12-20020ab0284c000000b0036288a1979emr4158007uaq.74.1651014376415; Tue, 26
 Apr 2022 16:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-5-ricardo.martinez@linux.intel.com> <CAHNKnsQWThUnMnk6ruGek9cuDKOAcPa18nA7-CgLf58=iEgE0g@mail.gmail.com>
 <MWHPR1101MB231920A2152DC2FC7B2FBB3CE0FB9@MWHPR1101MB2319.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR1101MB231920A2152DC2FC7B2FBB3CE0FB9@MWHPR1101MB2319.namprd11.prod.outlook.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 27 Apr 2022 02:06:16 +0300
Message-ID: <CAHNKnsQLwMMpFjOVvJUt5927g5dGUKAe_rNRuEBgCRR=KuipPg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy infrastructure
To:     "Veleta, Moises" <moises.veleta@intel.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        linuxwwan <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <soumya.prakash.mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Moises,

On Tue, Apr 26, 2022 at 10:46 PM Veleta, Moises <moises.veleta@intel.com> w=
rote:
> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Sent: Monday, April 25, 2022 4:53 PM
> To: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-wireless@vger.=
kernel.org <linux-wireless@vger.kernel.org>; Jakub Kicinski <kuba@kernel.or=
g>; David Miller <davem@davemloft.net>; Johannes Berg <johannes@sipsolution=
s.net>; Loic Poulain <loic.poulain@linaro.org>; Kumar, M Chetan <m.chetan.k=
umar@intel.com>; Devegowda, Chandrashekar <chandrashekar.devegowda@intel.co=
m>; linuxwwan <linuxwwan@intel.com>; chiranjeevi.rapolu@linux.intel.com <ch=
iranjeevi.rapolu@linux.intel.com>; Liu, Haijun <haijun.liu@mediatek.com>; H=
anania, Amir <amir.hanania@intel.com>; Andy Shevchenko <andriy.shevchenko@l=
inux.intel.com>; Sharma, Dinesh <dinesh.sharma@intel.com>; Lee, Eliot <elio=
t.lee@intel.com>; Jarvinen, Ilpo Johannes <ilpo.johannes.jarvinen@intel.com=
>; Veleta, Moises <moises.veleta@intel.com>; Bossart, Pierre-louis <pierre-=
louis.bossart@intel.com>; Sethuraman, Muralidharan <muralidharan.sethuraman=
@intel.com>; Mishra, Soumya Prakash <soumya.prakash.mishra@intel.com>; Kanc=
harla, Sreehari <sreehari.kancharla@intel.com>; Sahu, Madhusmita <madhusmit=
a.sahu@intel.com>
> Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy in=
frastructure
>
> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> Port-proxy provides a common interface to interact with different types
>> of ports. Ports export their configuration via `struct t7xx_port` and
>> operate as defined by `struct port_ops`.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.=
com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.co=
m>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>
>> From a WWAN framework perspective:
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> [skipped]
>
>> +int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
>> +{
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->rx_wq.lock, flags);
>> +       if (port->rx_skb_list.qlen >=3D port->rx_length_th) {
>> +               spin_unlock_irqrestore(&port->rx_wq.lock, flags);
>
> Probably skb should be freed here before returning. The caller assumes
> that skb will be consumed even in case of error.
>
> [MV] We do not drop port ctrl messages. We keep them and try again later.
> Whereas WWAN skbs are dropped if conditions are met.

I missed that the WWAN port returns no error when it drops the skb.
And then I concluded that any failure to process the CCCI message
should be accomplished with the skb freeing. Now the handling of CCCI
messages is more clear to me. Thank you for the clarifications!

To avoid similar misinterpretation in the future, I thought that the
skb freeing in the WWAN port worth a comment. Something to describe
that despite dropping the message, the return code is zero, indicating
skb consumption. Similarly in this (t7xx_port_enqueue_skb) function.
Something like: "return an error here, the caller will try again
later". And maybe in t7xx_cldma_gpd_rx_from_q() near the loop break
after the .skb_recv() failure test. Something like: "break message
processing for now will try this message later".

What do you think?

>> +               return -ENOBUFS;
>> +       }
>> +       __skb_queue_tail(&port->rx_skb_list, skb);
>> +       spin_unlock_irqrestore(&port->rx_wq.lock, flags);
>> +
>> +       wake_up_all(&port->rx_wq);
>> +       return 0;
>> +}
>
> [skipped]
>
>> +static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct s=
k_buff *skb)
>> +{
>> +       struct ccci_header *ccci_h =3D (struct ccci_header *)skb->data;
>> +       struct t7xx_pci_dev *t7xx_dev =3D queue->md_ctrl->t7xx_dev;
>> +       struct t7xx_fsm_ctl *ctl =3D t7xx_dev->md->fsm_ctl;
>> +       struct device *dev =3D queue->md_ctrl->dev;
>> +       struct t7xx_port_conf *port_conf;
>> +       struct t7xx_port *port;
>> +       u16 seq_num, channel;
>> +       int ret;
>> +
>> +       if (!skb)
>> +               return -EINVAL;
>> +
>> +       channel =3D FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status=
));
>> +       if (t7xx_fsm_get_md_state(ctl) =3D=3D MD_STATE_INVALID) {
>> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, m=
odem not ready\n", channel);
>> +               goto drop_skb;
>> +       }
>> +
>> +       port =3D t7xx_port_proxy_find_port(t7xx_dev, queue, channel);
>> +       if (!port) {
>> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, p=
ort not found\n", channel);
>> +               goto drop_skb;
>> +       }
>> +
>> +       seq_num =3D t7xx_port_next_rx_seq_num(port, ccci_h);
>> +       port_conf =3D port->port_conf;
>> +       skb_pull(skb, sizeof(*ccci_h));
>> +
>> +       ret =3D port_conf->ops->recv_skb(port, skb);
>> +       if (ret) {
>> +               skb_push(skb, sizeof(*ccci_h));
>
> Header can not be pushed back here, since the .recv_skb() callback
> consumes (frees) skb even in case of error. See
> t7xx_port_wwan_recv_skb() and my comment in t7xx_port_enqueue_skb().
> Pushing the header back after failure will trigger the use-after-free
> error.
>
> [MV] Since t7xx_port_wwan_recv_skb returns 0 when dropping a skb, it skip=
s this push operation and
> will not trigger the error stated. Inside of that function an error is pr=
inted.
>
>> +               return ret;
>> +       }
>> +
>> +       port->seq_nums[MTK_RX] =3D seq_num;
>
> The expected sequence number updated only on successful .recv_skb()
> exit. This will trigger the out-of-order seqno warning on a next
> message after a .recv_skb() failure. Is this intentional behaviour?
>
> Maybe the expected sequence number should be updated before the
> .recv_skb() call? Or even the sequence number update should be moved
> to t7xx_port_next_rx_seq_num()?
>
> [MV] For t7xx_port_wwan_recv_skb, it drops skb and seq_nums is updated.
> for t7xx_port_enqueue_skb, it retains skb and can be processed again late=
r, skipping this update upon error.

Now this is clear to me. Thanks.

>> +       return 0;
>> +
>> +drop_skb:
>> +       dev_kfree_skb_any(skb);
>> +       return 0;
>> +}

--=20
Sergey
