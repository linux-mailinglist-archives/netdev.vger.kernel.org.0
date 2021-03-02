Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001BD32B3BE
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574473AbhCCEFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:35 -0500
Received: from relay-b02.edpnet.be ([212.71.1.222]:49786 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835425AbhCBTGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:06:48 -0500
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2021 14:06:46 EST
X-ASG-Debug-ID: 1614710943-15c433551828b60001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (94.105.105.240.dyn.edpnet.net [94.105.105.240]) by relay-b02.edpnet.be with ESMTP id E27CLgDG1G7VaeiH; Tue, 02 Mar 2021 19:49:03 +0100 (CET)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 94.105.105.240.dyn.edpnet.net[94.105.105.240]
X-Barracuda-Apparent-Source-IP: 94.105.105.240
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id DBCAF12A73D7;
        Tue,  2 Mar 2021 19:49:02 +0100 (CET)
Date:   Tue, 2 Mar 2021 19:49:01 +0100
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210302184901.GD26930@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Mail-Followup-To: Dario Binacchi <dariobin@libero.it>,
        linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210228103856.4089-6-dariobin@libero.it>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 94.105.105.240.dyn.edpnet.net[94.105.105.240]
X-Barracuda-Start-Time: 1614710943
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 10349
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.88270
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Feb 2021 11:38:54 +0100, Dario Binacchi wrote:
> Date:   Sun, 28 Feb 2021 11:38:54 +0100
> From: Dario Binacchi <dariobin@libero.it>
> To: linux-kernel@vger.kernel.org
> Cc: Federico Vaga <federico.vaga@gmail.com>, Alexander Stein
>  <alexander.stein@systec-electronic.com>, Dario Binacchi
>  <dariobin@libero.it>, "David S. Miller" <davem@davemloft.net>, Jakub
>  Kicinski <kuba@kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>, Oliver
>  Hartkopp <socketcan@hartkopp.net>, Vincent Mailhol
>  <mailhol.vincent@wanadoo.fr>, Wolfgang Grandegger <wg@grandegger.com>,
>  YueHaibing <yuehaibing@huawei.com>, Zhang Qilong
>  <zhangqilong3@huawei.com>, linux-can@vger.kernel.org,
>  netdev@vger.kernel.org
> Subject: [PATCH v3 5/6] can: c_can: prepare to up the message objects number
> X-Mailer: git-send-email 2.17.1
> 
> As pointed by commit c0a9f4d396c9 ("can: c_can: Reduce register access")
> the "driver casts the 16 message objects in stone, which is completely
> braindead as contemporary hardware has up to 128 message objects".
> 
> The patch prepares the module to extend the number of message objects
> beyond the 32 currently managed. This was achieved by transforming the
> constants used to manage RX/TX messages into variables without changing
> the driver policy.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Reported-by: kernel test robot <lkp@intel.com>
> 
> ---
> 
> Changes in v3:
> - Use unsigned int instead of int as type of the msg_obj_* fields
>   in the c_can_priv structure.
> - Replace (u64)1 with 1UL in msg_obj_rx_mask setting.
> 
> Changes in v2:
> - Fix compiling error reported by kernel test robot.
> - Add Reported-by tag.
> - Pass larger size to alloc_candev() routine to avoid an additional
>   memory allocation/deallocation.
> 
>  drivers/net/can/c_can/c_can.c          | 50 ++++++++++++++++----------
>  drivers/net/can/c_can/c_can.h          | 23 ++++++------
>  drivers/net/can/c_can/c_can_pci.c      |  2 +-
>  drivers/net/can/c_can/c_can_platform.c |  2 +-
>  4 files changed, 43 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index 7081cfaf62e2..ede6f4d62095 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
> @@ -173,9 +173,6 @@
>  /* Wait for ~1 sec for INIT bit */
>  #define INIT_WAIT_MS		1000
>  
> -/* napi related */
> -#define C_CAN_NAPI_WEIGHT	C_CAN_MSG_OBJ_RX_NUM
> -
>  /* c_can lec values */
>  enum c_can_lec_type {
>  	LEC_NO_ERROR = 0,
> @@ -325,7 +322,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
>  	 * first, i.e. clear the MSGVAL flag in the arbiter.
>  	 */
>  	if (rtr != (bool)test_bit(idx, &priv->tx_dir)) {
> -		u32 obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> +		u32 obj = idx + priv->msg_obj_tx_first;
>  
>  		c_can_inval_msg_object(dev, iface, obj);
>  		change_bit(idx, &priv->tx_dir);
> @@ -463,10 +460,10 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
>  	 * prioritized. The lowest buffer number wins.
>  	 */
>  	idx = fls(atomic_read(&priv->tx_active));
> -	obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> +	obj = idx + priv->msg_obj_tx_first;
>  
>  	/* If this is the last buffer, stop the xmit queue */
> -	if (idx == C_CAN_MSG_OBJ_TX_NUM - 1)
> +	if (idx == priv->msg_obj_tx_num - 1)
>  		netif_stop_queue(dev);
>  	/*
>  	 * Store the message in the interface so we can call
> @@ -549,17 +546,18 @@ static int c_can_set_bittiming(struct net_device *dev)
>   */
>  static void c_can_configure_msg_objects(struct net_device *dev)
>  {
> +	struct c_can_priv *priv = netdev_priv(dev);
>  	int i;
>  
>  	/* first invalidate all message objects */
> -	for (i = C_CAN_MSG_OBJ_RX_FIRST; i <= C_CAN_NO_OF_OBJECTS; i++)
> +	for (i = priv->msg_obj_rx_first; i <= priv->msg_obj_num; i++)
>  		c_can_inval_msg_object(dev, IF_RX, i);
>  
>  	/* setup receive message objects */
> -	for (i = C_CAN_MSG_OBJ_RX_FIRST; i < C_CAN_MSG_OBJ_RX_LAST; i++)
> +	for (i = priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
>  		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
>  
> -	c_can_setup_receive_object(dev, IF_RX, C_CAN_MSG_OBJ_RX_LAST, 0, 0,
> +	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
>  				   IF_MCONT_RCV_EOB);
>  }
>  
> @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
>  	while ((idx = ffs(pend))) {
>  		idx--;
>  		pend &= ~(1 << idx);
> -		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> +		obj = idx + priv->msg_obj_tx_first;
>  		c_can_inval_tx_object(dev, IF_TX, obj);
>  		can_get_echo_skb(dev, idx, NULL);
>  		bytes += priv->dlc[idx];
> @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
>  	/* Clear the bits in the tx_active mask */
>  	atomic_sub(clr, &priv->tx_active);
>  
> -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
>  		netif_wake_queue(dev);
>  
>  	if (pkts) {
> @@ -755,11 +753,11 @@ static void c_can_do_tx(struct net_device *dev)
>   * raced with the hardware or failed to readout all upper
>   * objects in the last run due to quota limit.
>   */
> -static u32 c_can_adjust_pending(u32 pend)
> +static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
>  {
>  	u32 weight, lasts;
>  
> -	if (pend == RECEIVE_OBJECT_BITS)
> +	if (pend == rx_mask)
>  		return pend;
>  
>  	/*
> @@ -862,8 +860,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
>  	 * It is faster to read only one 16bit register. This is only possible
>  	 * for a maximum number of 16 objects.
>  	 */
> -	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
> -			"Implementation does not support more message objects than 16");
> +	WARN_ON(priv->msg_obj_rx_last > 16);
>  
>  	while (quota > 0) {
>  		if (!pend) {
> @@ -874,7 +871,8 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
>  			 * If the pending field has a gap, handle the
>  			 * bits above the gap first.
>  			 */
> -			toread = c_can_adjust_pending(pend);
> +			toread = c_can_adjust_pending(pend,
> +						      priv->msg_obj_rx_mask);
>  		} else {
>  			toread = pend;
>  		}
> @@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
>  	return 0;
>  }
>  
> -struct net_device *alloc_c_can_dev(void)
> +struct net_device *alloc_c_can_dev(int msg_obj_num)
>  {
>  	struct net_device *dev;
>  	struct c_can_priv *priv;
> +	int msg_obj_tx_num = msg_obj_num / 2;

IMO, a bigger tx queue is not usefull.
A bigger rx queue however is.

My series last year took a fixed lenght of 8 for tx,
and use the remaining as rx queue.

>  
> -	dev = alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> +	dev = alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> +			   msg_obj_tx_num);
>  	if (!dev)
>  		return NULL;
>  
>  	priv = netdev_priv(dev);
> -	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
> +	priv->msg_obj_num = msg_obj_num;
> +	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
> +	priv->msg_obj_rx_first = 1;
> +	priv->msg_obj_rx_last =
> +		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
> +	priv->msg_obj_rx_mask = (1UL << priv->msg_obj_rx_num) - 1;
> +
> +	priv->msg_obj_tx_num = msg_obj_tx_num;
> +	priv->msg_obj_tx_first = priv->msg_obj_rx_last + 1;
> +	priv->msg_obj_tx_last =
> +		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
> +
> +	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
>  
>  	priv->dev = dev;
>  	priv->can.bittiming_const = &c_can_bittiming_const;
> diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> index 90d3d2e7a086..68295fab83d9 100644
> --- a/drivers/net/can/c_can/c_can.h
> +++ b/drivers/net/can/c_can/c_can.h
> @@ -22,18 +22,7 @@
>  #ifndef C_CAN_H
>  #define C_CAN_H
>  
> -/* message object split */
>  #define C_CAN_NO_OF_OBJECTS	32
> -#define C_CAN_MSG_OBJ_RX_NUM	16
> -#define C_CAN_MSG_OBJ_TX_NUM	16
> -
> -#define C_CAN_MSG_OBJ_RX_FIRST	1
> -#define C_CAN_MSG_OBJ_RX_LAST	(C_CAN_MSG_OBJ_RX_FIRST + \
> -				C_CAN_MSG_OBJ_RX_NUM - 1)
> -
> -#define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
> -
> -#define RECEIVE_OBJECT_BITS	0x0000ffff
>  
>  enum reg {
>  	C_CAN_CTRL_REG = 0,
> @@ -193,6 +182,14 @@ struct c_can_priv {
>  	struct napi_struct napi;
>  	struct net_device *dev;
>  	struct device *device;
> +	unsigned int msg_obj_num;
> +	unsigned int msg_obj_rx_num;
> +	unsigned int msg_obj_tx_num;
> +	unsigned int msg_obj_rx_first;
> +	unsigned int msg_obj_rx_last;
> +	unsigned int msg_obj_tx_first;
> +	unsigned int msg_obj_tx_last;
> +	u32 msg_obj_rx_mask;
>  	atomic_t tx_active;
>  	atomic_t sie_pending;
>  	unsigned long tx_dir;
> @@ -209,10 +206,10 @@ struct c_can_priv {
>  	void (*raminit) (const struct c_can_priv *priv, bool enable);
>  	u32 comm_rcv_high;
>  	u32 rxmasked;
> -	u32 dlc[C_CAN_MSG_OBJ_TX_NUM];
> +	u32 dlc[];
>  };
>  
> -struct net_device *alloc_c_can_dev(void);
> +struct net_device *alloc_c_can_dev(int msg_obj_num);
>  void free_c_can_dev(struct net_device *dev);
>  int register_c_can_dev(struct net_device *dev);
>  void unregister_c_can_dev(struct net_device *dev);
> diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
> index 406b4847e5dc..3752f68d095e 100644
> --- a/drivers/net/can/c_can/c_can_pci.c
> +++ b/drivers/net/can/c_can/c_can_pci.c
> @@ -149,7 +149,7 @@ static int c_can_pci_probe(struct pci_dev *pdev,
>  	}
>  
>  	/* allocate the c_can device */
> -	dev = alloc_c_can_dev();
> +	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
>  	if (!dev) {
>  		ret = -ENOMEM;
>  		goto out_iounmap;
> diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
> index 05f425ceb53a..a5b9b1a93702 100644
> --- a/drivers/net/can/c_can/c_can_platform.c
> +++ b/drivers/net/can/c_can/c_can_platform.c
> @@ -293,7 +293,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
>  	}
>  
>  	/* allocate the c_can device */
> -	dev = alloc_c_can_dev();
> +	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
>  	if (!dev) {
>  		ret = -ENOMEM;
>  		goto exit;
> -- 
> 2.17.1
> 
