Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1074625E1C9
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgIDTMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgIDTM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:12:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52F4C061244;
        Fri,  4 Sep 2020 12:12:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so1102910pjb.2;
        Fri, 04 Sep 2020 12:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IlLZrvIpf3gvwuhO/jiU9FNJ5/vaZ2r/RuQquNPXPm8=;
        b=DfwpGoH/MdxgIyRhgVuUngnS7BpCb5D+Pwv+jZ2TFey4RPjriwzOe+2v2OBGhxzHWD
         TQ1DewNmVKrqq1OBy1VYtOPspPbpJWaeCLLCmtaj5DDgmWYglPQFS2RghZb2U9/BlBsG
         t2kTXl/FXGAwrqyPNItAFiNpaA1yBaF/yx3hytPpKEhuJynVjuX7MEv0YycRE/95JjHY
         ZlIk8+JEF5/HbbboEUAAgCaelEExID6R+xCTBw45KEzdqPRGqm5bMOJbS5ohhO6DiJhW
         pxQazruGhQM/49xngfWRON4JOyZFek4USj/PUFgVOhJsX1sFn53dFqKuXYW/VWopFaeT
         YM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IlLZrvIpf3gvwuhO/jiU9FNJ5/vaZ2r/RuQquNPXPm8=;
        b=N3xcVXFmllRpZDuN4wGLfNpC3Oh5SUB0ZekUeXMF421mYEDUydlpggH8+vlhw4ahYM
         og+K/Rkod51SWgyeDr9q8yXEr9X6hE0NXGEzAOGOBMw3v7T236FykIOpxmyxy6tbvm2G
         g1iP3IlDaUGAHk1+K6gqcaObaRUrotzl7JpBAD533Fjr6lya/9K+WnxA7Hdf1GWDr0hJ
         DWXFHdBPKYWeWLQJkKqTrQjHK1Rk9yxRQ0MdMlXONzuZpLML75KMukkvty5BK05F6ttD
         pKXLA7/BIhVGZhm4DpW1rYcnxrSnogU8JErHPdo4tnE1LZSq3EXyRfiGeNY6mlNar4p9
         AStw==
X-Gm-Message-State: AOAM530ewMpyKKhVSaY3RHQZ8qRqjdBvcfhIzY/zh18s0sFEJhgXNCer
        8HmEZ8uope8D+Xv1O1PDda4NgbdwLXt4N+FPs5cpoJEho+RoV3Tk
X-Google-Smtp-Source: ABdhPJzb6E5ImxIqYIXRGkG0NikbiJvHAEr9C4x0QE+vpHdKirowZ3hCG1bdfI3vKu+pLO1alNh9L0igy4z3eeQ8u8c=
X-Received: by 2002:a17:90b:fc4:: with SMTP id gd4mr3030485pjb.129.1599246745170;
 Fri, 04 Sep 2020 12:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu> <20200904165222.18444-2-vadym.kochan@plvision.eu>
In-Reply-To: <20200904165222.18444-2-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 4 Sep 2020 22:12:07 +0300
Message-ID: <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
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

On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
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
> generated. This is required by the firmware.

...

> +#define prestera_dev(sw)               ((sw)->dev->dev)

The point of this is...? (What I see it's 2 characters longer)

...

> +       words[0] = ntohl(dsa_words[0]);
> +       words[1] = ntohl(dsa_words[1]);
> +       words[2] = ntohl(dsa_words[2]);
> +       words[3] = ntohl(dsa_words[3]);

This is (semi-)NIH of be32_to_cpu_array()

You may add an additional patch to provide ntohl_array() as an alias
how it's done for the rest:
https://elixir.bootlin.com/linux/v5.9-rc3/source/include/linux/byteorder/generic.h#L123

...

> +       dsa->vlan.vid &= ~PRESTERA_VID_MASK;
> +       dsa->vlan.vid |= FIELD_PREP(PRESTERA_VID_MASK, field);

Consider to use uXX_replace_bits() (XX for size of the variable).
Look at bitfield.h closer.

...

> +       dsa->hw_dev_num &= PRESTERA_W3_HW_DEV_NUM;
> +       dsa->hw_dev_num |= FIELD_PREP(PRESTERA_DEV_NUM_MASK, field);

Ditto? (Not sure why first line w/o _MASK)

...

> +       if (dsa->hw_dev_num >= BIT(12))
> +               return -EINVAL;
> +       if (dsa->port_num >= BIT(17))
> +               return -EINVAL;

Magic numbers!

...

> +       words[3] |= FIELD_PREP(PRESTERA_W3_HW_DEV_NUM, (dsa->hw_dev_num >> 5));

Ditto.

...

> +       dsa_words[0] = htonl(words[0]);
> +       dsa_words[1] = htonl(words[1]);
> +       dsa_words[2] = htonl(words[2]);
> +       dsa_words[3] = htonl(words[3]);

NIH of cpu_to_be32_array().

...

> +/*
> + * Copyright (c) 2020 Marvell International Ltd. All rights reserved.
> + *
> + */

One line.

...

> +       err = prestera_find_event_handler(sw, msg->type, &eh);

> +       if (err || !fw_event_parsers[msg->type].func)
> +               return -EEXIST;

Why shadowing error code?

...

> +       struct prestera_msg_port_info_req req = {
> +               .port = port->id

Leave comma here.
Another possibility, if you not expect this to grow, move to one line.

> +       };

...

> +               .param = {.admin_state = admin_state}

+ white spaces? Whatever you choose, just be consistent among all
similar definitions.

...

> +               .port = port->hw_id,
> +               .dev = port->dev_id

Leave comma.

...

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
> +               .port = port->hw_id,
> +               .dev = port->dev_id

Ditto. I have a deja vu that I already pointed out to these.

> +       };

