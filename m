Return-Path: <netdev+bounces-2510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A757024B7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828A91C20A8D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862421C13;
	Mon, 15 May 2023 06:31:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9AF8467
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:31:20 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD2EFC;
	Sun, 14 May 2023 23:31:15 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-643990c5319so8860806b3a.2;
        Sun, 14 May 2023 23:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684132275; x=1686724275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tyZUt6zOtSNbY2g2wuSZKryg6RY2N/xNxenBnNqd3Kk=;
        b=Cr8js0XHfrvoEYdnQnwY4/OoqDMeqktqWZ4dlNy5/asSE+Xvb8VQ6zseIk/jAZVTgJ
         XPGi75Vkqzr7Jk0ciwZQUrmBrrxOZrmZUx2M4z1NsE9tuGaFuGMqCjZsNWktAZicyA62
         S41+yJn/VebEBk+kzOe6lqPKHhHQVyMHaSXlpqHnfxzcvgWezBZwzX3fVUvIEQ5uQwpe
         dhq4AVjZJ2/jWnui24SzvWCk+xaAufXZdMPptYFI2t2+TrJEJEE8q1GOkZBBaF6he2qA
         gmpk3MsWkzufqqQMu7mH2jef0G6h8M4BdRM93TU49EMT84Qjvv8p2H0NeJP/waN123tK
         v3TQ==
X-Gm-Message-State: AC+VfDyHf4jiu+vzfHU7GTp9E3EmMKj4fZokPyncETsgn5eI3A0Zmb5c
	tg+SbBoW8uIwov/CmILxLs1QrZxwZhWzjXmhJy4=
X-Google-Smtp-Source: ACHHUZ7N3TK9szpsc5NldKGfENkwEsbawDXKxpLdiXqMZd/U0QU/7JJoWccx4zE9VGe7iUpahFQ2Sm37LDl/5U5ASzk=
X-Received: by 2002:a05:6a00:248d:b0:626:29ed:941f with SMTP id
 c13-20020a056a00248d00b0062629ed941fmr45133322pfv.5.1684132274297; Sun, 14
 May 2023 23:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com> <a83e29fd-09d0-64b4-ce56-c7f7a5e44f66@opensynergy.com>
In-Reply-To: <a83e29fd-09d0-64b4-ce56-c7f7a5e44f66@opensynergy.com>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Mon, 15 May 2023 15:31:03 +0900
Message-ID: <CAMZ6RqJxOh1zY0UauK6bK0d2ToU7M2q_TWyUEb4Bvai3r+AEYA@mail.gmail.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
To: Harald Mommer <harald.mommer@opensynergy.com>
Cc: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, virtio-dev@lists.oasis-open.org, 
	linux-can@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	Wolfgang Grandegger <wg@grandegger.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat. 13 May 2023 at 02:45, Harald Mommer
<harald.mommer@opensynergy.com> wrote:
> Hello Vincent,
>
> (Marc, you are now in the "To" as I have a direct question to you.)
>
> On 12.05.23 11:53, Vincent MAILHOL wrote:
> > Hi Mikhail,
> >
> > Thanks for your patch. Do you have any plans for CAN error reporting
> > aside from the bus off? (e.g. can error-active, can error-passive, bit
> > errors...)
> >
> > On Fri. 12 May 2023 at 00:18, Mikhail Golubev-Ciuchea
> > <Mikhail.Golubev-Ciuchea@opensynergy.com> wrote:
> >> From: Harald Mommer <harald.mommer@opensynergy.com>
> >>
> >> - CAN Control
> >>
> >>    - "ip link set up can0" starts the virtual CAN controller,
> >>    - "ip link set up can0" stops the virtual CAN controller
> >>
> >> - CAN RX
> >>
> >>    Receive CAN frames. CAN frames can be standard or extended, classic=
 or
> >>    CAN FD. Classic CAN RTR frames are supported.
> >>
> >> - CAN TX
> >>
> >>    Send CAN frames. CAN frames can be standard or extended, classic or
> >>    CAN FD. Classic CAN RTR frames are supported.
> >>
> >> - CAN BusOff indication
> >>
> >>    CAN BusOff is handled by a bit in the configuration space.
> >>
> >> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> >> Signed-off-by: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensy=
nergy.com>
> >> Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
> >> ---
> >>
> >> V3:
> >> * Incorporate patch "[PATCH] can: virtio-can: cleanups" from
> >>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?ur=
l=3Dhttps%3a%2f%2flore.kernel.org%2fall%2f20230424%2dfootwear%2ddaily%2d933=
9bd0ec428%2dmkl%40pengutronix.de%2f&umid=3D9bd91fe2-cd6c-4f97-823b-3f938eb0=
6afa&auth=3D53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-17d3c64a4691a4e8987f69=
3a9c0d91fa09fb4a4f
> >> * Add missing can_free_echo_skb()
> >> * Replace home-brewed ID allocator with the standard one from kernel
> >> * Simplify flow control
> >> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec=
-rfc-v3
> >>
> >> V2:
> >> * Remove the event indication queue and use the config space instead, =
to
> >>    indicate a bus off condition
> >> * Rework RX and TX messages having a length field and some more fields=
 for CAN
> >>    EXT
> >> * Fix CAN_EFF_MASK comparison
> >> * Remove MISRA style code (e.g. '! =3D 0u')
> >> * Remove priorities leftovers
> >> * Remove BUGONs
> >> * Based on virtio can spec RFCv3
> >> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec=
-rfc-v3
> >>
> >>   MAINTAINERS                     |    7 +
> >>   drivers/net/can/Kconfig         |   12 +
> >>   drivers/net/can/Makefile        |    3 +-
> >>   drivers/net/can/virtio_can.c    | 1000 +++++++++++++++++++++++++++++=
++
> >>   include/uapi/linux/virtio_can.h |   71 +++
> >>   5 files changed, 1092 insertions(+), 1 deletion(-)
> >>   create mode 100644 drivers/net/can/virtio_can.c
> >>   create mode 100644 include/uapi/linux/virtio_can.h
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 7e0b87d5aa2e..ca45950c8364 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -22246,6 +22246,13 @@ F:     drivers/vhost/scsi.c
> >>   F:     include/uapi/linux/virtio_blk.h
> >>   F:     include/uapi/linux/virtio_scsi.h
> >>
> >> +VIRTIO CAN DRIVER
> >> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
> >> +L:     linux-can@vger.kernel.org
> >> +S:     Maintained
> >> +F:     drivers/net/can/virtio_can.c
> >> +F:     include/uapi/linux/virtio_can.h
> >> +
> >>   VIRTIO CONSOLE DRIVER
> >>   M:     Amit Shah <amit@kernel.org>
> >>   L:     virtualization@lists.linux-foundation.org
> >> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> >> index 3ceccafd701b..ee47fdff2252 100644
> >> --- a/drivers/net/can/Kconfig
> >> +++ b/drivers/net/can/Kconfig
> >> @@ -210,6 +210,18 @@ config CAN_XILINXCAN
> >>            Xilinx CAN driver. This driver supports both soft AXI CAN I=
P and
> >>            Zynq CANPS IP.
> >>
> >> +config CAN_VIRTIO_CAN
> >> +       depends on VIRTIO
> >> +       tristate "Virtio CAN device support"
> >> +       default n
> >> +       help
> >> +         Say Y here if you want to support for Virtio CAN.
> > Broken grammar.
> >
> > Do either
> >
> >           Say Y here if you want to add support for Virtio CAN.
> Add "add".

ACK.

