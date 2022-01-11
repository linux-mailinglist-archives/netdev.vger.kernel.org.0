Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECE048A62E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346948AbiAKDUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:20:04 -0500
Received: from out162-62-57-252.mail.qq.com ([162.62.57.252]:57843 "EHLO
        out162-62-57-252.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346912AbiAKDT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:19:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641871194;
        bh=RURd23KqtMbGe/E4Myn80WZkqzLdItlD/dxE3iXA694=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=E31ukhTqXIhC2HUVUwcrhCQIhKQxuAZ6fWwxKkmV1h6IGef6nOTWBsxwib3P8AEKU
         9QTy1TvRDVnB3qfeeVPdzJbHZZcRiygp/2Kmh+S//sd0mViqe4ptFki5P4dq0ZOs6o
         uJrephp6dh/ChOPagWESc3adtYxdY3SSSHPpiOoQ=
Received: from localhost ([119.32.47.91])
        by newxmesmtplogicsvrszc10.qq.com (NewEsmtp) with SMTP
        id 4F49983E; Tue, 11 Jan 2022 11:19:52 +0800
X-QQ-mid: xmsmtpt1641871192twqdkp4rm
Message-ID: <tencent_1A43F59DA700A4F4602BBA89B3C096CDC405@qq.com>
X-QQ-XMAILINFO: MpO6L0LObisWLi2ywkttVfWZLyCeJeOKuxDGnC+4Nc8PY5duow/+lRDBw/mY5z
         pLm3ZirFGpF2ou1k1XnPVRRzihCzcIkP+dZs7DFCJ20ou0xDUKCC+AevS1umIrp4LmULTl33Wuem
         6W5dxxsG8KAM2xE0/hKW423KVZnhtnk69ebGiCC6Hm5X4oCVRPDV/P6u5DJjjDbaiqZieO9qSLRT
         hz9vled51U11H2QPiBlQTzttgI0uM9zvbhOKpY1J/uiptSrI4H7lg6KXD/Db7kT9LLiOAmRDGbB3
         3LMI5ODpFoI2f0LzhdGFIEbcLL7TdgmaBAvTiZiMKBqyWbHnMIFY/Pne3y/fapeSfIQSkWmVYI8/
         GQk/ch63B8NqtmkM2HEqKzyEYNcwyHpTjD7+kzZNA/kr1i7UwSg+1hBStnQ8gwj3Ru83wLo3J5hn
         Z3Iq1UxJN+dsYZ973tHML3l0/LozeKzmdJ9g/I6HYcj60JEPzUhtr+kd4wXXurGCu1wTlKikDmN+
         6kcP/RCeWdYGrn3vL0jr75uJXTo4f99Zp9cR2JEqn3XJI90czrCLLNLEDs15TBMG9TKaL/eJ5oTX
         OwYQ6RMy+4NK8XDpmW9T/iOL/U6uG0EbBUBAYY8l+nhB17ypEyU9FnliGTU6PQZZfI3FLNZWQS4b
         vhCJJaX8yh6xCCsqWXfIyFH1jXCUw8SEDj7kU8lmZbcgztReKFbfgMSn2d7ORjQnNdndgK2mxq6z
         cnxWBz+WoK8KlvAXxaeaI/A0sfO1ICKcxoCPI0oPTGyFl21aOLli3CDVMVmKzvxiFusRkI3Ixhb9
         4NfYqDaOIIfRiofwHR6gDMTDhhLTajqFHi3LBAFWWo223MbDvJNAtofw5jXYxx6ys=
Date:   Tue, 11 Jan 2022 11:19:52 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
X-OQ-MSGID: <Ydz3WJdBVJcixPN2@fedora>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
 <Ydw7EzPvwArW/siQ@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ydw7EzPvwArW/siQ@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10/22 at 02:56下午, Corentin Labbe wrote:
> Date: Mon, 10 Jan 2022 14:56:35 +0100
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> To: Conley Lee <conleylee@foxmail.com>
> Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
>  wens@csie.org, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number
>  with macro
> 
> Le Mon, Jan 10, 2022 at 07:35:49PM +0800, Conley Lee a écrit :
> > This patch remove magic numbers in sun4i-emac.c and replace with macros
> > defined in sun4i-emac.h
> > 
> > Change since v1
> > ---------------
> > - reformat
> > - merge commits
> > - add commit message
> > 
> > Signed-off-by: Conley Lee <conleylee@foxmail.com>
> > ---
> >  drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
> >  drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
> >  2 files changed, 35 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
> > index 849de4564709..98fd98feb439 100644
> > --- a/drivers/net/ethernet/allwinner/sun4i-emac.c
> > +++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
> > @@ -106,9 +106,9 @@ static void emac_update_speed(struct net_device *dev)
> >  
> >  	/* set EMAC SPEED, depend on PHY  */
> >  	reg_val = readl(db->membase + EMAC_MAC_SUPP_REG);
> > -	reg_val &= ~(0x1 << 8);
> > +	reg_val &= ~EMAC_MAC_SUPP_100M;
> >  	if (db->speed == SPEED_100)
> > -		reg_val |= 1 << 8;
> > +		reg_val |= EMAC_MAC_SUPP_100M;
> >  	writel(reg_val, db->membase + EMAC_MAC_SUPP_REG);
> >  }
> >  
> > @@ -264,7 +264,7 @@ static void emac_dma_done_callback(void *arg)
> >  
> >  	/* re enable interrupt */
> >  	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -	reg_val |= (0x01 << 8);
> > +	reg_val |= EMAC_INT_CTL_RX_EN;
> >  	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  
> >  	db->emacrx_completed_flag = 1;
> > @@ -429,7 +429,7 @@ static unsigned int emac_powerup(struct net_device *ndev)
> >  	/* initial EMAC */
> >  	/* flush RX FIFO */
> >  	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> > -	reg_val |= 0x8;
> > +	reg_val |= EMAC_RX_CTL_FLUSH_FIFO;
> >  	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
> >  	udelay(1);
> >  
> > @@ -441,8 +441,8 @@ static unsigned int emac_powerup(struct net_device *ndev)
> >  
> >  	/* set MII clock */
> >  	reg_val = readl(db->membase + EMAC_MAC_MCFG_REG);
> > -	reg_val &= (~(0xf << 2));
> > -	reg_val |= (0xD << 2);
> > +	reg_val &= ~EMAC_MAC_MCFG_MII_CLKD_MASK;
> > +	reg_val |= EMAC_MAC_MCFG_MII_CLKD_72;
> >  	writel(reg_val, db->membase + EMAC_MAC_MCFG_REG);
> >  
> >  	/* clear RX counter */
> > @@ -506,7 +506,7 @@ static void emac_init_device(struct net_device *dev)
> >  
> >  	/* enable RX/TX0/RX Hlevel interrup */
> >  	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -	reg_val |= (0xf << 0) | (0x01 << 8);
> > +	reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
> >  	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  
> >  	spin_unlock_irqrestore(&db->lock, flags);
> > @@ -637,7 +637,9 @@ static void emac_rx(struct net_device *dev)
> >  		if (!rxcount) {
> >  			db->emacrx_completed_flag = 1;
> >  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -			reg_val |= (0xf << 0) | (0x01 << 8);
> > +			reg_val |=
> > +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> > +				 EMAC_INT_CTL_RX_EN);
> >  			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  
> >  			/* had one stuck? */
> > @@ -669,7 +671,9 @@ static void emac_rx(struct net_device *dev)
> >  			writel(reg_val | EMAC_CTL_RX_EN,
> >  			       db->membase + EMAC_CTL_REG);
> >  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -			reg_val |= (0xf << 0) | (0x01 << 8);
> > +			reg_val |=
> > +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> > +				 EMAC_INT_CTL_RX_EN);
> >  			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  
> >  			db->emacrx_completed_flag = 1;
> > @@ -783,20 +787,20 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
> >  	}
> >  
> >  	/* Transmit Interrupt check */
> > -	if (int_status & (0x01 | 0x02))
> > +	if (int_status & EMAC_INT_STA_TX_COMPLETE)
> >  		emac_tx_done(dev, db, int_status);
> >  
> > -	if (int_status & (0x04 | 0x08))
> > +	if (int_status & EMAC_INT_STA_TX_ABRT)
> >  		netdev_info(dev, " ab : %x\n", int_status);
> >  
> >  	/* Re-enable interrupt mask */
> >  	if (db->emacrx_completed_flag == 1) {
> >  		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -		reg_val |= (0xf << 0) | (0x01 << 8);
> > +		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
> >  		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  	} else {
> >  		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> > -		reg_val |= (0xf << 0);
> > +		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN);
> >  		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> >  	}
> >  
> > diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.h b/drivers/net/ethernet/allwinner/sun4i-emac.h
> > index 38c72d9ec600..90bd9ad77607 100644
> > --- a/drivers/net/ethernet/allwinner/sun4i-emac.h
> > +++ b/drivers/net/ethernet/allwinner/sun4i-emac.h
> > @@ -38,6 +38,7 @@
> >  #define EMAC_RX_CTL_REG		(0x3c)
> >  #define EMAC_RX_CTL_AUTO_DRQ_EN		(1 << 1)
> >  #define EMAC_RX_CTL_DMA_EN		(1 << 2)
> > +#define EMAC_RX_CTL_FLUSH_FIFO		(1 << 3)
> >  #define EMAC_RX_CTL_PASS_ALL_EN		(1 << 4)
> >  #define EMAC_RX_CTL_PASS_CTL_EN		(1 << 5)
> >  #define EMAC_RX_CTL_PASS_CRC_ERR_EN	(1 << 6)
> > @@ -61,7 +62,21 @@
> >  #define EMAC_RX_IO_DATA_STATUS_OK	(1 << 7)
> >  #define EMAC_RX_FBC_REG		(0x50)
> >  #define EMAC_INT_CTL_REG	(0x54)
> > +#define EMAC_INT_CTL_RX_EN	(1 << 8)
> > +#define EMAC_INT_CTL_TX0_EN	(1)
> > +#define EMAC_INT_CTL_TX1_EN	(1 << 1)
> > +#define EMAC_INT_CTL_TX_EN	(EMAC_INT_CTL_TX0_EN | EMAC_INT_CTL_TX1_EN)
> > +#define EMAC_INT_CTL_TX0_ABRT_EN	(0x1 << 2)
> > +#define EMAC_INT_CTL_TX1_ABRT_EN	(0x1 << 3)
> > +#define EMAC_INT_CTL_TX_ABRT_EN	(EMAC_INT_CTL_TX0_ABRT_EN | EMAC_INT_CTL_TX1_ABRT_EN)
> >  #define EMAC_INT_STA_REG	(0x58)
> > +#define EMAC_INT_STA_TX0_COMPLETE	(0x1)
> > +#define EMAC_INT_STA_TX1_COMPLETE	(0x1 << 1)
> > +#define EMAC_INT_STA_TX_COMPLETE	(EMAC_INT_STA_TX0_COMPLETE | EMAC_INT_STA_TX1_COMPLETE)
> > +#define EMAC_INT_STA_TX0_ABRT	(0x1 << 2)
> > +#define EMAC_INT_STA_TX1_ABRT	(0x1 << 3)
> > +#define EMAC_INT_STA_TX_ABRT	(EMAC_INT_STA_TX0_ABRT | EMAC_INT_STA_TX1_ABRT)
> > +#define EMAC_INT_STA_RX_COMPLETE	(0x1 << 8)
> 
> Hello
> 
> As proposed by checkpatch, I thing there are several place (like all EMAC_INT_STA) where you could use BIT(x) instead of (0xX << x)
> 
> Regards
Hi ~ 
Thanks for your suggestion. But I think it might be better to keep the code style consistent,
so I didn't change it in the new version of this patch.