...

> +       err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> +                              &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> +       if (err)
> +               return err;
> +
> +       caps->supp_link_modes = resp.param.cap.link_mode;
> +       caps->supp_fec = resp.param.cap.fec;
> +       caps->type = resp.param.cap.type;
> +       caps->transceiver = resp.param.cap.transceiver;
> +

> +       return err;

return 0;

> +}

...

> +               .param = {.autoneg = {.link_mode = link_modes,
> +                                     .enable = autoneg,
> +                                     .fec = fec}

Fix indentation and style.

> +               }

...

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_STATS,
> +               .port = port->hw_id,
> +               .dev = port->dev_id

+ Comma.

> +       };

...

> +/*
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */

One line.

...

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/netdevice.h>
> +#include <linux/netdev_features.h>
> +#include <linux/etherdevice.h>
> +#include <linux/jiffies.h>
> +#include <linux/of.h>
> +#include <linux/of_net.h>

Perhaps sorted?

...

> +static int prestera_port_state_set(struct net_device *dev, bool is_up)
> +{
> +       struct prestera_port *port = netdev_priv(dev);
> +       int err;
> +
> +       if (is_up) {
> +               err = prestera_hw_port_state_set(port, true);
> +               if (err)
> +                       return err;
> +
> +               netif_start_queue(dev);
> +       } else {
> +               netif_stop_queue(dev);
> +
> +               err = prestera_hw_port_state_set(port, false);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static int prestera_port_open(struct net_device *dev)
> +{
> +       return prestera_port_state_set(dev, true);
> +}
> +
> +static int prestera_port_close(struct net_device *dev)
> +{
> +       return prestera_port_state_set(dev, false);
> +}

What the point to have above function if you simple can put its
contents in these two?

...

> +       /* firmware requires that port's mac address contains first 5 bytes
> +        * of base mac address

mac -> MAC? (two cases)

> +        */

...

> +static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
> +                                    u64 link_modes, u8 fec)
> +{
> +       bool refresh = false;

> +       int err = 0;

Redundant assignment.

> +       if (port->caps.type != PRESTERA_PORT_TYPE_TP)
> +               return enable ? -EINVAL : 0;
> +
> +       if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
> +               port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
> +               port->adver_link_modes = link_modes;
> +               refresh = true;
> +       }
> +
> +       if (port->autoneg == enable && !(port->autoneg && refresh))
> +               return 0;
> +
> +       err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
> +                                          port->adver_fec);
> +       if (err)

> +               return -EINVAL;

Why shadowed?

> +       port->autoneg = enable;
> +       return 0;
> +}

...

> +       /* firmware requires that port's mac address consist of the first
> +        * 5 bytes of base mac address
> +        */


> +       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);

Can't you call above helper for that?

...

> +       dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;

Why explicit casting?

...

> +static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
> +{
> +       struct device_node *base_mac_np;
> +       struct device_node *np;
> +
> +       np = of_find_compatible_node(NULL, NULL, "marvell,prestera");

> +       if (np) {

I think it's useless check, b/c...

> +               base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);

...this will return error.

So, something like struct device_node *np = of_find_...(...); above.

> +               if (base_mac_np) {

I think it's useless check.
Similar as above.

> +                       const char *base_mac;
> +
> +                       base_mac = of_get_mac_address(base_mac_np);
> +                       of_node_put(base_mac_np);
> +                       if (!IS_ERR(base_mac))
> +                               ether_addr_copy(sw->base_mac, base_mac);
> +               }
> +       }
> +       if (!is_valid_ether_addr(sw->base_mac)) {
> +               eth_random_addr(sw->base_mac);
> +               dev_info(sw->dev->dev, "using random base mac address\n");
> +       }
> +
> +       return prestera_hw_switch_mac_set(sw, sw->base_mac);
> +}

...