> > or:
> >
> >           Say Y here if you want to support Virtio CAN devices.
> >
> >> +
> >> +         To compile this driver as a module, choose M here: the
> >> +         module will be called virtio-can.
> >> +
> >> +         If unsure, say N.
> >> +
> >>   source "drivers/net/can/c_can/Kconfig"
> >>   source "drivers/net/can/cc770/Kconfig"
> >>   source "drivers/net/can/ctucanfd/Kconfig"
> >> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> >> index ff8f76295d13..19314adaff59 100644
> >> --- a/drivers/net/can/Makefile
> >> +++ b/drivers/net/can/Makefile
> >> @@ -17,8 +17,8 @@ obj-$(CONFIG_CAN_AT91)                +=3D at91_can.=
o
> >>   obj-$(CONFIG_CAN_BXCAN)                +=3D bxcan.o
> >>   obj-$(CONFIG_CAN_CAN327)       +=3D can327.o
> >>   obj-$(CONFIG_CAN_CC770)                +=3D cc770/
> >> -obj-$(CONFIG_CAN_C_CAN)                +=3D c_can/
> >>   obj-$(CONFIG_CAN_CTUCANFD)     +=3D ctucanfd/
> >> +obj-$(CONFIG_CAN_C_CAN)                +=3D c_can/
> > This reordering is unrelated to this patch goal. Please send it as a
> > separate patch.
>
> @Marc Kleine-Budde: We got this reordering change from you. How to
> proceed? We can split this in 2 commits, reordering and on top adding
> virtio CAN. No issue, a question of minutes and done. Fine. But here the
> word "patch" was used, not the word "commit". Sending a separate patch
> to somewhere? Maybe Mikhail does this fight to get this in (unlikely), I
> personally would prefer to run away. Or we don't reorder at all, wrong
> ordering remains and we will not make only you unhappy.

Resolved in this thread:

  https://lore.kernel.org/linux-can/20230514-senior-container-bf049eb882a9-=
mkl@pengutronix.de/

