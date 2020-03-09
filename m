Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A68417E7B5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCITAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:00:53 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:3727 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbgCITAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 15:00:53 -0400
X-Greylist: delayed 829 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 15:00:52 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id 029IkPJZ008513
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 9 Mar 2020 12:46:26 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id 029IkPuG051188
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 9 Mar 2020 12:46:25 -0600
Subject: Re: [PATCH v2 12/14] net: axienet: Upgrade descriptors to hold 64-bit
 addresses
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
References: <20200309181851.190164-1-andre.przywara@arm.com>
 <20200309181851.190164-13-andre.przywara@arm.com>
From:   Robert Hancock <hancock@sedsystems.ca>
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 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
Organization: SED Systems
Message-ID: <a0cab814-4c93-a59c-55cb-3c5f17c1bcde@sedsystems.ca>
Date:   Mon, 9 Mar 2020 12:46:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309181851.190164-13-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-09 12:18 p.m., Andre Przywara wrote:
> Newer revisions of the AXI DMA IP (>= v7.1) support 64-bit addresses,
> both for the descriptors itself, as well as for the buffers they are
> pointing to.
> This is realised by adding "MSB" words for the next and phys pointer
> right behind the existing address word, now named "LSB". These MSB words
> live in formerly reserved areas of the descriptor.
> 
> If the hardware supports it, write both words when setting an address.
> The buffer address is handled by two wrapper functions, the two
> occasions where we set the next pointers are open coded.
> 
> For now this is guarded by a flag which we don't set yet.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |   9 +-
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 113 ++++++++++++------
>  2 files changed, 83 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index fb7450ca5c53..84c4c3655516 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -328,6 +328,7 @@
>  #define XAE_FEATURE_PARTIAL_TX_CSUM	(1 << 1)
>  #define XAE_FEATURE_FULL_RX_CSUM	(1 << 2)
>  #define XAE_FEATURE_FULL_TX_CSUM	(1 << 3)
> +#define XAE_FEATURE_DMA_64BIT		(1 << 4)
>  
>  #define XAE_NO_CSUM_OFFLOAD		0
>  
> @@ -340,9 +341,9 @@
>  /**
>   * struct axidma_bd - Axi Dma buffer descriptor layout
>   * @next:         MM2S/S2MM Next Descriptor Pointer
> - * @reserved1:    Reserved and not used
> + * @next_msb:     MM2S/S2MM Next Descriptor Pointer (high 32 bits)
>   * @phys:         MM2S/S2MM Buffer Address
> - * @reserved2:    Reserved and not used
> + * @phys_msb:     MM2S/S2MM Buffer Address (high 32 bits)
>   * @reserved3:    Reserved and not used
>   * @reserved4:    Reserved and not used
>   * @cntrl:        MM2S/S2MM Control value
> @@ -355,9 +356,9 @@
>   */
>  struct axidma_bd {
>  	u32 next;	/* Physical address of next buffer descriptor */
> -	u32 reserved1;
> +	u32 next_msb;	/* high 32 bits for IP >= v7.1, reserved on older IP */
>  	u32 phys;
> -	u32 reserved2;
> +	u32 phys_msb;	/* for IP >= v7.1, reserved for older IP */
>  	u32 reserved3;
>  	u32 reserved4;
>  	u32 cntrl;
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index ea44ef4cf288..edee0666d52c 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -153,6 +153,25 @@ static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
>  	axienet_dma_out32(lp, reg, lower_32_bits(addr));
>  }
>  
> +static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
> +			       struct axidma_bd *desc)
> +{
> +	desc->phys = lower_32_bits(addr);
> +	if (lp->features & XAE_FEATURE_DMA_64BIT)
> +		desc->phys_msb = upper_32_bits(addr);
> +}
> +
> +static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
> +				     struct axidma_bd *desc)
> +{
> +	dma_addr_t ret = desc->phys;
> +
> +	if (lp->features & XAE_FEATURE_DMA_64BIT)
> +		ret |= (dma_addr_t)desc->phys_msb << 32;

Does this compile/work properly on a 32-bit kernel? If dma_addr_t was a
32-bit type, I would expect that left-shifting by 32 bits may not do
what you want. Not sure if there is an inverse to lower_32_bits and
upper_32_bits macros?

> +
> +	return ret;
> +}
> +
>  /**
>   * axienet_dma_bd_release - Release buffer descriptor rings
>   * @ndev:	Pointer to the net_device structure
> @@ -176,6 +195,8 @@ static void axienet_dma_bd_release(struct net_device *ndev)
>  		return;
>  
>  	for (i = 0; i < lp->rx_bd_num; i++) {
> +		dma_addr_t phys;
> +
>  		/* A NULL skb means this descriptor has not been initialised
>  		 * at all.
>  		 */
> @@ -188,9 +209,11 @@ static void axienet_dma_bd_release(struct net_device *ndev)
>  		 * descriptor size, after it had been successfully allocated.
>  		 * So a non-zero value in there means we need to unmap it.
>  		 */
> -		if (lp->rx_bd_v[i].cntrl)
> -			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> +		if (lp->rx_bd_v[i].cntrl) {
> +			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
> +			dma_unmap_single(ndev->dev.parent, phys,
>  					 lp->max_frm_size, DMA_FROM_DEVICE);
> +		}
>  	}
>  
>  	dma_free_coherent(ndev->dev.parent,
> @@ -235,29 +258,36 @@ static int axienet_dma_bd_init(struct net_device *ndev)
>  		goto out;
>  
>  	for (i = 0; i < lp->tx_bd_num; i++) {
> -		lp->tx_bd_v[i].next = lp->tx_bd_p +
> -				      sizeof(*lp->tx_bd_v) *
> -				      ((i + 1) % lp->tx_bd_num);
> +		dma_addr_t addr = lp->tx_bd_p +
> +				  sizeof(*lp->tx_bd_v) *
> +				  ((i + 1) % lp->tx_bd_num);
> +
> +		lp->tx_bd_v[i].next = lower_32_bits(addr);
> +		if (lp->features & XAE_FEATURE_DMA_64BIT)
> +			lp->tx_bd_v[i].next_msb = upper_32_bits(addr);
>  	}
>  
>  	for (i = 0; i < lp->rx_bd_num; i++) {
> -		lp->rx_bd_v[i].next = lp->rx_bd_p +
> -				      sizeof(*lp->rx_bd_v) *
> -				      ((i + 1) % lp->rx_bd_num);
> +		dma_addr_t addr;
> +
> +		addr = lp->rx_bd_p + sizeof(*lp->rx_bd_v) *
> +			((i + 1) % lp->rx_bd_num);
> +		lp->rx_bd_v[i].next = lower_32_bits(addr);
> +		if (lp->features & XAE_FEATURE_DMA_64BIT)
> +			lp->rx_bd_v[i].next_msb = upper_32_bits(addr);
>  
>  		skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
>  		if (!skb)
>  			goto out;
>  
>  		lp->rx_bd_v[i].skb = skb;
> -		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
> -						     skb->data,
> -						     lp->max_frm_size,
> -						     DMA_FROM_DEVICE);
> -		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
> +		addr = dma_map_single(ndev->dev.parent, skb->data,
> +				      lp->max_frm_size, DMA_FROM_DEVICE);
> +		if (dma_mapping_error(ndev->dev.parent, addr)) {
>  			netdev_err(ndev, "DMA mapping error\n");
>  			goto out;
>  		}
> +		desc_set_phys_addr(lp, addr, &lp->rx_bd_v[i]);
>  
>  		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
>  	}
> @@ -573,6 +603,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
>  	struct axienet_local *lp = netdev_priv(ndev);
>  	int max_bds = (nr_bds != -1) ? nr_bds : lp->tx_bd_num;
>  	struct axidma_bd *cur_p;
> +	dma_addr_t phys;
>  	unsigned int status;
>  	int i;
>  
> @@ -586,9 +617,10 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
>  		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
>  			break;
>  
> -		dma_unmap_single(ndev->dev.parent, cur_p->phys,
> -				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
> -				DMA_TO_DEVICE);
> +		phys = desc_get_phys_addr(lp, cur_p);
> +		dma_unmap_single(ndev->dev.parent, phys,
> +				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
> +				 DMA_TO_DEVICE);
>  
>  		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
>  			dev_consume_skb_irq(cur_p->skb);
> @@ -684,7 +716,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	u32 csum_start_off;
>  	u32 csum_index_off;
>  	skb_frag_t *frag;
> -	dma_addr_t tail_p;
> +	dma_addr_t tail_p, phys;
>  	struct axienet_local *lp = netdev_priv(ndev);
>  	struct axidma_bd *cur_p;
>  	u32 orig_tail_ptr = lp->tx_bd_tail;
> @@ -723,14 +755,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
>  	}
>  
> -	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
> -				     skb_headlen(skb), DMA_TO_DEVICE);
> -	if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
> +	phys = dma_map_single(ndev->dev.parent, skb->data,
> +			      skb_headlen(skb), DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
>  		if (net_ratelimit())
>  			netdev_err(ndev, "TX DMA mapping error\n");
>  		ndev->stats.tx_dropped++;
>  		return NETDEV_TX_OK;
>  	}
> +	desc_set_phys_addr(lp, phys, cur_p);
>  	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
>  
>  	for (ii = 0; ii < num_frag; ii++) {
> @@ -738,11 +771,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  			lp->tx_bd_tail = 0;
>  		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
>  		frag = &skb_shinfo(skb)->frags[ii];
> -		cur_p->phys = dma_map_single(ndev->dev.parent,
> -					     skb_frag_address(frag),
> -					     skb_frag_size(frag),
> -					     DMA_TO_DEVICE);
> -		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
> +		phys = dma_map_single(ndev->dev.parent,
> +				      skb_frag_address(frag),
> +				      skb_frag_size(frag),
> +				      DMA_TO_DEVICE);
> +		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
>  			if (net_ratelimit())
>  				netdev_err(ndev, "TX DMA mapping error\n");
>  			ndev->stats.tx_dropped++;
> @@ -752,6 +785,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  
>  			return NETDEV_TX_OK;
>  		}
> +		desc_set_phys_addr(lp, phys, cur_p);
>  		cur_p->cntrl = skb_frag_size(frag);
>  	}
>  
> @@ -790,10 +824,12 @@ static void axienet_recv(struct net_device *ndev)
>  	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
>  
>  	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
> +		dma_addr_t phys;
> +
>  		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
>  
> -		dma_unmap_single(ndev->dev.parent, cur_p->phys,
> -				 lp->max_frm_size,
> +		phys = desc_get_phys_addr(lp, cur_p);
> +		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
>  				 DMA_FROM_DEVICE);
>  
>  		skb = cur_p->skb;
> @@ -829,15 +865,16 @@ static void axienet_recv(struct net_device *ndev)
>  		if (!new_skb)
>  			return;
>  
> -		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
> -					     lp->max_frm_size,
> -					     DMA_FROM_DEVICE);
> -		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
> +		phys = dma_map_single(ndev->dev.parent, new_skb->data,
> +				      lp->max_frm_size,
> +				      DMA_FROM_DEVICE);
> +		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
>  			if (net_ratelimit())
>  				netdev_err(ndev, "RX DMA mapping error\n");
>  			dev_kfree_skb(new_skb);
>  			return;
>  		}
> +		desc_set_phys_addr(lp, phys, cur_p);
>  
>  		cur_p->cntrl = lp->max_frm_size;
>  		cur_p->status = 0;
> @@ -882,7 +919,8 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
>  		return IRQ_NONE;
>  	if (status & XAXIDMA_IRQ_ERROR_MASK) {
>  		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
> -		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
> +		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
> +			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
>  			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
>  
>  		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
> @@ -931,7 +969,8 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
>  		return IRQ_NONE;
>  	if (status & XAXIDMA_IRQ_ERROR_MASK) {
>  		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
> -		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
> +		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
> +			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
>  			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
>  
>  		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
> @@ -1633,14 +1672,18 @@ static void axienet_dma_err_handler(struct work_struct *work)
>  
>  	for (i = 0; i < lp->tx_bd_num; i++) {
>  		cur_p = &lp->tx_bd_v[i];
> -		if (cur_p->cntrl)
> -			dma_unmap_single(ndev->dev.parent, cur_p->phys,
> +		if (cur_p->cntrl) {
> +			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
> +
> +			dma_unmap_single(ndev->dev.parent, addr,
>  					 (cur_p->cntrl &
>  					  XAXIDMA_BD_CTRL_LENGTH_MASK),
>  					 DMA_TO_DEVICE);
> +		}
>  		if (cur_p->skb)
>  			dev_kfree_skb_irq(cur_p->skb);
>  		cur_p->phys = 0;
> +		cur_p->phys_msb = 0;
>  		cur_p->cntrl = 0;
>  		cur_p->status = 0;
>  		cur_p->app0 = 0;
> 

-- 
Robert Hancock
Senior Hardware Designer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
