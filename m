Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300CF99EE2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbfHVSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:31:55 -0400
Received: from mout.web.de ([212.227.17.12]:45769 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbfHVSbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 14:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566498623;
        bh=uWaNpa1YhXhY1vz4l3ar6mtL1aIOJbLjjlU5HI7lqLc=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=BH7rMso2K1tCPT4f8CJUm6Ee1s/iPMCusS0LcM34VCuRcDspqhd7Tk9gCq8qCAQ2E
         4Zwvbqd7ztovp33VzMqb47nKXOz9PZJoxTL97npqL1Z5wTsdiM/7H1pRsc7g9umDJW
         3ebHvtdxDI6qfbPu9CQRf9Wi1Thwc++b/El2xFKw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.181.43]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LwYwF-1iJ5RQ0Vxv-018HTr; Thu, 22
 Aug 2019 20:30:23 +0200
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        intel-wired-lan@lists.osuosl.org,
        bcm-kernel-feedback-list@broadcom.com,
        UNGLinuxDriver@microchip.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Heimpold <michael.heimpold@i2se.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Steve Winslow <swinslow@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>,
        zhong jiang <zhongjiang@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_ethernet=3a_Delete_unnecessary_checks_before_?=
 =?UTF-8?B?dGhlIG1hY3JvIGNhbGwg4oCcZGV2X2tmcmVlX3NrYuKAnQ==?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
Date:   Thu, 22 Aug 2019 20:30:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XxLUPeXVq+mBAe9GHmX5o2c82wVOgvceUtADbaBZo5+cz9wpyK5
 iEnvInsf7YyYJfAO8XRZox32osVqV75pztImkF8ZS3JCfR3/55S2jM4eQdtphYT2SYvWNxh
 U8Eix6eSiWhhNZ3sVOLEilbhxr/tSM+YScoKPdTYsWa3+R234OHHyKs85lTL/4Uc/RpEaCn
 W00ETOb8A/d6bJQpbLuYQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wa4GnYHZi5U=:VwVSuf1VqQ/GRvpRmQ+1Av
 Iq72ofvy+f1BwnIcWjUNoo7lULt2dNjtzb2ZmLc6bLp/gYqx6hIfA7dPE35QhYV2Ag8fx0WZj
 BhPffrTh2NgDXf619uMy6nUOtZvrdHsn1inrwz9YBbjcTbjYqBVF3p04MxrxQ7OqYKl8srvMP
 lzvBs/7rgD1ZR1hsvYMCPC4dpAejXDeEzv2vIttqLfhlwlBM/+14RSfbIsIxTfnoPOvPnTkAb
 pAANBqXKW5xfXSRJp2yxa0h7oP/lW4+yd9u5Rndc1SvE7AS7fJxUY4Vda4+N90nFoe/sfgJFH
 f8lp/AGTCCJW9U7ZHuHvM51Lu280Olhos04u5L5RTtIpGTEIEaAKYn5FOgFnASCwOBj980+PX
 j2Oi7YbTmsVBpmuCL0K80hY3t0kaCaRk4rUizCkAN+kmwaCaNU44/hhJDzWDchcc2EKG3diJ5
 ep4mQY+5uKqxsqZAJzceMS/RQ2k12lacZT3tHbEN8heDkaUKhKfb3CrQSGvqXfGcy+RHuZcKG
 qNm2/uH3Sx7sz1/vgabFYD8AYgJaU7UOBUxliC0JsET84U+ix/ggm3VrQ63wq2Ynh6ttbslS2
 uiTkqYo/YRBhaTZDJvEMI9i/INuAi3Z/OIpHzfvdC2PHBi53jH+0zNxDWnAXXEHsY7xSNiOE6
 lieA3OGx1DrMuDAAjsu/3vZU/mYn2Aomhg9daScK1v7JRydEhyy3vHAr089naaiLVqMxqdRET
 TcQ0xTN78fb0A7DgDzK6K1JY+OFShk2CGUkRL/A3ocXvqqaJuKXDbQKzPlPCwrJnzP9DQ3Ozb
 amyZ5XQNqHes17d2lIZaW4Z+Ir1F2bdvtcPZTZqRXfzN1zVwDk3/iuk+W/Z5kw8z4YkzMZDpI
 C67OtMYJXZc+oFu2x1pXMLUi8Ule6jXhx8ODqiqK1LsbgG2KsC+dvEJjiQxw7lTeQZONUT9Db
 I/7mWiCRach/BL/jKoAejt68pk1uufhghmoBFsb5H/PKl+82yO9ycdR7ZUYvjjDskqN0IXuUR
 6KD2H3itAgTXn9Wco/9PjuxwpHUKadeX479kwprR8hv142zrLzSnD6NOtqkZBF8ivKwPqR6xD
 2qXa5Ov1hK2J9JCMX26HzHscVAjRs5u2E+NBa8hls/sDVytvBCBj0ipWhvPzN7nO6hvi3kn8r
 U+qLg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Aug 2019 20:02:56 +0200

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/ethernet/amd/ni65.c                   |  6 ++----
 drivers/net/ethernet/broadcom/bcmsysport.c        |  3 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    | 11 +++--------
 drivers/net/ethernet/freescale/gianfar.c          |  3 +--
 drivers/net/ethernet/ibm/ehea/ehea_main.c         | 12 ++++--------
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c  |  3 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c     |  3 +--
 drivers/net/ethernet/intel/e1000e/ethtool.c       |  6 ++----
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c   |  3 +--
 drivers/net/ethernet/intel/igb/igb_main.c         |  3 +--
 drivers/net/ethernet/intel/igc/igc_main.c         |  3 +--
 drivers/net/ethernet/micrel/ks8842.c              |  4 +---
 drivers/net/ethernet/microchip/lan743x_ptp.c      |  3 +--
 drivers/net/ethernet/packetengines/yellowfin.c    |  3 +--
 drivers/net/ethernet/qualcomm/qca_spi.c           |  3 +--
 drivers/net/ethernet/qualcomm/qca_uart.c          |  3 +--
 drivers/net/ethernet/sgi/meth.c                   |  3 +--
 drivers/net/ethernet/smsc/smc91x.c                |  3 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +--
 drivers/net/ethernet/sun/sunvnet_common.c         |  3 +--
 20 files changed, 27 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni=