> +int prestera_device_register(struct prestera_device *dev)
> +{
> +       struct prestera_switch *sw;
> +       int err;
> +
> +       sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> +       if (!sw)
> +               return -ENOMEM;
> +
> +       dev->priv = sw;
> +       sw->dev = dev;
> +
> +       err = prestera_switch_init(sw);
> +       if (err) {
> +               kfree(sw);

> +               return err;
> +       }
> +
> +       return 0;

return err;

> +}

...

> +#include <linux/dmapool.h>
> +#include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/netdevice.h>
> +#include <linux/platform_device.h>

...

> +#define PRESTERA_SDMA_RX_DESC_IS_RCVD(desc) \
> +       (PRESTERA_SDMA_RX_DESC_OWNER((desc)) == PRESTERA_SDMA_RX_DESC_CPU_OWN)

Double (()) make no sense here.

...

> +static void prestera_sdma_rx_desc_set_len(struct prestera_sdma_desc *desc,
> +                                         size_t val)
> +{
> +       u32 word = le32_to_cpu(desc->word2);
> +
> +       word = (word & ~GENMASK(15, 0)) | val;
> +       desc->word2 = cpu_to_le32(word);
> +}

Why not simple le32_replace_bits() ?

...

> +       port = prestera_port_find_by_hwid(sdma->sw, dev_id, hw_port);
> +       if (unlikely(!port)) {

> +               pr_warn_ratelimited("received pkt for non-existent port(%u, %u)\n",
> +                                   dev_id, hw_port);

What's wrong with dev_warn_ratelimited() ?

> +               return -EEXIST;
> +       }

...

> +               for (b = 0; b < bnum; b++) {
> +                       struct prestera_sdma_buf *buf = &ring->bufs[b];
> +
> +                       err = prestera_sdma_buf_init(sdma, buf);
> +                       if (err)
> +                               return err;
> +
> +                       err = prestera_sdma_rx_skb_alloc(sdma, buf);
> +                       if (err)

No need to uninit previously init buffers?
No need to dealloc previously allocated stuff?

> +                               return err;

...

> +                       if (b == 0)
> +                               continue;
> +
> +                       prestera_sdma_rx_desc_set_next(sdma,
> +                                                      ring->bufs[b - 1].desc,
> +                                                      buf->desc_dma);
> +
> +                       if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
> +                               prestera_sdma_rx_desc_set_next(sdma, buf->desc,
> +                                                              head->desc_dma);

I guess knowing what the allowed range of bnum the above can be optimized.

> +               }

...

> +       u32 word = le32_to_cpu(desc->word2);
> +
> +       word = (word & ~GENMASK(30, 16)) | ((len + ETH_FCS_LEN) << 16);
> +
> +       desc->word2 = cpu_to_le32(word);

le32_replace_bits()

...

> +static void prestera_sdma_tx_desc_xmit(struct prestera_sdma_desc *desc)
> +{
> +       u32 word = le32_to_cpu(desc->word1);
> +
> +       word |= PRESTERA_SDMA_TX_DESC_DMA_OWN << 31;
> +
> +       /* make sure everything is written before enable xmit */
> +       wmb();
> +
> +       desc->word1 = cpu_to_le32(word);

Seems to me it's also safe to use le32_replace_bits(), but I'm not
sure if desc->word1 can be changed after barrier by somebody else.

> +}

...

> +       for (b = 0; b < bnum; b++) {
> +               struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
> +
> +               err = prestera_sdma_buf_init(sdma, buf);
> +               if (err)
> +                       return err;
> +
> +               prestera_sdma_tx_desc_init(sdma, buf->desc);
> +
> +               buf->is_used = false;
> +
> +               if (b == 0)
> +                       continue;
> +
> +               prestera_sdma_tx_desc_set_next(sdma, tx_ring->bufs[b - 1].desc,
> +                                              buf->desc_dma);
> +
> +               if (b == PRESTERA_SDMA_TX_DESC_PER_Q - 1)
> +                       prestera_sdma_tx_desc_set_next(sdma, buf->desc,
> +                                                      head->desc_dma);
> +       }

Similar comments as per above similar for-loop.

...

> +static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
> +                                struct prestera_tx_ring *tx_ring)
> +{
> +       int tx_retry_num = PRESTERA_SDMA_WAIT_MUL * tx_ring->max_burst;
> +
> +       do {
> +               if (prestera_sdma_is_ready(sdma))
> +                       return 0;
> +
> +               udelay(1);
> +       } while (--tx_retry_num);
> +
> +       return -EBUSY;
> +}

iopoll.h
readx_poll_timeout().

...

> +/*
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */

One line.

...

> +#include "prestera.h"

I don't see users of the above header here. You may use declarations instead.

> +int prestera_rxtx_switch_init(struct prestera_switch *sw);
> +void prestera_rxtx_switch_fini(struct prestera_switch *sw);
> +
> +int prestera_rxtx_port_init(struct prestera_port *port);
> +
> +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);

-- 
With Best Regards,
Andy Shevchenko