> >>   obj-$(CONFIG_CAN_FLEXCAN)      +=3D flexcan/
> >>   obj-$(CONFIG_CAN_GRCAN)                +=3D grcan.o
> >>   obj-$(CONFIG_CAN_IFI_CANFD)    +=3D ifi_canfd/
> >> @@ -30,6 +30,7 @@ obj-$(CONFIG_CAN_PEAK_PCIEFD) +=3D peak_canfd/
> >>   obj-$(CONFIG_CAN_SJA1000)      +=3D sja1000/
> >>   obj-$(CONFIG_CAN_SUN4I)                +=3D sun4i_can.o
> >>   obj-$(CONFIG_CAN_TI_HECC)      +=3D ti_hecc.o
> >> +obj-$(CONFIG_CAN_VIRTIO_CAN)   +=3D virtio_can.o
> >>   obj-$(CONFIG_CAN_XILINXCAN)    +=3D xilinx_can.o
> >>
> >>   subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) +=3D -DDEBUG
> >> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can=
.c
> >> new file mode 100644
> >> index 000000000000..ebc3394276d6
> >> --- /dev/null
> >> +++ b/drivers/net/can/virtio_can.c
> >> @@ -0,0 +1,1000 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/*
> >> + * CAN bus driver for the Virtio CAN controller
> >> + * Copyright (C) 2021-2023 OpenSynergy GmbH
> >> + */
> >> +
> >> +#include <linux/atomic.h>
> >> +#include <linux/idr.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/io.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/module.h>
> >> +#include <linux/mutex.h>
> >> +#include <linux/netdevice.h>
> >> +#include <linux/stddef.h>
> >> +#include <linux/can/dev.h>
> >> +#include <linux/virtio.h>
> >> +#include <linux/virtio_ring.h>
> >> +#include <linux/virtio_can.h>
> >> +
> >> +/* CAN device queues */
> >> +#define VIRTIO_CAN_QUEUE_TX 0 /* Driver side view! The device receive=
s here */
> >> +#define VIRTIO_CAN_QUEUE_RX 1 /* Driver side view! The device transmi=
ts here */
> >> +#define VIRTIO_CAN_QUEUE_CONTROL 2
> >> +#define VIRTIO_CAN_QUEUE_COUNT 3
> >> +
> >> +#define CAN_KNOWN_FLAGS \
> >> +       (VIRTIO_CAN_FLAGS_EXTENDED |\
> >> +        VIRTIO_CAN_FLAGS_FD |\
> >> +        VIRTIO_CAN_FLAGS_RTR)
> >> +
> >> +/* Max. number of in flight TX messages */
> >> +#define VIRTIO_CAN_ECHO_SKB_MAX 128
> >> +
> >> +struct virtio_can_tx {
> >> +       struct list_head list;
> >> +       unsigned int putidx;
> >> +       struct virtio_can_tx_out tx_out;
> >> +       struct virtio_can_tx_in tx_in;
> > I am still waiting for your answer on my previous comment here:
> >
> >    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=
=3Dhttps%3a%2f%2flore.kernel.org%2flinux%2dcan%2fCAMZ6Rq%2bRjOHaGx%2d7GLsj%=
2dPNAcHd%3dnGd%3dJERddqw4FWbNN3sAXA%40mail.gmail.com%2f&umid=3D9bd91fe2-cd6=
c-4f97-823b-3f938eb06afa&auth=3D53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-54=
198265295ed52b35ce48cd250b88611e8f8ccc
> Done now on the original mail which was found somewhere after some
> searching.

Answered here:

  https://lore.kernel.org/linux-can/CAMZ6RqKfdBio3cnH+FpeCwasoVNBZ3x55FiM+B=
pgrurKkT8aHg@mail.gmail.com/

> >> +};
> >> +
> >> +/* virtio_can private data structure */
> >> +struct virtio_can_priv {
> >> +       struct can_priv can;    /* must be the first member */
> >> +       /* NAPI for RX messages */
> >> +       struct napi_struct napi;
> >> +       /* NAPI for TX messages */
> >> +       struct napi_struct napi_tx;
> >> +       /* The network device we're associated with */
> >> +       struct net_device *dev;
> >> +       /* The virtio device we're associated with */
> >> +       struct virtio_device *vdev;
> >> +       /* The virtqueues */
> >> +       struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
> >> +       /* I/O callback function pointers for the virtqueues */
> >> +       vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
> >> +       /* Lock for TX operations */
> >> +       spinlock_t tx_lock;
> >> +       /* Control queue lock. Defensive programming, may be not neede=
d */
> >> +       struct mutex ctrl_lock;
> >> +       /* Wait for control queue processing without polling */
> >> +       struct completion ctrl_done;
> >> +       /* List of virtio CAN TX message */
> >> +       struct list_head tx_list;
> >> +       /* Array of receive queue messages */
> >> +       struct virtio_can_rx rpkt[128];
> >> +       /* Those control queue messages cannot live on the stack! */
> >> +       struct virtio_can_control_out cpkt_out;
> >> +       struct virtio_can_control_in cpkt_in;
> >> +       /* Data to get and maintain the putidx for local TX echo */
> >> +       struct ida tx_putidx_ida;
> >> +       /* In flight TX messages */
> >> +       atomic_t tx_inflight;
> >> +       /* BusOff pending. Reset after successful indication to upper =
layer */
> >> +       bool busoff_pending;
> >> +};
> >> +
> >> +/* Function copied from virtio_net.c */
> >> +static void virtqueue_napi_schedule(struct napi_struct *napi,
> >> +                                   struct virtqueue *vq)
> >> +{
> >> +       if (napi_schedule_prep(napi)) {
> >> +               virtqueue_disable_cb(vq);
> >> +               __napi_schedule(napi);
> >> +       }
> >> +}
> >> +
> >> +/* Function copied from virtio_net.c */
> >> +static void virtqueue_napi_complete(struct napi_struct *napi,
> >> +                                   struct virtqueue *vq, int processe=
d)
> >> +{
> >> +       int opaque;
> >> +
> >> +       opaque =3D virtqueue_enable_cb_prepare(vq);
> >> +       if (napi_complete_done(napi, processed)) {
> >> +               if (unlikely(virtqueue_poll(vq, opaque)))
> >> +                       virtqueue_napi_schedule(napi, vq);
> >> +       } else {
> >> +               virtqueue_disable_cb(vq);
> >> +       }
> >> +}
> >> +
> >> +static void virtio_can_free_candev(struct net_device *ndev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(ndev);
> >> +
> >> +       ida_destroy(&priv->tx_putidx_ida);
> >> +       free_candev(ndev);
> >> +}
> >> +
> >> +static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv)
> >> +{
> >> +       int tx_idx;
> >> +
> >> +       tx_idx =3D ida_alloc_range(&priv->tx_putidx_ida, 0,
> >> +                                priv->can.echo_skb_max - 1, GFP_KERNE=
L);
> >> +       if (tx_idx >=3D 0)
> >> +               atomic_add(1, &priv->tx_inflight);
> >> +
> >> +       return tx_idx;
> >> +}
> >> +
> >> +static void virtio_can_free_tx_idx(struct virtio_can_priv *priv,
> >> +                                  unsigned int idx)
> >> +{
> >> +       ida_free(&priv->tx_putidx_ida, idx);
> >> +       atomic_sub(1, &priv->tx_inflight);
> >> +}
> >> +
> >> +/* Create a scatter-gather list representing our input buffer and put
> >> + * it in the queue.
> >> + *
> >> + * Callers should take appropriate locks.
> >> + */
> >> +static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
> >> +                               unsigned int size)
> >> +{
> >> +       struct scatterlist sg[1];
> >> +       int ret;
> >> +
> >> +       sg_init_one(sg, buf, size);
> >> +
> >> +       ret =3D virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
> >> +       virtqueue_kick(vq);
> >> +       if (ret =3D=3D 0)
> >> +               ret =3D vq->num_free;
> >> +       return ret;
> >> +}
> >> +
> >> +/* Send a control message with message type either
> >> + *
> >> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
> >> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
> >> + *
> >> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requ=
irement
> >> + * for this Linux driver to have an asynchronous implementation of th=
e mode
> >> + * setting function so in order to keep things simple the function is
> >> + * implemented as synchronous function. Design pattern is
> >> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_=
command().
> >> + */
> >> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_t=
ype)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(ndev);
> >> +       struct device *dev =3D &priv->vdev->dev;
> >> +       struct virtqueue *vq =3D priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> >> +       struct scatterlist sg_out[1];
> >> +       struct scatterlist sg_in[1];
> >> +       struct scatterlist *sgs[2];
> >> +       int err;
> >> +       unsigned int len;
> >> +
> >> +       /* The function may be serialized by rtnl lock. Not sure.
> >> +        * Better safe than sorry.
> >> +        */
> >> +       mutex_lock(&priv->ctrl_lock);
> >> +
> >> +       priv->cpkt_out.msg_type =3D cpu_to_le16(msg_type);
> >> +       sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out=
));
> >> +       sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
> >> +       sgs[0] =3D sg_out;
> >> +       sgs[1] =3D sg_in;
> >> +
> >> +       err =3D virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
> >> +       if (err !=3D 0) {
> >            if (err) {
>
> Opened Eclipse, searched for "if (err !=3D 0)" in the kernel code. 290
> matches. For "if (ret !=3D 0)" I found now 1970 matches.

Read my comment again. I never mentioned err vs. ret.

 I am asking to replace "if (err !=3D 0)" by "if (err)". We are not
using MISRA and there is no concept of essential boolean type here.
You can pass an integer to an if ().

I do not use eclipse, but git can give a few relevant statistics:

  $ git grep "if (err !=3D 0)" | wc -l
  277
  $ git grep "if (err)" | wc -l
  34307

And while this is not the topic, "ret" is more popular than "err":

  $ git grep "if (ret !=3D 0)" | wc -l
  1956
  $ git grep "if (ret)" | wc -l
  67927

but both are well established usage so I do not really care which one
of "ret" or "err" you use.

> >> +               /* Not expected to happen */
> >> +               dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __f=
unc__);
> >> +       }
> >> +
> >> +       if (!virtqueue_kick(vq)) {
> >> +               /* Not expected to happen */
> >> +               dev_err(dev, "%s(): Kick failed\n", __func__);
> >> +       }
> >> +
> >> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq=
))
> >> +               wait_for_completion(&priv->ctrl_done);
> >> +
> >> +       mutex_unlock(&priv->ctrl_lock);
> >> +
> >> +       return priv->cpkt_in.result;
> >> +}
> >> +
> >> +static void virtio_can_start(struct net_device *ndev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(ndev);
> >> +       u8 result;
> >> +
> >> +       result =3D virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_=
MODE_START);
> >> +       if (result !=3D VIRTIO_CAN_RESULT_OK) {
> >> +               /* Not expected to happen */
> >> +               netdev_err(ndev, "CAN controller start failed\n");
> >> +       }
> >> +
> >> +       priv->busoff_pending =3D false;
> >> +       priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> >> +
> >> +       /* Switch carrier on if device was not connected to the bus */
> >> +       if (!netif_carrier_ok(ndev))
> >> +               netif_carrier_on(ndev);
> >> +}
> >> +
> >> +/* See also m_can.c/m_can_set_mode()
> >> + *
> >> + * It is interesting that not only the M-CAN implementation but also =
all other
> >> + * implementations I looked into only support CAN_MODE_START.
> >> + * That CAN_MODE_SLEEP is frequently not found to be supported anywhe=
re did not
> >> + * come not as surprise but that CAN_MODE_STOP is also never supporte=
d was one.
> >> + * The function is accessible via the method pointer do_set_mode in
> >> + * struct can_priv. As usual no documentation there.
> >> + * May not play any role as grepping through the code did not reveal =
any place
> >> + * from where the method is actually called.
> >> + */
> >> +static int virtio_can_set_mode(struct net_device *dev, enum can_mode =
mode)
> >> +{
> >> +       switch (mode) {
> >> +       case CAN_MODE_START:
> >> +               virtio_can_start(dev);
> >> +               netif_wake_queue(dev);
> >> +               break;
> >> +       default:
> >> +               return -EOPNOTSUPP;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +/* Called by issuing "ip link set up can0" */
> >> +static int virtio_can_open(struct net_device *dev)
> >> +{
> >> +       /* start the virtio_can controller */
> >> +       virtio_can_start(dev);
> >> +
> >> +       /* RX and TX napi were already enabled in virtio_can_probe() *=
/
> >> +       netif_start_queue(dev);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static void virtio_can_stop(struct net_device *ndev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(ndev);
> >> +       struct device *dev =3D &priv->vdev->dev;
> >> +       u8 result;
> >> +
> >> +       result =3D virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_=
MODE_STOP);
> >> +       if (result !=3D VIRTIO_CAN_RESULT_OK)
> >> +               dev_err(dev, "CAN controller stop failed\n");
> >> +
> >> +       priv->busoff_pending =3D false;
> >> +       priv->can.state =3D CAN_STATE_STOPPED;
> >> +
> >> +       /* Switch carrier off if device was connected to the bus */
> >> +       if (netif_carrier_ok(ndev))
> >> +               netif_carrier_off(ndev);
> >> +}
> >> +
> >> +static int virtio_can_close(struct net_device *dev)
> >> +{
> >> +       netif_stop_queue(dev);
> >> +       /* Keep RX napi active to allow dropping of pending RX CAN mes=
sages,
> >> +        * keep TX napi active to allow processing of cancelled CAN me=
ssages
> >> +        */
> >> +       virtio_can_stop(dev);
> >> +       close_candev(dev);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
> >> +                                        struct net_device *dev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(dev);
> >> +       struct canfd_frame *cf =3D (struct canfd_frame *)skb->data;
> >> +       struct virtio_can_tx *can_tx_msg;
> >> +       struct virtqueue *vq =3D priv->vqs[VIRTIO_CAN_QUEUE_TX];
> >> +       struct scatterlist sg_out[1];
> >> +       struct scatterlist sg_in[1];
> >> +       struct scatterlist *sgs[2];
> > Instead declaring two times an array of 1, can we do:
> >
> >          struct scatterlist sgs[2];

Ooopsy on my side. sgs is an array of pointers so the above is not equivale=
nt.

And doing this:

          struct scatterlist *sgs[2];

Would be problematic as the memory of the two elements would not be allocat=
ed.

> > and then use sgs[0] for out and sgs[1] for in?
> >
> > Or, if you really want to keep sg_out and sg_in, at least do:
> >
> >            struct scatterlist sg_out, sg_in;
> >            struct scatterlist *sgs[] =3D {&sg_out, &sg_in};
> >
> > N.B. The same comment also applies to the other places where you are
> > doing some sg[1] declarations.
>
> Makes thing worse. I'm not even sure whether this is a null change only
> or introduces a problem.
>
> virtio strictly separates devices readable and device writeable data.
> Therefore I want really to have here 2 separate definitions. The one is
> data to the device, the other is data from the device.

ACK. My second example does that:

            struct scatterlist sg_out, sg_in;
            struct scatterlist *sgs[] =3D {&sg_out, &sg_in};

> If this had any advantage, I could separate the data further. For
> example I could separate the payload from the preceding data. In this
> case I had  struct scatterlist sg_out[2]. As long as the payload is
> small the memcpy for the payload can be justified and [1] is good. In
> fact, those are still arrays even if by coincident now the number of
> elements is 1.

sg_out and sg_in are only passed to one function: sg_init_one(). And
as the name suggests, sg_init_one expects a single scatterlist, not an
array.

A look at:

  $ git grep sg_init_one

show me that doing as "sg_init_one(&foo[0], ...)" is not a popular
solution. The majority does sg_init_one(&foo, ...).

I do get that sgs is an array of arrays. I am just not comfortable
with sg_out and sg_in being declared as arrays because these never get
used as such.

> >> +       unsigned long flags;
> >> +       u32 can_flags;
> >> +       int err;
> >> +       int putidx;
> >> +       netdev_tx_t xmit_ret =3D NETDEV_TX_OK;
> >> +       const unsigned int hdr_size =3D offsetof(struct virtio_can_tx_=
out, sdu);
> >> +
> >> +       if (can_dev_dropped_skb(dev, skb))
> >> +               goto kick; /* No way to return NET_XMIT_DROP here */
> >> +
> >> +       /* No local check for CAN_RTR_FLAG or FD frame against negotia=
ted
> >> +        * features. The device will reject those anyway if not suppor=
ted.
> >> +        */
> >> +
> >> +       can_tx_msg =3D kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
> >> +       if (!can_tx_msg)
> >> +               goto kick; /* No way to return NET_XMIT_DROP here */
> >> +
> >> +       can_tx_msg->tx_out.msg_type =3D cpu_to_le16(VIRTIO_CAN_TX);
> >> +       can_flags =3D 0;
> >> +
> >> +       if (cf->can_id & CAN_EFF_FLAG) {
> >> +               can_flags |=3D VIRTIO_CAN_FLAGS_EXTENDED;
> >> +               can_tx_msg->tx_out.can_id =3D cpu_to_le32(cf->can_id &=
 CAN_EFF_MASK);
> >> +       } else {
> >> +               can_tx_msg->tx_out.can_id =3D cpu_to_le32(cf->can_id &=
 CAN_SFF_MASK);
> >> +       }
> >> +       if (cf->can_id & CAN_RTR_FLAG)
> >> +               can_flags |=3D VIRTIO_CAN_FLAGS_RTR;
> >> +       else
> >> +               memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
> >> +       if (can_is_canfd_skb(skb))
> >> +               can_flags |=3D VIRTIO_CAN_FLAGS_FD;
> >> +
> >> +       can_tx_msg->tx_out.flags =3D cpu_to_le32(can_flags);
> >> +       can_tx_msg->tx_out.length =3D cpu_to_le16(cf->len);
> >> +
> >> +       /* Prepare sending of virtio message */
> >> +       sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->le=
n);
> >> +       sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->=
tx_in));
> >> +       sgs[0] =3D sg_out;
> >> +       sgs[1] =3D sg_in;
> >> +
> >> +       putidx =3D virtio_can_alloc_tx_idx(priv);
> >> +
> >> +       if (unlikely(putidx < 0)) {
> >> +               netif_stop_queue(dev);
> >> +               kfree(can_tx_msg);
> >> +               netdev_warn(dev, "TX: Stop queue, no putidx available\=
n");
> > ida_alloc_range() can also return -ENOMEM. So the error is not
> > necessarily because of no putidx available. Maybe better to print the
> > error message (with %pe to show the mnemotechnic).
> %pe does not do that. It works for an error coded in a pointer. I have
> here an int.

Yes, and you can use the ERR_PTR() to turn your int into an error pointer.

Do:

  $ git grep -A1 "%pe"

if you need examples.

> >> +               xmit_ret =3D NETDEV_TX_BUSY;
> >> +               goto kick;
> >> +       }
> >> +
> >> +       can_tx_msg->putidx =3D (unsigned int)putidx;
> >> +
> >> +       /* Protect list operation */
> >> +       spin_lock_irqsave(&priv->tx_lock, flags);
> >> +       list_add_tail(&can_tx_msg->list, &priv->tx_list);
> >> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
> >> +
> >> +       /* Push loopback echo. Will be looped back on TX interrupt/TX =
NAPI */
> >> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
> >> +
> >> +       /* Protect queue and list operations */
> >> +       spin_lock_irqsave(&priv->tx_lock, flags);
> >> +       err =3D virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATO=
MIC);
> >> +       if (err !=3D 0) { /* unlikely when vq->num_free was considered=
 */
> >> +               list_del(&can_tx_msg->list);
> >> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> >> +               virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
> >> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
> >> +               netif_stop_queue(dev);
> >> +               kfree(can_tx_msg);
> >> +               if (err =3D=3D -ENOSPC)
> >> +                       netdev_dbg(dev, "TX: Stop queue, no space left=
\n");
> >> +               else
> >> +                       netdev_warn(dev, "TX: Stop queue, reason =3D %=
d\n", err);
> >> +               xmit_ret =3D NETDEV_TX_BUSY;
> >> +               goto kick;
> >> +       }
> >> +
> >> +       /* Normal queue stop when no transmission slots are left */
> >> +       if (atomic_read(&priv->tx_inflight) >=3D priv->can.echo_skb_ma=
x ||
> >> +           vq->num_free =3D=3D 0 || (vq->num_free < 2 &&
> > Replace the Magic number 2 with a #define.
>
> Normally I would do this because I also don't like magic constants. But
> here there is no good speaking name to ease understanding so this brings
> nothing. If someone does not understand the 2 a lengthy comment was
> needed to explain the 2.
>
> And this here (seen made by people being tortured by managers with
> tools) I won't do also to make a tool happy:
>
> #define TWO 2

Discussion resolved in:

  https://lore.kernel.org/linux-can/3950ac4f-3292-e6ca-7484-77f3a5639305@op=
ensynergy.com/

> >> +           !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC)=
)) {
> >> +               netif_stop_queue(dev);
> >> +               netdev_dbg(dev, "TX: Normal stop queue\n");
> >> +       }
> >> +
> >> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
> >> +
> >> +kick:
> >> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> >> +               if (!virtqueue_kick(vq))
> >> +                       netdev_err(dev, "%s(): Kick failed\n", __func_=
_);
> >> +       }
> >> +
> >> +       return xmit_ret;
> >> +}
> >> +
> >> +static const struct net_device_ops virtio_can_netdev_ops =3D {
> >> +       .ndo_open =3D virtio_can_open,
> >> +       .ndo_stop =3D virtio_can_close,
> >> +       .ndo_start_xmit =3D virtio_can_start_xmit,
> >> +       .ndo_change_mtu =3D can_change_mtu,
> >> +};
> >> +
> >> +static int register_virtio_can_dev(struct net_device *dev)
> >> +{
> >> +       dev->flags |=3D IFF_ECHO; /* we support local echo */
> >> +       dev->netdev_ops =3D &virtio_can_netdev_ops;
> >> +
> >> +       return register_candev(dev);
> >> +}
> >> +
> >> +/* Compare with m_can.c/m_can_echo_tx_event() */
> >> +static int virtio_can_read_tx_queue(struct virtqueue *vq)
> >> +{
> >> +       struct virtio_can_priv *can_priv =3D vq->vdev->priv;
> >> +       struct net_device *dev =3D can_priv->dev;
> >> +       struct net_device_stats *stats =3D &dev->stats;
> >> +       struct virtio_can_tx *can_tx_msg;
> >> +       unsigned long flags;
> >> +       unsigned int len;
> >> +       u8 result;
> >> +
> >> +       /* Protect list and virtio queue operations */
> >> +       spin_lock_irqsave(&can_priv->tx_lock, flags);
> >> +
> >> +       can_tx_msg =3D virtqueue_get_buf(vq, &len);
> >> +       if (!can_tx_msg) {
> >> +               spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> >> +               return 0; /* No more data */
> >> +       }
> >> +
> >> +       if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
> >> +               netdev_err(dev, "TX ACK: Device sent no result code\n"=
);
> >> +               result =3D VIRTIO_CAN_RESULT_NOT_OK; /* Keep things go=
ing */
> >> +       } else {
> >> +               result =3D can_tx_msg->tx_in.result;
> >> +       }
> >> +
> >> +       if (can_priv->can.state < CAN_STATE_BUS_OFF) {
> >> +               /* Here also frames with result !=3D VIRTIO_CAN_RESULT=
_OK are
> >> +                * echoed. Intentional to bring a waiting process in a=
n upper
> >> +                * layer to an end.
> >> +                * TODO: Any better means to indicate a problem here?
> >> +                */
> >> +               if (result !=3D VIRTIO_CAN_RESULT_OK)
> >> +                       netdev_warn(dev, "TX ACK: Result =3D %u\n", re=
sult);
> >> +
> >> +               stats->tx_bytes +=3D can_get_echo_skb(dev, can_tx_msg-=
>putidx,
> >> +                                                   NULL);
> >> +               stats->tx_packets++;
> >> +       } else {
> >> +               netdev_dbg(dev, "TX ACK: Controller inactive, drop ech=
o\n");
> >> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> >> +       }
> >> +
> >> +       list_del(&can_tx_msg->list);
> >> +       virtio_can_free_tx_idx(can_priv, can_tx_msg->putidx);
> >> +
> >> +       spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> >> +
> >> +       kfree(can_tx_msg);
> >> +
> >> +       /* Flow control */
> >> +       if (netif_queue_stopped(dev)) {
> >> +               netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
> >> +               netif_wake_queue(dev);
> >> +       }
> >> +
> >> +       return 1; /* Queue was not empty so there may be more data */
> >> +}
> >> +
> >> +/* Poll TX used queue for sent CAN messages
> >> + * See https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/que=
ry?url=3Dhttps%3a%2f%2fwiki.linuxfoundation.org%2fnetworking%2fnapi&umid=3D=
9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=3D53c7c7de28b92dfd96e93d9dd61a23e=
634d2fbec-75f50331f3967f0d9a7aa44c85d0281167f4b56c function
> >> + * int (*poll)(struct napi_struct *napi, int budget);
> >> + */
> >> +static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
> >> +{
> >> +       struct net_device *dev =3D napi->dev;
> >> +       struct virtio_can_priv *priv =3D netdev_priv(dev);
> >> +       struct virtqueue *vq =3D priv->vqs[VIRTIO_CAN_QUEUE_TX];
> >> +       int work_done =3D 0;
> >> +
> >> +       while (work_done < quota && virtio_can_read_tx_queue(vq) !=3D =
0)
> >> +               work_done++;
> >> +
> >> +       if (work_done < quota)
> >> +               virtqueue_napi_complete(napi, vq, work_done);
> >> +
> >> +       return work_done;
> >> +}
> >> +
> >> +static void virtio_can_tx_intr(struct virtqueue *vq)
> >> +{
> >> +       struct virtio_can_priv *can_priv =3D vq->vdev->priv;
> >> +
> >> +       virtqueue_disable_cb(vq);
> >> +       napi_schedule(&can_priv->napi_tx);
> >> +}
> >> +
> >> +/* This function is the NAPI RX poll function and NAPI guarantees tha=
t this
> >> + * function is not invoked simultaneously on multiple processors.
> >> + * Read a RX message from the used queue and sends it to the upper la=
yer.
> >> + * (See also m_can.c / m_can_read_fifo()).
> >> + */
> >> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
> >> +{
> >> +       struct virtio_can_priv *priv =3D vq->vdev->priv;
> >> +       struct net_device *dev =3D priv->dev;
> >> +       struct net_device_stats *stats =3D &dev->stats;
> >> +       struct virtio_can_rx *can_rx;
> >> +       struct canfd_frame *cf;
> >> +       struct sk_buff *skb;
> >> +       unsigned int transport_len;
> >> +       unsigned int len;
> >> +       const unsigned int header_size =3D offsetof(struct virtio_can_=
rx, sdu);
> >> +       u16 msg_type;
> >> +       u32 can_flags;
> >> +       u32 can_id;
> >> +
> >> +       can_rx =3D virtqueue_get_buf(vq, &transport_len);
> >> +       if (!can_rx)
> >> +               return 0; /* No more data */
> >> +
> >> +       if (transport_len < header_size) {
> >> +               netdev_warn(dev, "RX: Message too small\n");
> >> +               goto putback;
> >> +       }
> >> +
> >> +       if (priv->can.state >=3D CAN_STATE_ERROR_PASSIVE) {
> >> +               netdev_dbg(dev, "%s(): Controller not active\n", __fun=
c__);
> >> +               goto putback;
> >> +       }
> >> +
> >> +       msg_type =3D le16_to_cpu(can_rx->msg_type);
> >> +       if (msg_type !=3D VIRTIO_CAN_RX) {
> >> +               netdev_warn(dev, "RX: Got unknown msg_type %04x\n", ms=
g_type);
> >> +               goto putback;
> >> +       }
> >> +
> >> +       len =3D le16_to_cpu(can_rx->length);
> >> +       can_flags =3D le32_to_cpu(can_rx->flags);
> >> +       can_id =3D le32_to_cpu(can_rx->can_id);
> >> +
> >> +       if (can_flags & ~CAN_KNOWN_FLAGS) {
> >> +               stats->rx_dropped++;
> >> +               netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%=
x\n",
> >> +                           can_id, can_flags);
> >> +               goto putback;
> >> +       }
> >> +
> >> +       if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
> >> +               can_id &=3D CAN_EFF_MASK;
> >> +               can_id |=3D CAN_EFF_FLAG;
> >> +       } else {
> >> +               can_id &=3D CAN_SFF_MASK;
> >> +       }
> >> +
> >> +       if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
> >> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRA=
MES)) {
> >> +                       stats->rx_dropped++;
> >> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not n=
egotiated\n",
> >> +                                   can_id);
> >> +                       goto putback;
> >> +               }
> >> +               if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> >> +                       stats->rx_dropped++;
> >> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with =
FD not possible\n",
> >> +                                   can_id);
> >> +                       goto putback;
> >> +               }
> >> +
> >> +               if (len > 0xF) {
> >> +                       stats->rx_dropped++;
> >> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with =
DLC > 0xF\n",
> >> +                                   can_id);
> >> +                       goto putback;
> >> +               }
> >> +
> >> +               if (len > 0x8)
> >> +                       len =3D 0x8;
> >> +
> >> +               can_id |=3D CAN_RTR_FLAG;
> >> +       }
> >> +
> >> +       if (transport_len < header_size + len) {
> >> +               netdev_warn(dev, "RX: Message too small for payload\n"=
);
> >> +               goto putback;
> >> +       }
> >> +
> >> +       if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> >> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)=
) {
> >> +                       stats->rx_dropped++;
> >> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: FD not ne=
gotiated\n",
> >> +                                   can_id);
> >> +                       goto putback;
> >> +               }
> >> +
> >> +               if (len > CANFD_MAX_DLEN)
> >> +                       len =3D CANFD_MAX_DLEN;
> >> +
> >> +               skb =3D alloc_canfd_skb(priv->dev, &cf);
> >> +       } else {
> >> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLA=
SSIC)) {
> >> +                       stats->rx_dropped++;
> >> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: classic n=
ot negotiated\n",
> >> +                                   can_id);
> >> +                       goto putback;
> >> +               }
> >> +
> >> +               if (len > CAN_MAX_DLEN)
> >> +                       len =3D CAN_MAX_DLEN;
> >> +
> >> +               skb =3D alloc_can_skb(priv->dev, (struct can_frame **)=
&cf);
> >> +       }
> >> +       if (!skb) {
> >> +               stats->rx_dropped++;
> >> +               netdev_warn(dev, "RX: No skb available\n");
> >> +               goto putback;
> >> +       }
> >> +
> >> +       cf->can_id =3D can_id;
> >> +       cf->len =3D len;
> >> +       if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
> >> +               /* RTR frames have a DLC but no payload */
> >> +               memcpy(cf->data, can_rx->sdu, len);
> >> +       }
> >> +
> >> +       if (netif_receive_skb(skb) =3D=3D NET_RX_SUCCESS) {
> >> +               stats->rx_packets++;
> >> +               if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
> >> +                       stats->rx_bytes +=3D cf->len;
> >> +       }
> >> +
> >> +putback:
> >> +       /* Put processed RX buffer back into avail queue */
> >> +       virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx))=
;
> >> +
> >> +       return 1; /* Queue was not empty so there may be more data */
> >> +}
> >> +
> >> +/* See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_=
change() */
> >> +static int virtio_can_handle_busoff(struct net_device *dev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D netdev_priv(dev);
> >> +       struct can_frame *cf;
> >> +       struct sk_buff *skb;
> >> +
> >> +       if (!priv->busoff_pending)
> >> +               return 0;
> >> +
> >> +       if (priv->can.state < CAN_STATE_BUS_OFF) {
> >> +               netdev_dbg(dev, "entered error bus off state\n");
> >> +
> >> +               /* bus-off state */
> >> +               priv->can.state =3D CAN_STATE_BUS_OFF;
> >> +               priv->can.can_stats.bus_off++;
> >> +               can_bus_off(dev);
> >> +       }
> >> +
> >> +       /* propagate the error condition to the CAN stack */
> >> +       skb =3D alloc_can_err_skb(dev, &cf);
> >> +       if (unlikely(!skb))
> >> +               return 0;
> >> +
> >> +       /* bus-off state */
> >> +       cf->can_id |=3D CAN_ERR_BUSOFF;
> >> +
> >> +       /* Ensure that the BusOff indication does not get lost */
> >> +       if (netif_receive_skb(skb) =3D=3D NET_RX_SUCCESS)
> >> +               priv->busoff_pending =3D false;
> >> +
> >> +       return 1;
> >> +}
> >> +
> >> +/* Poll RX used queue for received CAN messages
> >> + * See https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/que=
ry?url=3Dhttps%3a%2f%2fwiki.linuxfoundation.org%2fnetworking%2fnapi&umid=3D=
9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=3D53c7c7de28b92dfd96e93d9dd61a23e=
634d2fbec-75f50331f3967f0d9a7aa44c85d0281167f4b56c function
> >> + * int (*poll)(struct napi_struct *napi, int budget);
> >> + * Important: "The networking subsystem promises that poll() will not=
 be
> >> + * invoked simultaneously (for the same napi_struct) on multiple proc=
essors"
> >> + */
> >> +static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
> >> +{
> >> +       struct net_device *dev =3D napi->dev;
> >> +       struct virtio_can_priv *priv =3D netdev_priv(dev);
> >> +       struct virtqueue *vq =3D priv->vqs[VIRTIO_CAN_QUEUE_RX];
> >> +       int work_done =3D 0;
> >> +
> >> +       work_done +=3D virtio_can_handle_busoff(dev);
> >> +
> >> +       while (work_done < quota && virtio_can_read_rx_queue(vq) !=3D =
0)
> >> +               work_done++;
> >> +
> >> +       if (work_done < quota)
> >> +               virtqueue_napi_complete(napi, vq, work_done);
> >> +
> >> +       return work_done;
> >> +}
> >> +
> >> +static void virtio_can_rx_intr(struct virtqueue *vq)
> >> +{
> >> +       struct virtio_can_priv *can_priv =3D vq->vdev->priv;
> >> +
> >> +       virtqueue_disable_cb(vq);
> >> +       napi_schedule(&can_priv->napi);
> >> +}
> >> +
> >> +static void virtio_can_control_intr(struct virtqueue *vq)
> >> +{
> >> +       struct virtio_can_priv *can_priv =3D vq->vdev->priv;
> >> +
> >> +       complete(&can_priv->ctrl_done);
> >> +}
> >> +
> >> +static void virtio_can_config_changed(struct virtio_device *vdev)
> >> +{
> >> +       struct virtio_can_priv *can_priv =3D vdev->priv;
> >> +       u16 status;
> >> +
> >> +       status =3D virtio_cread16(vdev, offsetof(struct virtio_can_con=
fig,
> >> +                                              status));
> >> +
> >> +       if (!(status & VIRTIO_CAN_S_CTRL_BUSOFF))
> >> +               return;
> >> +
> >> +       if (!can_priv->busoff_pending &&
> >> +           can_priv->can.state < CAN_STATE_BUS_OFF) {
> >> +               can_priv->busoff_pending =3D true;
> >> +               napi_schedule(&can_priv->napi);
> >> +       }
> >> +}
> >> +
> >> +static void virtio_can_populate_vqs(struct virtio_device *vdev)
> >> +
> >> +{
> >> +       struct virtio_can_priv *priv =3D vdev->priv;
> >> +       struct virtqueue *vq;
> >> +       unsigned int idx;
> >> +       int ret;
> >> +
> >> +       /* Fill RX queue */
> >> +       vq =3D priv->vqs[VIRTIO_CAN_QUEUE_RX];
> >> +       for (idx =3D 0; idx < ARRAY_SIZE(priv->rpkt); idx++) {
> >> +               ret =3D virtio_can_add_inbuf(vq, &priv->rpkt[idx],
> >> +                                          sizeof(struct virtio_can_rx=
));
> >> +               if (ret < 0) {
> >> +                       dev_dbg(&vdev->dev, "rpkt fill: ret=3D%d, idx=
=3D%u\n",
> >> +                               ret, idx);
> >> +                       break;
> >> +               }
> >> +       }
> >> +       dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
> >> +}
> >> +
> >> +static int virtio_can_find_vqs(struct virtio_can_priv *priv)
> >> +{
> >> +       /* The order of RX and TX is exactly the opposite as in consol=
e and
> >> +        * network. Does not play any role but is a bad trap.
> >> +        */
> >> +       static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] =3D=
 {
> >> +               "can-tx",
> >> +               "can-rx",
> >> +               "can-state-ctrl"
> >> +       };
> >> +
> >> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] =3D virtio_can_tx_intr=
;
> >> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] =3D virtio_can_rx_intr=
;
> >> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] =3D virtio_can_co=
ntrol_intr;
> >> +
> >> +       /* Find the queues. */
> >> +       return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, pri=
v->vqs,
> >> +                              priv->io_callbacks, io_names, NULL);
> >> +}
> >> +
> >> +/* Function must not be called before virtio_can_find_vqs() has been =
run */
> >> +static void virtio_can_del_vq(struct virtio_device *vdev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D vdev->priv;
> >> +       struct list_head *cursor, *next;
> >> +       struct virtqueue *vq;
> >> +
> >> +       /* Reset the device */
> >> +       if (vdev->config->reset)
> >> +               vdev->config->reset(vdev);
> >> +
> >> +       /* From here we have dead silence from the device side so no l=
ocks
> >> +        * are needed to protect against device side events.
> >> +        */
> >> +
> >> +       vq =3D priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> >> +       while (virtqueue_detach_unused_buf(vq))
> >> +               ; /* Do nothing, content allocated statically */
> >> +
> >> +       vq =3D priv->vqs[VIRTIO_CAN_QUEUE_RX];
> >> +       while (virtqueue_detach_unused_buf(vq))
> >> +               ; /* Do nothing, content allocated statically */
> >> +
> >> +       vq =3D priv->vqs[VIRTIO_CAN_QUEUE_TX];
> >> +       while (virtqueue_detach_unused_buf(vq))
> >> +               ; /* Do nothing, content to be de-allocated separately=
 */
> >> +
> >> +       /* Is keeping track of allocated elements by an own linked lis=
t
> >> +        * really necessary or may this be optimized using only
> >> +        * virtqueue_detach_unused_buf()?
> >> +        */
> >> +       list_for_each_safe(cursor, next, &priv->tx_list) {
> >> +               struct virtio_can_tx *can_tx;
> >> +
> >> +               can_tx =3D list_entry(cursor, struct virtio_can_tx, li=
st);
> >> +               list_del(cursor);
> >> +               kfree(can_tx);
> >> +       }
> >> +
> >> +       if (vdev->config->del_vqs)
> >> +               vdev->config->del_vqs(vdev);
> >> +}
> >> +
> >> +/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remo=
ve() */
> >> +static void virtio_can_remove(struct virtio_device *vdev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D vdev->priv;
> >> +       struct net_device *dev =3D priv->dev;
> >> +
> >> +       unregister_candev(dev);
> >> +
> >> +       /* No calls of netif_napi_del() needed as free_candev() will d=
o this */
> >> +
> >> +       virtio_can_del_vq(vdev);
> >> +
> >> +       virtio_can_free_candev(dev);
> >> +}
> >> +
> >> +static int virtio_can_validate(struct virtio_device *vdev)
> >> +{
> >> +       /* CAN needs always access to the config space.
> >> +        * Check that the driver can access the config space
> >> +        */
> >> +       if (!vdev->config->get) {
> >> +               dev_err(&vdev->dev, "%s failure: config access disable=
d\n",
> >> +                       __func__);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> >> +               dev_err(&vdev->dev,
> >> +                       "device does not comply with spec version 1.x\=
n");
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int virtio_can_probe(struct virtio_device *vdev)
> >> +{
> >> +       struct net_device *dev;
> >> +       struct virtio_can_priv *priv;
> >> +       int err;
> >> +
> >> +       dev =3D alloc_candev(sizeof(struct virtio_can_priv),
> >> +                          VIRTIO_CAN_ECHO_SKB_MAX);
> >> +       if (!dev)
> >> +               return -ENOMEM;
> >> +
> >> +       priv =3D netdev_priv(dev);
> >> +
> >> +       ida_init(&priv->tx_putidx_ida);
> >> +
> >> +       netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
> >> +       netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
> >> +
> >> +       SET_NETDEV_DEV(dev, &vdev->dev);
> >> +
> >> +       priv->dev =3D dev;
> >> +       priv->vdev =3D vdev;
> >> +       vdev->priv =3D priv;
> >> +
> >> +       priv->can.do_set_mode =3D virtio_can_set_mode;
> >> +       /* Set Virtio CAN supported operations */
> >> +       priv->can.ctrlmode_supported =3D CAN_CTRLMODE_BERR_REPORTING;
> >> +       if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> >> +               err =3D can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
> >> +               if (err !=3D 0)
> >> +                       goto on_failure;
> >> +       }
> >> +
> >> +       /* Initialize virtqueues */
> >> +       err =3D virtio_can_find_vqs(priv);
> >> +       if (err !=3D 0)
> >> +               goto on_failure;
> >> +
> >> +       INIT_LIST_HEAD(&priv->tx_list);
> >> +
> >> +       spin_lock_init(&priv->tx_lock);
> >> +       mutex_init(&priv->ctrl_lock);
> >> +
> >> +       init_completion(&priv->ctrl_done);
> >> +
> >> +       virtio_can_populate_vqs(vdev);
> >> +
> >> +       register_virtio_can_dev(dev);
> >> +
> >> +       napi_enable(&priv->napi);
> >> +       napi_enable(&priv->napi_tx);
> >> +
> >> +       /* Request device going live */
> >> +       virtio_device_ready(vdev); /* Optionally done by virtio_dev_pr=
obe() */
> >> +
> >> +       return 0;
> >> +
> >> +on_failure:
> >> +       virtio_can_free_candev(dev);
> >> +       return err;
> >> +}
> >> +
> >> +/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze(=
) and
> >> + * virtio_card.c/virtsnd_freeze()
> >> + */
> >> +static int __maybe_unused virtio_can_freeze(struct virtio_device *vde=
v)
> >> +{
> >> +       struct virtio_can_priv *priv =3D vdev->priv;
> >> +       struct net_device *ndev =3D priv->dev;
> >> +
> >> +       napi_disable(&priv->napi);
> >> +       napi_disable(&priv->napi_tx);
> >> +
> >> +       if (netif_running(ndev)) {
> >> +               netif_stop_queue(ndev);
> >> +               netif_device_detach(ndev);
> >> +               virtio_can_stop(ndev);
> >> +       }
> >> +
> >> +       priv->can.state =3D CAN_STATE_SLEEPING;
> >> +
> >> +       virtio_can_del_vq(vdev);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore(=
) and
> >> + * virtio_card.c/virtsnd_restore()
> >> + */
> >> +static int __maybe_unused virtio_can_restore(struct virtio_device *vd=
ev)
> >> +{
> >> +       struct virtio_can_priv *priv =3D vdev->priv;
> >> +       struct net_device *ndev =3D priv->dev;
> >> +       int err;
> >> +
> >> +       err =3D virtio_can_find_vqs(priv);
> >> +       if (err !=3D 0)
> >> +               return err;
> >> +       virtio_can_populate_vqs(vdev);
> >> +
> >> +       priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> >> +
> >> +       if (netif_running(ndev)) {
> >> +               virtio_can_start(ndev);
> >> +               netif_device_attach(ndev);
> >> +               netif_start_queue(ndev);
> >> +       }
> >> +
> >> +       napi_enable(&priv->napi);
> >> +       napi_enable(&priv->napi_tx);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static struct virtio_device_id virtio_can_id_table[] =3D {
> >> +       { VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
> >> +       { 0 },
> >> +};
> >> +
> >> +static unsigned int features[] =3D {
> >> +       VIRTIO_CAN_F_CAN_CLASSIC,
> >> +       VIRTIO_CAN_F_CAN_FD,
> >> +       VIRTIO_CAN_F_LATE_TX_ACK,
> >> +       VIRTIO_CAN_F_RTR_FRAMES,
> >> +};
> >> +
> >> +static struct virtio_driver virtio_can_driver =3D {
> >> +       .feature_table =3D features,
> >> +       .feature_table_size =3D ARRAY_SIZE(features),
> >> +       .driver.name =3D KBUILD_MODNAME,
> >> +       .driver.owner =3D THIS_MODULE,
> >> +       .id_table =3D virtio_can_id_table,
> >> +       .validate =3D virtio_can_validate,
> >> +       .probe =3D virtio_can_probe,
> >> +       .remove =3D virtio_can_remove,
> >> +       .config_changed =3D virtio_can_config_changed,
> >> +#ifdef CONFIG_PM_SLEEP
> >> +       .freeze =3D virtio_can_freeze,
> >> +       .restore =3D virtio_can_restore,
> >> +#endif
> >> +};
> >> +
> >> +module_virtio_driver(virtio_can_driver);
> >> +MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
> >> +
> >> +MODULE_AUTHOR("OpenSynergy GmbH");
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
> >> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virt=
io_can.h
> >> new file mode 100644
> >> index 000000000000..f59a2ca6ebd1
> >> --- /dev/null
> >> +++ b/include/uapi/linux/virtio_can.h
> >> @@ -0,0 +1,71 @@
> >> +/* SPDX-License-Identifier: BSD-3-Clause */
> >> +/*
> >> + * Copyright (C) 2021-2023 OpenSynergy GmbH
> >> + */
> >> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
> >> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
> >> +
> >> +#include <linux/types.h>
> >> +#include <linux/virtio_types.h>
> >> +#include <linux/virtio_ids.h>
> >> +#include <linux/virtio_config.h>
> >> +
> >> +/* Feature bit numbers */
> >> +#define VIRTIO_CAN_F_CAN_CLASSIC        0
> >> +#define VIRTIO_CAN_F_CAN_FD             1
> >> +#define VIRTIO_CAN_F_LATE_TX_ACK        2
> >> +#define VIRTIO_CAN_F_RTR_FRAMES         3
> > Why do we need both VIRTIO_CAN_F_RTR_FRAMES VIRTIO_CAN_FLAGS_RTR?
> >
> > Is it to manage devices not able to sent remote frames? If so, we may
> > also need to add a CAN_CTRLMODE_RTR in linux/can/netlink.h?
>
> VIRTIO_CAN_F_RTR_FRAMES is a feature flag. RTR frames may or may not be
> supported. AUTOSAR CAN drivers do not know anything about RTR frames.

Now that you say it, it rings a bell.

So indeed, we will probably need a new flag in can/netlink.h to report
to the userland whether a device is capable or not to manage remote
frames.

> So
> if someone wants to build a virtio CAN device on top of an AUTOSAR CAN
> driver with the additional requirement not to change the existing
> AUTOSAR CAN driver RTR frames cannot be supported and the feature flag
> won't be offered by the virtio device.
>
> VIRTIO_CAN_FLAGS_RTR is a bit to indicate a frame type in a CAN message.
> Used internally in an Linux SocketCAN interface.

ACK.

On a side note, did you have a look at:

  https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/net=
link.h#L95

?

It lists the different hardware capabilities which may or may not be
present at the hardware level. This list can be used as an input to
decide how to extend the feature bit list.

> >> +
> >> +/* CAN Result Types */
> >> +#define VIRTIO_CAN_RESULT_OK            0
> >> +#define VIRTIO_CAN_RESULT_NOT_OK        1
> > Silly question, but what is the rationale of not using the error code
> > from errno.h?
> Looked into the AUTOSAR_SWS_StandardTypes.pdf  Std_ReturnType:
>
> E_OK =3D 0
>
> E_NOT_OK =3D 1
>
> other are "Available for user specific errors" like CAN_BUSY.
>
> Linux is only one operating system. An important one but there are
> others. AUTOSAR people may ask you "What is errno.h?" (and also "What is
> malloc?").

Sorry, but I do not buy this argument. Do you really now AUTOSAR
developpers who do not know about malloc()?

> Our internal client is interested in a Virtio AUTOSAR CAN
> driver. So there were reasons to look first into AUTOSAR.

Is it AUTOSAR Classic or AUTOSAR Adaptive?

AUTOSAR Adaptive is POSIX (to some extends):

  [SWS_OSI_01001] POSIX PSE51 Interface: [The OSI shall provide OS
  functionality with POSIX PSE51 interface, according to the
  1003.13-2003 specification.]

Ref: AUTOSAR AP R22-11 - Specification of Operating System Interface
https://www.autosar.org/fileadmin/standards/R22-11/AP/AUTOSAR_SWS_Operating=
SystemInterface.pdf

> There is also a CAN_BUSY for the AUTOSAR Can_Write() to be returned but
> this is not needed at this interface as a virtio AUTOSAR CAN driver was
> busy when there are no sufficient messages available in the virtqueue,
> so for this condition we need no defined error code to be used in a
> virtio message.
>
> Virtio block defines VIRTIO_BLK_S_OK 0, VIRTIO_BLK_S_IOERR 1,
> VIRTIO_BLK_S_UNSUPP 2.
>
> > I do see that some other virtio devices do the same:
> >
> >    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=
=3Dhttps%3a%2f%2felixir.bootlin.com%2flinux%2fv4.6%2fsource%2finclude%2fuap=
i%2flinux%2fvirtio%5fnet.h%23L140&umid=3D9bd91fe2-cd6c-4f97-823b-3f938eb06a=
fa&auth=3D53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-92b14ac1d1eb12690206c7a0=
e34d2f211c4c3e06
> >
> > But I am genuinely curious to understand why virtio do not use more
> > standard error codes.
>
> I cannot speak for virtio. errno.h is ANSI C and POSIX but virtio does
> not only address those environments. It is a more general specification.

That's my point. ISO C is so predominant that those error codes are
available nearly everywhere. And this being just some #define, it can
easily be integrated to the few system which do not have this header.

If there is a requirement to make virtio header self contained, then I
would understand why POSIX error code can not be used. But as I said,
I am genously curious to understand the reason behind this choice.

> For the virtio RPMB device the result codes in the virtio specification
> come for example directly from an JEDEC specification for eMMC. Which
> has some connection to a JEDEC UFS specification, same result codes
> there. Makes a lot of sense to use those result codes in this context.
>
> As virtio is more general, I have for this also my doubts whether it
> really was a good idea to take over the CAN RX and CAN TX message
> definitions 1:1 from Linux (if this is possible). Someone proposed but
> I've my doubts.

Yes, I did ask here:

  https://lore.kernel.org/linux-can/CAMZ6RqLALOYFWQJ4C4HTaRw7y-waUbqOX0WzrW=
VNiQG51QexHw@mail.gmail.com/

I am still waiting for your answer.

I do understand that Linux is not the only OS. However, it is the only
one with a complehensive set of open source CAN dirvers. Reusing the
Linux structures would allow to reuse bigger chunks of code,
decreasing the amount of effort needed implement drivers in the virtio
host.

That said, the POSIX error code and reusing the Linux CAN structures
are two different topics.

> >> +/* CAN flags to determine type of CAN Id */
> >> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
> >> +#define VIRTIO_CAN_FLAGS_FD             0x4000
> >> +#define VIRTIO_CAN_FLAGS_RTR            0x2000
> >> +
> >> +struct virtio_can_config {
> >> +#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
> >> +       /* CAN controller status */
> >> +       __le16 status;
> >> +};
> >> +
> >> +/* TX queue message types */
> >> +struct virtio_can_tx_out {
> >> +#define VIRTIO_CAN_TX                   0x0001
> >> +       __le16 msg_type;
> >> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bi=
ts */
> >> +       __le32 reserved; /* May be needed in part for CAN XL priority =
*/
> >> +       __le32 flags;
> >> +       __le32 can_id;
> >> +       __u8 sdu[64];
> >> +};
> >> +
> >> +struct virtio_can_tx_in {
> >> +       __u8 result;
> >> +};
> >> +
> >> +/* RX queue message types */
> >> +struct virtio_can_rx {
> >> +#define VIRTIO_CAN_RX                   0x0101
> >> +       __le16 msg_type;
> >> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bi=
ts */
> >> +       __le32 reserved; /* May be needed in part for CAN XL priority =
*/
> > Can we use this field to report the classical CAN DLC greater than 8?
> > If also needed by CAN XL, the field can be turned into a union.
>
> Classical CAN cannot have a DLC > 8. CAN FD has a length up to 64 bytes.

No, The DLC is coded on four bits and ranges from 0 to 15 for both
Classical CAN and CAN-FD.

Please refer to:

  commit ea7800565a12 ("can: add optional DLC element to Classical CAN
frame structure")
  Link: https://git.kernel.org/torvalds/c/ea7800565a12

For more details, please refor to section 8.4.2.4 "DLC field" of ISO
11898-1:2015.

I do believe that AUTOSAR do not allow Classical CAN frames with a DLC
greater than 8, but the virtio implementation should support the ISO
definitions.

> Length is is already __le16 to be able to put the 12 bits of 2048 for
> CAN XL into it.
>
> But for CAN XL we need anyway a more critical look from CAN XL experts
> on the list. Here in the house there is already only fewer experience
> with CAN FD in comparison with classic CAN but none at all with CAN XL.
> Too new. If something is done in a stupid way we can define in the
> future completely new messages as we have the msg_type. But if no
> mistake is made now we can avoid this and enhancing things will be more
> simple later. The RX and TX messages are really critical. Some bugs in
> the software can be fixed easily. But if we define here something not
> future proof this can only be addressed later in the spec with some more
> effort.

ACK.

> >> +       __le32 flags;
> >> +       __le32 can_id;
> >> +       __u8 sdu[64];
> >> +};
> >> +
> >> +/* Control queue message types */
> >> +struct virtio_can_control_out {
> >> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
> >> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
> >> +       __le16 msg_type;
> >> +};
> >> +
> >> +struct virtio_can_control_in {
> >> +       __u8 result;
> >> +};
> >> +
> >> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */

Yours sincerely,
Vincent Mailhol

