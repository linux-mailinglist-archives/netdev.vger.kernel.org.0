Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0A03271DC
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhB1KS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:18:59 -0500
Received: from smtp-16-i2.italiaonline.it ([213.209.12.16]:44003 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230018AbhB1KS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:18:59 -0500
Received: from oxapps-31-138.iol.local ([10.101.8.184])
        by smtp-16.iol.local with ESMTPA
        id GJ9RlDgFpf2ANGJ9RlYEZu; Sun, 28 Feb 2021 11:18:14 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614507494; bh=CG+8XrnNPC0XerUz61vkmJaTgmJ3tjIiwASaP3bg/30=;
        h=From;
        b=nCiTog23J1Nq9fq38aKsDjqEcnmFVycVruRe8E8StmExizQuNjOd18+hQO5ytsbUz
         HTFy8JOSGT1q3EPS5PF/ik8Oa0/NcwY4oZ2eRrzpmfZQZFzxJ9KkLF+u6qLThJcgTw
         Ee8BNIIRJ353HHxEEkeR799boqmusyTvxYzMwyVNR8ZTk1ho0GwEJLHKzT9050zMUr
         fRYVYSlzMnlYGJkRObK4m2P7/19beUxTCsmvc5jl5DGQF3Ja8FCjMdjS1YA7bR3RQb
         e1qDMTKylQFckKLtQ1/KJhHaeTi7oywvukvUtS9BdB19SMzl4oGwXhbddRmiv2iZgZ
         wR7/obHOhz7rQ==
X-CNFS-Analysis: v=2.4 cv=Adt0o1bG c=1 sm=1 tr=0 ts=603b6de6 cx=a_exe
 a=SkAuTGSu9wVn7tcq8ZjrZA==:117 a=UPWQtH3J-JgA:10 a=IkcTkHD0fZMA:10
 a=_gZzKa99_6AA:10 a=QyXUC8HyAAAA:8 a=bGNZPXyTAAAA:8 a=aK8-GT_Qw9wCxsekbmIA:9
 a=shyetUKbBDji3ZZd:21 a=oZA-dVK3vQSvSF3i:21 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Sun, 28 Feb 2021 11:18:13 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1564374858.544328.1614507493409@mail1.libero.it>
In-Reply-To: <20210226083315.cutpxc4iety4qedp@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-6-dariobin@libero.it>
 <20210226083315.cutpxc4iety4qedp@pengutronix.de>
Subject: Re: [PATCH v2 5/6] can: c_can: prepare to up the message objects
 number
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 87.20.116.197
X-Originating-Client: open-xchange-appsuite
x-libjamsun: UDqA7aWPH2Y+PYHcqreTSmdZ00zcUF42
x-libjamv: evyJ42fpdRw=
X-CMAE-Envelope: MS4xfMzy0Ub1w36FK6ZA2wAYiibIjEy9qE2pQRAQMS18wNueEhPmoxtgNYrWrF99QItY6Jrsb84STg44PRQMhm5gSa5I3h1rCMYjKsO83z0nXnPpRkL2BPLL
 DMBHrXCAj4tnLiOgb3mv1EAJ4laADWEWODHOx3/bq1vkkC65OLFDZtnprpst5WWeW6gEH+qCk2S65ZUU8mn4oKK9SLemgcrP+4iemwG5uNy70tIkdknWr8Ol
 QIV37fl6CdcvFbPMYCjhanOKgDF3xz8U/B3KxfQeUE3+W6UV6Ky+ysLcblsBY6IgTV/3qEi/c8OjiTZhIc2CiT14xnoBb8zxzyOzx+bdSNMY4Vnj+RQ4XV5Q
 6G0vUt8QrrqZR2v3gEE8lcT7Cc9rWZCak4YfYHy+tDbTIJmNAVSnsaz+/ttEx4Pr4spSAWbHjOkimnBWf8LuSQ4KNfd15kDLqh41gKc9PoGbV1eB7jRekqF2
 adRAoUsJ33Gko46prlci8XwFTqhpCb9pxmoE1tRWn/dQq3Fsux++AJ39AWCG+x3OiS5I2KLQutY54Kyf6noZUe6gxHxO7Xdel6S9k42TfhuMtkZ4rXdYRsct
 v2FQrS995W4ftFwrR2jdkMWejMgaRQXqR+NWZmWqGghZUQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 26/02/2021 09:33 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 25.02.2021 22:51:54, Dario Binacchi wrote:
> > As pointed by commit c0a9f4d396c9 ("can: c_can: Reduce register access")
> > the "driver casts the 16 message objects in stone, which is completely
> > braindead as contemporary hardware has up to 128 message objects".
> > 
> > The patch prepares the module to extend the number of message objects
> > beyond the 32 currently managed. This was achieved by transforming the
> > constants used to manage RX/TX messages into variables without changing
> > the driver policy.
> > 
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > ---
> > 
> > Changes in v2:
> > - Fix compiling error reported by kernel test robot.
> > - Add Reported-by tag.
> > - Pass larger size to alloc_candev() routine to avoid an additional
> >   memory allocation/deallocation.
> > 
> >  drivers/net/can/c_can/c_can.c          | 50 ++++++++++++++++----------
> >  drivers/net/can/c_can/c_can.h          | 23 ++++++------
> >  drivers/net/can/c_can/c_can_pci.c      |  2 +-
> >  drivers/net/can/c_can/c_can_platform.c |  2 +-
> >  4 files changed, 43 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> > index 7081cfaf62e2..df1ad6b3fd3b 100644
> > --- a/drivers/net/can/c_can/c_can.c
> > +++ b/drivers/net/can/c_can/c_can.c
> > @@ -173,9 +173,6 @@
> >  /* Wait for ~1 sec for INIT bit */
> >  #define INIT_WAIT_MS		1000
> >  
> > -/* napi related */
> > -#define C_CAN_NAPI_WEIGHT	C_CAN_MSG_OBJ_RX_NUM
> > -
> >  /* c_can lec values */
> >  enum c_can_lec_type {
> >  	LEC_NO_ERROR = 0,
> > @@ -325,7 +322,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
> >  	 * first, i.e. clear the MSGVAL flag in the arbiter.
> >  	 */
> >  	if (rtr != (bool)test_bit(idx, &priv->tx_dir)) {
> > -		u32 obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > +		u32 obj = idx + priv->msg_obj_tx_first;
> >  
> >  		c_can_inval_msg_object(dev, iface, obj);
> >  		change_bit(idx, &priv->tx_dir);
> > @@ -463,10 +460,10 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
> >  	 * prioritized. The lowest buffer number wins.
> >  	 */
> >  	idx = fls(atomic_read(&priv->tx_active));
> > -	obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > +	obj = idx + priv->msg_obj_tx_first;
> >  
> >  	/* If this is the last buffer, stop the xmit queue */
> > -	if (idx == C_CAN_MSG_OBJ_TX_NUM - 1)
> > +	if (idx == priv->msg_obj_tx_num - 1)
> >  		netif_stop_queue(dev);
> >  	/*
> >  	 * Store the message in the interface so we can call
> > @@ -549,17 +546,18 @@ static int c_can_set_bittiming(struct net_device *dev)
> >   */
> >  static void c_can_configure_msg_objects(struct net_device *dev)
> >  {
> > +	struct c_can_priv *priv = netdev_priv(dev);
> >  	int i;
> >  
> >  	/* first invalidate all message objects */
> > -	for (i = C_CAN_MSG_OBJ_RX_FIRST; i <= C_CAN_NO_OF_OBJECTS; i++)
> > +	for (i = priv->msg_obj_rx_first; i <= priv->msg_obj_num; i++)
> >  		c_can_inval_msg_object(dev, IF_RX, i);
> >  
> >  	/* setup receive message objects */
> > -	for (i = C_CAN_MSG_OBJ_RX_FIRST; i < C_CAN_MSG_OBJ_RX_LAST; i++)
> > +	for (i = priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
> >  		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
> >  
> > -	c_can_setup_receive_object(dev, IF_RX, C_CAN_MSG_OBJ_RX_LAST, 0, 0,
> > +	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
> >  				   IF_MCONT_RCV_EOB);
> >  }
> >  
> > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	while ((idx = ffs(pend))) {
> >  		idx--;
> >  		pend &= ~(1 << idx);
> > -		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > +		obj = idx + priv->msg_obj_tx_first;
> >  		c_can_inval_tx_object(dev, IF_TX, obj);
> >  		can_get_echo_skb(dev, idx, NULL);
> >  		bytes += priv->dlc[idx];
> > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	/* Clear the bits in the tx_active mask */
> >  	atomic_sub(clr, &priv->tx_active);
> >  
> > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
> >  		netif_wake_queue(dev);
> >  
> >  	if (pkts) {
> > @@ -755,11 +753,11 @@ static void c_can_do_tx(struct net_device *dev)
> >   * raced with the hardware or failed to readout all upper
> >   * objects in the last run due to quota limit.
> >   */
> > -static u32 c_can_adjust_pending(u32 pend)
> > +static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
> >  {
> >  	u32 weight, lasts;
> >  
> > -	if (pend == RECEIVE_OBJECT_BITS)
> > +	if (pend == rx_mask)
> >  		return pend;
> >  
> >  	/*
> > @@ -862,8 +860,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
> >  	 * It is faster to read only one 16bit register. This is only possible
> >  	 * for a maximum number of 16 objects.
> >  	 */
> > -	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
> > -			"Implementation does not support more message objects than 16");
> > +	WARN_ON(priv->msg_obj_rx_last > 16);
> >  
> >  	while (quota > 0) {
> >  		if (!pend) {
> > @@ -874,7 +871,8 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
> >  			 * If the pending field has a gap, handle the
> >  			 * bits above the gap first.
> >  			 */
> > -			toread = c_can_adjust_pending(pend);
> > +			toread = c_can_adjust_pending(pend,
> > +						      priv->msg_obj_rx_mask);
> >  		} else {
> >  			toread = pend;
> >  		}
> > @@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
> >  	return 0;
> >  }
> >  
> > -struct net_device *alloc_c_can_dev(void)
> > +struct net_device *alloc_c_can_dev(int msg_obj_num)
> >  {
> >  	struct net_device *dev;
> >  	struct c_can_priv *priv;
> > +	int msg_obj_tx_num = msg_obj_num / 2;
> >  
> > -	dev = alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> > +	dev = alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> > +			   msg_obj_tx_num);
> >  	if (!dev)
> >  		return NULL;
> >  
> >  	priv = netdev_priv(dev);
> > -	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
> > +	priv->msg_obj_num = msg_obj_num;
> > +	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
> > +	priv->msg_obj_rx_first = 1;
> > +	priv->msg_obj_rx_last =
> > +		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
> > +	priv->msg_obj_rx_mask = ((u64)1 << priv->msg_obj_rx_num) - 1;
> > +
> > +	priv->msg_obj_tx_num = msg_obj_tx_num;
> > +	priv->msg_obj_tx_first = priv->msg_obj_rx_last + 1;
> > +	priv->msg_obj_tx_last =
> > +		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
> > +
> > +	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
> >  
> >  	priv->dev = dev;
> >  	priv->can.bittiming_const = &c_can_bittiming_const;
> > diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> > index 90d3d2e7a086..22ae6077b489 100644
> > --- a/drivers/net/can/c_can/c_can.h
> > +++ b/drivers/net/can/c_can/c_can.h
> > @@ -22,18 +22,7 @@
> >  #ifndef C_CAN_H
> >  #define C_CAN_H
> >  
> > -/* message object split */
> >  #define C_CAN_NO_OF_OBJECTS	32
> > -#define C_CAN_MSG_OBJ_RX_NUM	16
> > -#define C_CAN_MSG_OBJ_TX_NUM	16
> > -
> > -#define C_CAN_MSG_OBJ_RX_FIRST	1
> > -#define C_CAN_MSG_OBJ_RX_LAST	(C_CAN_MSG_OBJ_RX_FIRST + \
> > -				C_CAN_MSG_OBJ_RX_NUM - 1)
> > -
> > -#define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
> > -
> > -#define RECEIVE_OBJECT_BITS	0x0000ffff
> >  
> >  enum reg {
> >  	C_CAN_CTRL_REG = 0,
> > @@ -193,6 +182,14 @@ struct c_can_priv {
> >  	struct napi_struct napi;
> >  	struct net_device *dev;
> >  	struct device *device;
> > +	int msg_obj_num;
> > +	int msg_obj_rx_num;
> > +	int msg_obj_tx_num;
> > +	int msg_obj_rx_first;
> > +	int msg_obj_rx_last;
> > +	int msg_obj_tx_first;
> > +	int msg_obj_tx_last;
> 
> I think these should/could be unsigned int.
> 
> > +	u32 msg_obj_rx_mask;
> 
> Is this variable big enough after you've extended the driver to use 64
> mailboxes?

Yes. I have kept the message assignment policy unchanged, they are equally 
divided between reception and transmission. Therefore, in the case of 64 
messages, 32 are used for reception and 32 for transmission. So a 32-bit 
variable is enough.

> 
> If you want to support 128 message objects converting the driver to the
> linux bitmap API is another option.
> 

Do you know if any of the hardware managed by Linux use a D_CAN controller 
with 128 message objects?

Thanks and regards,
Dario 

> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