65.c
index 87ff5d6d1b22..c6c2a54c1121 100644
=2D-- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -697,16 +697,14 @@ static void ni65_free_buffer(struct priv *p)
 	for(i=3D0;i<TMDNUM;i++) {
 		kfree(p->tmdbounce[i]);
 #ifdef XMT_VIA_SKB
-		if(p->tmd_skb[i])
-			dev_kfree_skb(p->tmd_skb[i]);
+		dev_kfree_skb(p->tmd_skb[i]);
 #endif
 	}

 	for(i=3D0;i<RMDNUM;i++)
 	{
 #ifdef RCV_VIA_SKB
-		if(p->recv_skb[i])
-			dev_kfree_skb(p->recv_skb[i]);
+		dev_kfree_skb(p->recv_skb[i]);
 #else
 		kfree(p->recvbounce[i]);
 #endif
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethe=
rnet/broadcom/bcmsysport.c
index 9483553ce444..6a47daec2302 100644
=2D-- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -708,8 +708,7 @@ static int bcm_sysport_alloc_rx_bufs(struct bcm_syspor=
t_priv *priv)
 	for (i =3D 0; i < priv->num_rx_bds; i++) {
 		cb =3D &priv->rx_cbs[i];
 		skb =3D bcm_sysport_rx_refill(priv, cb);
-		if (skb)
-			dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
 		if (!cb->skb)
 			return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index d3a0b614dbfa..8b19ddcdafaa 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2515,19 +2515,14 @@ static int bcmgenet_dma_teardown(struct bcmgenet_p=
riv *priv)
 static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 {
 	struct netdev_queue *txq;
-	struct sk_buff *skb;
-	struct enet_cb *cb;
 	int i;

 	bcmgenet_fini_rx_napi(priv);
 	bcmgenet_fini_tx_napi(priv);

-	for (i =3D 0; i < priv->num_tx_bds; i++) {
-		cb =3D priv->tx_cbs + i;
-		skb =3D bcmgenet_free_tx_cb(&priv->pdev->dev, cb);
-		if (skb)
-			dev_kfree_skb(skb);
-	}
+	for (i =3D 0; i < priv->num_tx_bds; i++)
+		dev_kfree_skb(bcmgenet_free_tx_cb(&priv->pdev->dev,
+						  priv->tx_cbs + i));

 	for (i =3D 0; i < priv->hw_params->tx_queues; i++) {
 		txq =3D netdev_get_tx_queue(priv->dev, priv->tx_rings[i].queue);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethern=
et/freescale/gianfar.c
index 7ea19e173339..412c0340fed9 100644
=2D-- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2005,8 +2005,7 @@ static void free_skb_rx_queue(struct gfar_priv_rx_q =
*rx_queue)

 	struct rxbd8 *rxbdp =3D rx_queue->rx_bd_base;

-	if (rx_queue->skb)
-		dev_kfree_skb(rx_queue->skb);
+	dev_kfree_skb(rx_queue->skb);

 	for (i =3D 0; i < rx_queue->rx_ring_size; i++) {
 		struct	gfar_rx_buff *rxb =3D &rx_queue->rx_buff[i];
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ether=
net/ibm/ehea/ehea_main.c
index cca71ba7a74a..13e30eba5349 100644
=2D-- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1577,20 +1577,16 @@ static int ehea_clean_portres(struct ehea_port *po=
rt, struct ehea_port_res *pr)
 		ehea_destroy_eq(pr->eq);

 		for (i =3D 0; i < pr->rq1_skba.len; i++)
-			if (pr->rq1_skba.arr[i])
-				dev_kfree_skb(pr->rq1_skba.arr[i]);
+			dev_kfree_skb(pr->rq1_skba.arr[i]);

 		for (i =3D 0; i < pr->rq2_skba.len; i++)
-			if (pr->rq2_skba.arr[i])
-				dev_kfree_skb(pr->rq2_skba.arr[i]);
+			dev_kfree_skb(pr->rq2_skba.arr[i]);

 		for (i =3D 0; i < pr->rq3_skba.len; i++)
-			if (pr->rq3_skba.arr[i])
-				dev_kfree_skb(pr->rq3_skba.arr[i]);
+			dev_kfree_skb(pr->rq3_skba.arr[i]);

 		for (i =3D 0; i < pr->sq_skba.len; i++)
-			if (pr->sq_skba.arr[i])
-				dev_kfree_skb(pr->sq_skba.arr[i]);
+			dev_kfree_skb(pr->sq_skba.arr[i]);

 		vfree(pr->rq1_skba.arr);
 		vfree(pr->rq2_skba.arr);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/ne=
t/ethernet/intel/e1000/e1000_ethtool.c
index a41008523c98..71d3d8854d8f 100644
=2D-- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -937,8 +937,7 @@ static void e1000_free_desc_rings(struct e1000_adapter=
 *adapter)
 						 txdr->buffer_info[i].dma,
 						 txdr->buffer_info[i].length,
 						 DMA_TO_DEVICE);
-			if (txdr->buffer_info[i].skb)
-				dev_kfree_skb(txdr->buffer_info[i].skb);
+			dev_kfree_skb(txdr->buffer_info[i].skb);
 		}
 	}

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/e=
thernet/intel/e1000/e1000_main.c
index 6b6ba1c38235..86493fea56e4 100644
=2D-- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4175,8 +4175,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_ad=
apter *adapter,
 				/* an error means any chain goes out the window
 				 * too
 				 */
-				if (rx_ring->rx_skb_top)
-					dev_kfree_skb(rx_ring->rx_skb_top);
+				dev_kfree_skb(rx_ring->rx_skb_top);
 				rx_ring->rx_skb_top =3D NULL;
 				goto next_desc;
 			}
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/eth=
ernet/intel/e1000e/ethtool.c
index 08342698386d..de8c5818a305 100644
=2D-- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1126,8 +1126,7 @@ static void e1000_free_desc_rings(struct e1000_adapt=
er *adapter)
 						 buffer_info->dma,
 						 buffer_info->length,
 						 DMA_TO_DEVICE);
