Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B246B784
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhLGJkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhLGJkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:40:03 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDF6C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:36:33 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r5so13273631pgi.6
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 01:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfqI9JObO4SWvcqok/tVBR3YBTRedUXs7Q39D8brpTk=;
        b=ypkeVCNj1fwIlXktnU5RbRm0DuRdNKEegAsxWRDx4pBk0oKCpGcZerZd71lOib+t8L
         7Jkkm7aveZ+4U5F5JCnTQ5FDiLsvKiq9w0bRWIpW6lA8LdAo6anMvkThzuXPFQWsYffS
         Owfd3xgXZrFjcgAnZpzR2fEx2uLs1xoi8KTdd98ZyMuhooP1KlBqe6NhkZ+fxk4uecFN
         U/DnrzKXQOyyOA+eCidGMi35440+l/i/EyKBwTmW4v6DnGSj/DoetSOZh3l9WBhrdjNk
         Yv8vUnXg2KVorK9+VTsjDnqU2Dl30Bkj5osuElgUIorTHEyQvzfAu0MZgizkpyrvQI77
         qWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfqI9JObO4SWvcqok/tVBR3YBTRedUXs7Q39D8brpTk=;
        b=C55IgTf8qQmRECGRj8BF1/n2pIZKG/mzXK+9XAXKesWMN4/FeSLL9SrdRTFMLsfYve
         AsAu7uiRMcQc3aLRIsF/quJbS8vWkCsLDYURH9fPRpYEoR/kz6yDwm9TlURs6N4dnfXy
         z6Pq8PvjU3MNjJyoTDJCe8lDGgcetrnSgEqDh7l8XNf9KfMIlY5NyfRG5wrhtABPfVJT
         NoouTlPk3AiMKhqHUGXlhuGeohK2DdIOyVSJQhe14unDKVeO1mraRPxtAm6Foz5Hqs1k
         axPb71M2NfmgPQoUE+q/idiZnW4N0BeMoOqY7oUI5qfZDYFpbEh9XVoU5JAikzDihaNa
         5B8A==
X-Gm-Message-State: AOAM533g+ciroxtcPTtePWtw1tm1Cbv9Pi6SHS9Q79375mOwEsKivxdW
        2FOtkvGIzAjWNd1fqJQEhQFJRHbDZoeu5cg3DiNjFw==
X-Google-Smtp-Source: ABdhPJx/3Rr9y9lpdBFWsQVsmhiqkhESwRErw8TplUo/2I2ko2HSSByzprJBXbezR6DYogHfyJr5tG40usf3DBeDlLA=
X-Received: by 2002:a05:6a00:26ca:b0:4a8:3129:84e with SMTP id
 p10-20020a056a0026ca00b004a83129084emr42570419pfw.74.1638869793117; Tue, 07
 Dec 2021 01:36:33 -0800 (PST)
MIME-Version: 1.0
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 7 Dec 2021 10:48:06 +0100
Message-ID: <CAMZdPi9w6KyK2snaMEDL1go7+McExgs+Vm+eSp=K5yugDcFQJA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 05/12] net: wwan: t7xx: Add AT and MBIM WWAN ports
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ricardo,

Overall, it looks good, but:

On Tue, 7 Dec 2021 at 03:48, Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
>
> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---
>  drivers/net/wwan/t7xx/Makefile          |   1 +
>  drivers/net/wwan/t7xx/t7xx_port_proxy.c |  24 +++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.h |   1 +
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c  | 258 ++++++++++++++++++++++++
>  4 files changed, 284 insertions(+)
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c
>
[...]
> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> +{
> +       struct t7xx_port *port_private = wwan_port_get_drvdata(port);
> +       size_t actual_count = 0, alloc_size = 0, txq_mtu = 0;
> +       struct t7xx_port_static *port_static;
> +       int i, multi_packet = 1, ret = 0;
> +       struct sk_buff *skb_ccci = NULL;
> +       struct t7xx_fsm_ctl *ctl;
> +       enum md_state md_state;
> +       unsigned int count;
> +       bool port_multi;
> +
> +       count = skb->len;
> +       if (!count)
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
> +       txq_mtu = CLDMA_TXQ_MTU;
> +
> +       if (port_private->flags & PORT_F_USER_HEADER) {
> +               if (port_private->flags & PORT_F_USER_HEADER && count > txq_mtu) {
> +                       dev_err(port_private->dev, "Packet %u larger than MTU on %s port\n",
> +                               count, port_static->name);
> +                       return -ENOMEM;
> +               }
> +
> +               alloc_size = min_t(size_t, txq_mtu, count);
> +               actual_count = alloc_size;
> +       } else {
> +               alloc_size = min_t(size_t, txq_mtu, count + CCCI_H_ELEN);
> +               actual_count = alloc_size - CCCI_H_ELEN;
> +               port_multi = t7xx_port_wwan_multipkt_capable(port_static);
> +               if ((count + CCCI_H_ELEN > txq_mtu) && port_multi)
> +                       multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);
> +       }
> +
> +       for (i = 0; i < multi_packet; i++) {
> +               struct ccci_header *ccci_h = NULL;
> +
> +               if (multi_packet > 1 && multi_packet == i + 1) {
> +                       actual_count = count % (txq_mtu - CCCI_H_ELEN);
> +                       alloc_size = actual_count + CCCI_H_ELEN;
> +               }
> +
> +               skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
> +               if (!skb_ccci)
> +                       return -ENOMEM;
> +
> +               ccci_h = skb_put(skb_ccci, CCCI_H_LEN);
> +               ccci_h->packet_header = 0;
> +               ccci_h->packet_len = cpu_to_le32(actual_count + CCCI_H_LEN);
> +               ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
> +               ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
> +               ccci_h->ex_msg = 0;
> +
> +               memcpy(skb_put(skb_ccci, actual_count), skb->data + i * (txq_mtu - CCCI_H_ELEN),
> +                      actual_count);
> +
> +               t7xx_port_proxy_set_seq_num(port_private, ccci_h);
> +
> +               ret = t7xx_port_send_skb_to_md(port_private, skb_ccci, true);
> +               if (ret)
> +                       goto err_free_skb;
> +
> +               port_private->seq_nums[MTK_TX]++;
> +
> +               if (multi_packet == 1)
> +                       return actual_count;
> +               else if (multi_packet == i + 1)
> +                       return count;

wwan port tx ops is supposed to return 0 on success, and release the
processed skb. In your case it works because wwan core does:

ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
if (ret) {
        kfree_skb(skb);
        return ret;
}

So returning a positive value here (count) makes the core enter the
error case, release the skb for you and return your count value to
write fops. Eventually, you land on your feet, but it's not what was
expected from tx ops. You should simply return 0 on success and
release the skb. Alternatively, if you think partial TX is something
we need, it should be somewhat documented in the wwan_port_fops_write
function or tx_ops definition.

Regards,
Loic
