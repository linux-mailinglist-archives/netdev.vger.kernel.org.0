Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D936A22ECA7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgG0M7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgG0M7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:59:30 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49375C061794;
        Mon, 27 Jul 2020 05:59:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t15so9325993pjq.5;
        Mon, 27 Jul 2020 05:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHNOjOLT8L5bvPY4qKI4UvNASs4/aefQCEWO9D/TPoE=;
        b=o5yHaWQytRX91ifzHq/S9ZnWy78b50E6Gwrm3PzJPXnUUAUD4fhzedtA2C+nglcxX5
         aQNM/NQa+Jioh8iPem1CYAjW/K86vLNXNztmoQzy0uVBGq/xjgBe+Zj5WClmqxqTPCiL
         a/c4ymQCFxCEIm6k72avM1Yq9o6sI1F/BfixK6Pbt7x4T0YdCqUKjCoWBhlV4nUmKwVS
         o24GGQ0y6UgE8V3TH03agfXO1HEIitKsdJZ2sFtXmFRPhpCn31cV0Wbf7y6R18cxkndV
         gMYIW5DSLsFuPjmI6rqR/zDKgbfzLZLug3uSBK8qi3/8q5VpV1zLsolDG/u+kn+J+pqw
         LLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VHNOjOLT8L5bvPY4qKI4UvNASs4/aefQCEWO9D/TPoE=;
        b=pZ7dS46LRqSHShOBCECDRTgivXwX8PcvBFydWjSX4HhxTdnaWpaar4O2bMeZPSvHCQ
         k4cwt4ALua+w7WQY9mj88RdcLBBxYVZdTPQIDJ5mnTA1zbO/QHgpo7pe4PAC24RUPiCI
         ZZuoGKBg52LvWDvWl7Anoi8Mq+anVMzltqFqb2yB2UeWeNcOGiFq4Ex+Rbld/KAXslVI
         qiVI/HoIf9Ia53+LmgDfTaZJH3EcsP/UzKQItopBBNNzig/vLCN9QPehUnhZJvGTzCot
         c0VQ1CMtt5U98b/fF1DyomTAX0xWdVJbau82rgYqgCZ4IypuJ8QYycX2Njm8GRV4r0sn
         ykLQ==
X-Gm-Message-State: AOAM532zR6b5XbGUoG+3CJEsHKvsmD19+NvIKtoRSITKHcV2O9BJ1/Rh
        HD9XU7bRikKyXFh/SQ/EULkY+pFt/OeaXM4vJpo=
X-Google-Smtp-Source: ABdhPJw6Op6TMpltAU8vfBTUT5JjWbr5uNcHIx2aPv/CXQMDUoWWD3cpCXny2MNKSQFwzVd08Giqr6Ga9Z+QLVQybZg=
X-Received: by 2002:a17:902:4b:: with SMTP id 69mr2990279pla.18.1595854768443;
 Mon, 27 Jul 2020 05:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu> <20200727122242.32337-2-vadym.kochan@plvision.eu>
In-Reply-To: <20200727122242.32337-2-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 15:59:13 +0300
Message-ID: <CAHp75Ve-MyFg5QqHjywGk6X+v_F77HkRBuQsJ0Cx3WLJ5ZV43w@mail.gmail.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
>
> The current implementation supports only boards designed for the Marvell
> Switchdev solution and requires special firmware.
>
> The core Prestera switching logic is implemented in prestera_main.c,
> there is an intermediate hw layer between core logic and firmware. It is
> implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> related logic, in future there is a plan to support more devices with
> different HW related configurations.
>
> This patch contains only basic switch initialization and RX/TX support
> over SDMA mechanism.
>
> Currently supported devices have DMA access range <= 32bit and require
> ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
> allocated in proper range supported by the Prestera device.
>
> Also meanwhile there is no TX interrupt support in current firmware
> version so recycling work is scheduled on each xmit.
>
> Port's mac address is generated from the switch base mac which may be
> provided via device-tree (static one or as nvme cell), or randomly
> generated.

...

> Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

This needs more work. You have to really understand the role of each
person in the above list.
I highly recommend (re-)read sections 11-13 of Submitting Patches.

...

> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0

The idea of SPDX is to have it as a separate (standalone) comment.

...

> +enum prestera_event_type {
> +       PRESTERA_EVENT_TYPE_UNSPEC,
> +
> +       PRESTERA_EVENT_TYPE_PORT,
> +       PRESTERA_EVENT_TYPE_RXTX,
> +
> +       PRESTERA_EVENT_TYPE_MAX,

Commas in the terminators are not good.

> +};

...

> +#include "prestera_dsa.h"

The idea that you include more generic headers earlier than more custom ones.

> +#include <linux/string.h>
> +#include <linux/bitops.h>
> +#include <linux/bitfield.h>
> +#include <linux/errno.h>

Perhaps ordered?

...

> +/* TrgDev[4:0] = {Word0[28:24]} */

> + * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}

> +/* bits 13:15 -- UP */

> +/* bits 0:11 -- VID */

These are examples of useless comments.

...

> +       dsa->vlan.is_tagged = (bool)FIELD_GET(PRESTERA_W0_IS_TAGGED, words[0]);
> +       dsa->vlan.cfi_bit = (u8)FIELD_GET(PRESTERA_W1_CFI_BIT, words[1]);
> +       dsa->vlan.vpt = (u8)FIELD_GET(PRESTERA_W0_VPT, words[0]);
> +       dsa->vlan.vid = (u16)FIELD_GET(PRESTERA_W0_VID, words[0]);

Do you need those castings?

...

