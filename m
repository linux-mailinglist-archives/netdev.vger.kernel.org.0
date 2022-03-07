Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4134C4CEFD7
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiCGC46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCGC45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:56:57 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0D849925;
        Sun,  6 Mar 2022 18:56:04 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id g21so15168327vsp.6;
        Sun, 06 Mar 2022 18:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWo2gGZzgADcS75WrUOeEqsX511pkSnvqcgFQoAG8dM=;
        b=RWd1FsiSILFwP6sjlQkyCQ/qB4ZZTqobfVUPBIH8mTpMlQdGhgKEfKoKbC9loELSTt
         u1R9RpUGnDsG1NkzH9ufOsuL1+GLOo8OVy8YhiNYN0UkaESYB5LHh/1gUQWJrhtRERYN
         EY0qrOLhP6yLp8K03i86B06gKy4oNurW5njgONfjadQIKMJeVASV70O0UVrYFftRDJpR
         oxv6gRBS58W8Jn6aEy5+Gy37GrShM4POtB7+DLADbbXFSjNT+2krXTaGP/y4+dHvBIuM
         fzVrRn6ylWdCQcOlhtn2Sdd+rKrgmcnlnMESIRnS3grhxUVJf1n3u+1wgd7JQJnI435x
         bx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWo2gGZzgADcS75WrUOeEqsX511pkSnvqcgFQoAG8dM=;
        b=QiiOXbbNIUDdoW6hqiNTgkbbVa2wZlzESDaGTkK9uykoFULi558GAgMj8sPuX8lyjH
         wkbkImsaSXE0dd46tXpBYJ3o+8RgV8YtkxMRPswT2ZMyMQHu0BQtGa6J0niklAgwE7Zc
         K/ypzSEe8pAfudnmNUaDhOMvDEAXrG1hK2xAs+nECMKFZRb8wjpmcBKl+59ubkIN8F2D
         UU5m+qujseVCEDbHP5yt5/Ms0jRi/+FwZctS3g70yD707YsdfgITCNHeuhJANOF+CpeP
         Nm4ryxreyrqrgidHhkUOw+wJ+Nh3Cdb1LcYXVq5K0i/IBisPmXiCtPlJlPWs1F2LfKOk
         khWg==
X-Gm-Message-State: AOAM530aSon7mDED5pKRzSLU9L4rX38WMGSIegC7mJbUpMktTwgbjhgW
        7ClkGaD+2Wdv+/WnjxFhrw1AQbrnBYPA2+9N67f9ExXr4mg=
X-Google-Smtp-Source: ABdhPJw2ycb5fOnzqOYm0Dxxb77hoIIDqNFo6rYeEt+aV74xJ94JFZA0JOXZ3UMXft3O6wTQItDzDjGabuh1o1VZ79U=
X-Received: by 2002:a67:c11d:0:b0:30a:a96:9d4a with SMTP id
 d29-20020a67c11d000000b0030a0a969d4amr3184854vsj.69.1646621763955; Sun, 06
 Mar 2022 18:56:03 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:56:13 +0300
Message-ID: <CAHNKnsSZ_2DAPQRsa45VZZ1UYD6mga_T0jfX_J+sb1HNCwpOPA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 06/13] net: wwan: t7xx: Add AT and MBIM WWAN ports
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
> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.

[skipped]

> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> +{
> +       struct t7xx_port *port_private = wwan_port_get_drvdata(port);
> +       size_t actual_len, alloc_size, txq_mtu = CLDMA_MTU;
> +       struct t7xx_port_static *port_static;
> +       unsigned int len, i, packets;
> +       struct t7xx_fsm_ctl *ctl;
> +       enum md_state md_state;
> +
> +       len = skb->len;
> +       if (!len || !port_private->rx_length_th || !port_private->chan_enable)
> +               return -EINVAL;
> +
> +       port_static = port_private->port_static;
> +       ctl = port_private->t7xx_dev->md->fsm_ctl;
> +       md_state = t7xx_fsm_get_md_state(ctl);
> +       if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
> +               dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
> +                        port_static->name, md_state);
> +               return -ENODEV;
> +       }
> +
> +       alloc_size = min_t(size_t, txq_mtu, len + CCCI_HEADROOM);
> +       actual_len = alloc_size - CCCI_HEADROOM;
> +       packets = DIV_ROUND_UP(len, txq_mtu - CCCI_HEADROOM);
> +
> +       for (i = 0; i < packets; i++) {
> +               struct ccci_header *ccci_h;
> +               struct sk_buff *skb_ccci;
> +               int ret;
> +
> +               if (packets > 1 && packets == i + 1) {
> +                       actual_len = len % (txq_mtu - CCCI_HEADROOM);
> +                       alloc_size = actual_len + CCCI_HEADROOM;
> +               }

Why do you track the packet number? Why not track the offset in the
passed data? E.g.:

for (off = 0; off < len; off += chunklen) {
    chunklen = min(len - off, CLDMA_MTU - sizeof(struct ccci_header);
    skb_ccci = alloc_skb(chunklen + sizeof(struct ccci_header), ...);
    skb_put_data(skb_ccci, skb->data + off, chunklen);
    /* Send skb_ccci */
}

> +               skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
> +               if (!skb_ccci)
> +                       return -ENOMEM;
> +
> +               ccci_h = skb_put(skb_ccci, sizeof(*ccci_h));
> +               t7xx_ccci_header_init(ccci_h, 0, actual_len + sizeof(*ccci_h),
> +                                     port_static->tx_ch, 0);
> +               skb_put_data(skb_ccci, skb->data + i * (txq_mtu - CCCI_HEADROOM), actual_len);
> +               t7xx_port_proxy_set_tx_seq_num(port_private, ccci_h);
> +
> +               ret = t7xx_port_send_skb_to_md(port_private, skb_ccci);
> +               if (ret) {
> +                       dev_kfree_skb_any(skb_ccci);
> +                       dev_err(port_private->dev, "Write error on %s port, %d\n",
> +                               port_static->name, ret);
> +                       return ret;
> +               }
> +
> +               port_private->seq_nums[MTK_TX]++;

Sequence number tracking as well as CCCI header construction are
common operations, so why not move them to t7xx_port_send_skb_to_md()?

> +       }
> +
> +       dev_kfree_skb(skb);
> +       return 0;
> +}

--
Sergey