-			if (buffer_info->skb)
-				dev_kfree_skb(buffer_info->skb);
+			dev_kfree_skb(buffer_info->skb);
 		}
 	}

@@ -1139,8 +1138,7 @@ static void e1000_free_desc_rings(struct e1000_adapt=
er *adapter)
 				dma_unmap_single(&pdev->dev,
 						 buffer_info->dma,
 						 2048, DMA_FROM_DEVICE);
-			if (buffer_info->skb)
-				dev_kfree_skb(buffer_info->skb);
+			dev_kfree_skb(buffer_info->skb);
 		}
 	}

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net=
/ethernet/intel/fm10k/fm10k_netdev.c
index d3e85480f46d..09f7a246e134 100644
=2D-- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -253,8 +253,7 @@ static void fm10k_clean_rx_ring(struct fm10k_ring *rx_=
ring)
 	if (!rx_ring->rx_buffer)
 		return;

-	if (rx_ring->skb)
-		dev_kfree_skb(rx_ring->skb);
+	dev_kfree_skb(rx_ring->skb);
 	rx_ring->skb =3D NULL;

 	/* Free all the Rx ring sk_buffs */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ether=
net/intel/igb/igb_main.c
index b63e77528a91..105b0624081a 100644
=2D-- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4731,8 +4731,7 @@ static void igb_clean_rx_ring(struct igb_ring *rx_ri=
ng)
 {
 	u16 i =3D rx_ring->next_to_clean;

-	if (rx_ring->skb)
-		dev_kfree_skb(rx_ring->skb);
+	dev_kfree_skb(rx_ring->skb);
 	rx_ring->skb =3D NULL;

 	/* Free all the Rx ring sk_buffs */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ether=
net/intel/igc/igc_main.c
index e5114bebd30b..251552855c40 100644
=2D-- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -352,8 +352,7 @@ static void igc_clean_rx_ring(struct igc_ring *rx_ring=
)
 {
 	u16 i =3D rx_ring->next_to_clean;

-	if (rx_ring->skb)
-		dev_kfree_skb(rx_ring->skb);
+	dev_kfree_skb(rx_ring->skb);
 	rx_ring->skb =3D NULL;

 	/* Free all the Rx ring sk_buffs */
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/m=
icrel/ks8842.c
index ccd06702cc56..da329ca115cc 100644
=2D-- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -580,9 +580,7 @@ static int __ks8842_start_new_rx_dma(struct net_device=
 *netdev)
 		dma_unmap_single(adapter->dev, sg_dma_address(sg),
 			DMA_BUFFER_SIZE, DMA_FROM_DEVICE);
 	sg_dma_address(sg) =3D 0;
-	if (ctl->skb)
-		dev_kfree_skb(ctl->skb);
-
+	dev_kfree_skb(ctl->skb);
 	ctl->skb =3D NULL;

 	printk(KERN_ERR DRV_NAME": Failed to start RX DMA: %d\n", err);
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/et=
hernet/microchip/lan743x_ptp.c
index b2109eca81fd..57b26c2acf87 100644
=2D-- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -963,8 +963,7 @@ void lan743x_ptp_close(struct lan743x_adapter *adapter=
)
 		index++) {
 		struct sk_buff *skb =3D ptp->tx_ts_skb_queue[index];

-		if (skb)
-			dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
 		ptp->tx_ts_skb_queue[index] =3D NULL;
 		ptp->tx_ts_seconds_queue[index] =3D 0;
 		ptp->tx_ts_nseconds_queue[index] =3D 0;
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/=
ethernet/packetengines/yellowfin.c
index 6f8d6584f809..5113ee647090 100644
=2D-- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -1258,8 +1258,7 @@ static int yellowfin_close(struct net_device *dev)
 		yp->rx_skbuff[i] =3D NULL;
 	}
 	for (i =3D 0; i < TX_RING_SIZE; i++) {
-		if (yp->tx_skbuff[i])
-			dev_kfree_skb(yp->tx_skbuff[i]);
+		dev_kfree_skb(yp->tx_skbuff[i]);
 		yp->tx_skbuff[i] =3D NULL;
 	}

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/etherne=
t/qualcomm/qca_spi.c
index b28360bc2255..5ecf61df78bd 100644
=2D-- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -837,8 +837,7 @@ qcaspi_netdev_uninit(struct net_device *dev)

 	kfree(qca->rx_buffer);
 	qca->buffer_size =3D 0;
-	if (qca->rx_skb)
-		dev_kfree_skb(qca->rx_skb);
+	dev_kfree_skb(qca->rx_skb);
 }

 static const struct net_device_ops qcaspi_netdev_ops =3D {
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethern=
et/qualcomm/qca_uart.c
index 590616846cd1..0981068504fa 100644
=2D-- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -285,8 +285,7 @@ static void qcauart_netdev_uninit(struct net_device *d=
ev)
 {
 	struct qcauart *qca =3D netdev_priv(dev);

-	if (qca->rx_skb)
-		dev_kfree_skb(qca->rx_skb);
+	dev_kfree_skb(qca->rx_skb);
 }

 static const struct net_device_ops qcauart_netdev_ops =3D {
diff --git a/drivers/net/ethernet/sgi/meth.c b/drivers/net/ethernet/sgi/me=
th.c
index 00660dd820e2..539bc5db989c 100644
=2D-- a/drivers/net/ethernet/sgi/meth.c
+++ b/drivers/net/ethernet/sgi/meth.c
@@ -247,8 +247,7 @@ static void meth_free_tx_ring(struct meth_private *pri=
v)

 	/* Remove any pending skb */
 	for (i =3D 0; i < TX_RING_ENTRIES; i++) {
-		if (priv->tx_skbs[i])
-			dev_kfree_skb(priv->tx_skbs[i]);
+		dev_kfree_skb(priv->tx_skbs[i]);
 		priv->tx_skbs[i] =3D NULL;
 	}
 	dma_free_coherent(&priv->pdev->dev, TX_RING_BUFFER_SIZE, priv->tx_ring,
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/sms=
c/smc91x.c
index 601e76ad99a0..3a6761131f4c 100644
=2D-- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -378,8 +378,7 @@ static void smc_shutdown(struct net_device *dev)
 	pending_skb =3D lp->pending_tx_skb;
 	lp->pending_tx_skb =3D NULL;
 	spin_unlock_irq(&lp->lock);
-	if (pending_skb)
-		dev_kfree_skb(pending_skb);
+	dev_kfree_skb(pending_skb);

 	/* and tell the card to stay away from that nasty outside world */
 	SMC_SELECT_BANK(lp, 0);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/n=
et/ethernet/stmicro/stmmac/stmmac_main.c
index bd1078433448..06ccd216ae90 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3519,8 +3519,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int l=
imit, u32 queue)
 		if (unlikely(error && (status & rx_not_ls)))
 			goto read_again;
 		if (unlikely(error)) {
-			if (skb)
-				dev_kfree_skb(skb);
+			dev_kfree_skb(skb);
 			continue;
 		}

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ether=
net/sun/sunvnet_common.c
index 646e67236b65..8b94d9ad9e2b 100644
=2D-- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1532,8 +1532,7 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struc=
t net_device *dev,
 	else if (port)
 		del_timer(&port->clean_timer);
 	rcu_read_unlock();
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 	vnet_free_skbs(freeskbs);
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
=2D-
2.23.0