> +       struct prestera_msg_event_port *hw_evt;
> +
> +       hw_evt = (struct prestera_msg_event_port *)msg;

Can be one line I suppose.

...

> +       if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
> +               evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> +       else
> +               return -EINVAL;
> +
> +       return 0;

Perhaps traditional pattern, i.e.

  if (...)
    return -EINVAL;
  ...
  return 0;

...

> +       err = fw_event_parsers[msg->type].func(buf, &evt);
> +       if (!err)
> +               eh.func(sw, &evt, eh.arg);

Ditto.

> +       return err;

...

> +       memcpy(&req.param.mac, mac, sizeof(req.param.mac));

Consider to use ether_addr_*() APIs instead of open-coded mem*() ones.

...

> +#define PRESTERA_MTU_DEFAULT 1536

Don't we have global default for this?

...

> +#define PRESTERA_STATS_DELAY_MS        msecs_to_jiffies(1000)

It's not _MS.

...

> +       if (!is_up)
> +               netif_stop_queue(dev);
> +
> +       err = prestera_hw_port_state_set(port, is_up);
> +
> +       if (is_up && !err)
> +               netif_start_queue(dev);

Much better if will look lke

  if (is_up) {
  ...
  err  = ...(..., true);
  if (err)
    return err;
  ...
  } else {
    return prestera_*(..., false);
  }
  return 0;

> +       return err;

...

> +       /* Only 0xFF mac addrs are supported */
> +       if (port->fp_id >= 0xFF)
> +               goto err_port_init;

You meant 255, right?
Otherwise you have to mentioned is it byte limitation or what?

...

> +static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
> +{
> +       struct device_node *base_mac_np;
> +       struct device_node *np;

> +       np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> +       if (np) {
> +               base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> +               if (base_mac_np) {
> +                       const char *base_mac;
> +
> +                       base_mac = of_get_mac_address(base_mac_np);
> +                       of_node_put(base_mac_np);
> +                       if (!IS_ERR(base_mac))
> +                               ether_addr_copy(sw->base_mac, base_mac);
> +               }
> +       }
> +
> +       if (!is_valid_ether_addr(sw->base_mac)) {
> +               eth_random_addr(sw->base_mac);
> +               dev_info(sw->dev->dev, "using random base mac address\n");
> +       }

Isn't it device_get_mac_address() reimplementation?

> +
> +       return prestera_hw_switch_mac_set(sw, sw->base_mac);
> +}

...

> +       err = prestera_switch_init(sw);
> +       if (err) {
> +               kfree(sw);
> +               return err;
> +       }
> +
> +       return 0;

if (err)
 kfree(...);
return err;

Also, check reference counting.

...

> +#define PRESTERA_SDMA_RX_DESC_PKT_LEN(desc) \

> +       ((le32_to_cpu((desc)->word2) >> 16) & 0x3FFF)

Why not GENMASK() ?

...

> +       if (dma + sizeof(struct prestera_sdma_desc) > sdma->dma_mask) {
> +               dev_err(dma_dev, "failed to alloc desc\n");
> +               dma_pool_free(sdma->desc_pool, desc, dma);

Better first undo something *then* print a message.

> +               return -ENOMEM;
> +       }

...

> +static void prestera_sdma_rx_desc_set_len(struct prestera_sdma_desc *desc,
> +                                         size_t val)
> +{
> +       u32 word = le32_to_cpu(desc->word2);
> +
> +       word = (word & ~GENMASK(15, 0)) | val;

Shouldn't you do traditional pattern?

word = (word & ~mask) | (val & mask);

> +       desc->word2 = cpu_to_le32(word);
> +}

...

> +       dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);

> +

Redundant blank line.

> +       if (dma_mapping_error(dev, dma))
> +               goto err_dma_map;

...

> +               pr_warn_ratelimited("received pkt for non-existent port(%u, %u)\n",
> +                                   dev_id, hw_port);

netdev_warn_ratelimited() ? Or something closer to that?

...

> +       qmask = GENMASK(qnum - 1, 0);

BIT(qnum) - 1 will produce much better code I suppose.

...

> +       if (pkts_done < budget && napi_complete_done(napi, pkts_done))
> +               prestera_write(sdma->sw, PRESTERA_SDMA_RX_INTR_MASK_REG,
> +                              0xff << 2);

GENMASK() ?

...

> +       word = (word & ~GENMASK(30, 16)) | ((len + ETH_FCS_LEN) << 16);

Consider traditional pattern.

...

> +       word |= PRESTERA_SDMA_TX_DESC_DMA_OWN << 31;

I hope that was defined with U. Otherwise it's UB.

...

> +       new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);

Atomic? Why?

...

> +static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
> +                                struct prestera_tx_ring *tx_ring)
> +{

> +       int tx_retry_num = 10 * tx_ring->max_burst;

Magic!

> +       while (--tx_retry_num) {
> +               if (prestera_sdma_is_ready(sdma))
> +                       return 0;
> +
> +               udelay(1);
> +       }

unsigned int counter = ...;

do { } while (--counter);

looks better.

Also, why udelay()? Is it atomic context?

> +       return -EBUSY;
> +}

...

> +       if (!tx_ring->burst--) {

Don't do like this. It makes code harder to understand.

  if (tx_ring->...) {
    ...->burst--;
  } else {
    ...
  }

> +               tx_ring->burst = tx_ring->max_burst;
> +
> +               err = prestera_sdma_tx_wait(sdma, tx_ring);
> +               if (err)
> +                       goto drop_skb_unmap;
> +       }

-- 
With Best Regards,
Andy Shevchenko
