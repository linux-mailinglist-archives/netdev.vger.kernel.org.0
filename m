Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0386733A225
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhCNBOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 20:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNBN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 20:13:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE43C061574;
        Sat, 13 Mar 2021 17:13:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j3so13227409edp.11;
        Sat, 13 Mar 2021 17:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=25n/2PNhVp9stMzk432q2p3t56Gx2STp/u0k2dquk5s=;
        b=TZn+/tVPwCVrX5MzexTPRzdJ2LaXWZHShN/+Sb+D6O+6cdG3M25Lb32OuQOncgjZ08
         mgj8G5FaOU9lDC07lZF1H6ZidHgmVV7KpshBw0JLs2TrHHumtMgPu9HzqsIDxcFy8Iz6
         rnH3ypwXdXbEkkcKHgMissAMmj5wG3uUOZlvCuyt/c4dTisz0flvjsSzXXQgKoo//Ve+
         UDZCZGHqYOz2dlXVP22/uoafCrOpIroysT61aHzzi5wJN/2Ix+YT7iOw5j2BY2RLEOKY
         /eQwG9XNtsFhq7UVHJdZjF9bEwzmSNCaAzMMzkr5bEPC2mQRL+w8gpfVax6QnzoPP+nT
         Bhzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=25n/2PNhVp9stMzk432q2p3t56Gx2STp/u0k2dquk5s=;
        b=LfZiY1NATl5ZPFQCJyPGinzj8xFE4qfQNwut8vDZJtS7ZzHmakHYm0dqzAz2DeEwM/
         RLjPd2w9QksmsU18prOOQO4KZs8Y53ZrSs0l1vFGNdpk5kJIsTxxgTDfcpyklv/iaQDg
         BnOPic97RrxJfRyQQ+bvz7bMg2x/xtsKXChz+UqvoG9n0lNa36OOaQnCaNh/n42kqXHz
         SMIvTyKirPdc44PgVRmKtlOeXn0SJCYLntbzh9slv+qTZvLJzS+YLqc7YkQ4kaJ12a5A
         97U2+M+O3a7FDosVdhawm6y3FnZMfrDpH0DjG/Kai8QVuUm5Yt86qrCCz/ZZjjMEhNXq
         cFuQ==
X-Gm-Message-State: AOAM531BjVT8zS5O0n7HqxcOt7gQSbpabkhtWWCUuO5PxYiwebTo6PxQ
        H5rQXQXqYYhTK9F3/OLAk/pEsdzELRw=
X-Google-Smtp-Source: ABdhPJw/dTunBqmQ5wkCs5/zCbX6ED/N1sDXhvUUQO2vIzX4OC0aIVhCVGyhpSS1DosaJMPkxDX8vg==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr22105955edb.71.1615684408042;
        Sat, 13 Mar 2021 17:13:28 -0800 (PST)
Received: from BV030612LT ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id v8sm3664207edc.30.2021.03.13.17.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 17:13:26 -0800 (PST)
Date:   Sun, 14 Mar 2021 03:13:24 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210314011324.GA991090@BV030612LT>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
 <YEwO33TR7ENHuMaY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEwO33TR7ENHuMaY@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for the detailed review!

On Sat, Mar 13, 2021 at 02:01:19AM +0100, Andrew Lunn wrote:
> On Thu, Mar 11, 2021 at 03:20:13AM +0200, Cristian Ciocaltea wrote:
> > +static inline void owl_emac_reg_set(struct owl_emac_priv *priv,
> > +				    u32 reg, u32 bits)
> > +{
> > +	owl_emac_reg_update(priv, reg, bits, bits);
> > +}
> 
> Hi Cristian
> 
> No inline functions in C files please. Let the compiler decide. Please
> fix them all.

Sure.

> > +static struct sk_buff *owl_emac_alloc_skb(struct net_device *netdev)
> > +{
> > +	int offset;
> > +	struct sk_buff *skb;
> 
> Reverse Christmas tree please.

Already fixed this and all the others I could find.

> > +
> > +	skb = netdev_alloc_skb(netdev, OWL_EMAC_RX_FRAME_MAX_LEN +
> > +			       OWL_EMAC_SKB_RESERVE);
> > +	if (unlikely(!skb))
> > +		return NULL;
> > +
> > +	/* Ensure 4 bytes DMA alignment. */
> > +	offset = ((uintptr_t)skb->data) & (OWL_EMAC_SKB_ALIGN - 1);
> > +	if (unlikely(offset))
> > +		skb_reserve(skb, OWL_EMAC_SKB_ALIGN - offset);
> > +
> > +	return skb;
> > +}
> > +
> > +static void owl_emac_phy_config(struct owl_emac_priv *priv)
> 
> You are not really configuring the PHY here, but configuring the MAC
> with what the PHY tells you has been negotiated. So maybe change this
> name?

Right, this was an uninspired choice on my side! I think something like
'owl_emac_update_link_state' would be more appropriate..

> > +{                                                                   
> > +   u32 val, status;                                                 
> > +                                                                    
> > +   if (priv->pause) {                                               
> > +       val = OWL_EMAC_BIT_MAC_CSR20_FCE | OWL_EMAC_BIT_MAC_CSR20_TUE;
> > +       val |= OWL_EMAC_BIT_MAC_CSR20_TPE | OWL_EMAC_BIT_MAC_CSR20_RPE;
> > +       val |= OWL_EMAC_BIT_MAC_CSR20_BPE;                           
> > +   } else {                                                         
> > +       val = 0;                                                     
> > +   }                                                                
> > +                                                                    
> > +   /* Update flow control. */                                       
> > +   owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR20, val);           

[...]

> > +static inline void owl_emac_ether_addr_push(u8 **dst, const u8 *src)
> > +{
> > +	u32 *a = (u32 *)(*dst);
> 
> Is *dst guaranteed to by 32bit aligned? Given that it is skb->data, i
> don't think it is.
> 
> > +	const u16 *b = (const u16 *)src;
> > +
> > +	a[0] = b[0];
> > +	a[1] = b[1];
> > +	a[2] = b[2];
> 
> So i don't know if this is safe. Some architectures don't like doing
> miss aligned read/writes. You probably should be using one of the
> put_unaligned_() macros.

Actually skb->data is 32bit aligned, as required by the MAC hardware
for DMA access - please see 'owl_emac_alloc_skb()'.

> > +
> > +	*dst += 12;
> > +}
> > +
> > +static void
> > +owl_emac_setup_frame_prepare(struct owl_emac_priv *priv, struct sk_buff *skb)
> > +{
> > +	const u8 bcast_addr[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
> > +	const u8 *mac_addr = priv->netdev->dev_addr;
> > +	u8 *frame;
> > +	int i;
> > +
> > +	skb_put(skb, OWL_EMAC_SETUP_FRAME_LEN);
> > +
> > +	frame = skb->data;
> > +	memset(frame, 0, skb->len);
> > +
> > +	owl_emac_ether_addr_push(&frame, mac_addr);
> > +	owl_emac_ether_addr_push(&frame, bcast_addr);
> > +
> > +	/* Fill multicast addresses. */
> > +	WARN_ON(priv->mcaddr_list.count >= OWL_EMAC_MAX_MULTICAST_ADDRS);
> > +	for (i = 0; i < priv->mcaddr_list.count; i++) {
> > +		mac_addr = priv->mcaddr_list.addrs[i];
> > +		owl_emac_ether_addr_push(&frame, mac_addr);
> > +	}
> 
> Please could you add some comments to this. You are building a rather
> odd frame here! What is it used form?

Yes, I actually planned to document this but eventually I missed it.
The setup frames are special descriptors used to provide physical
addresses to the MAC hardware for filtering purposes.

[...]

> > +static void owl_emac_mdio_clock_enable(struct owl_emac_priv *priv)
> > +{
> > +	u32 val;
> > +
> > +	/* Enable MDC clock generation by setting CLKDIV to at least 128. */
> 
> You should be aiming for 2.5MHz bus clock. Does this depend on the
> speed of one of the two clocks you have? Maybe you can dynamically
> calculate the divider?

Unfortunately this is not properly documented in the datasheet, so I
cannot tell which is the reference clock for the MDC clock divider.
With the current approach (taken from the old vendor driver code), the
divider is actually set to 1024 (obtained by OR-ing the HW default with
this "magic" 128 correspondent).

What I know for sure is that 'eth' clock has a fixed rate (25MHz), while
'rmii' is set by the driver to 50MHz, both of them having a 500MHz PLL
clock as parent. Hence if the information in the datasheet is correct
regarding the MDC divider settings, I would assume none of those two
clocks could be used as direct reference for MDC clock output, unless
there is a more complex logic behind than a simple clock divider (e.g.
maybe using a factor clock?!)

For the moment, I'm going to provide an updated comment:

	/* Enable MDC clock generation by adjusting CLKDIV according to
	 * the implementation of the original (old) vendor driver code.

> > +	val = owl_emac_reg_read(priv, OWL_EMAC_REG_MAC_CSR10);
> > +	val &= OWL_EMAC_MSK_MAC_CSR10_CLKDIV;
> > +	val |= OWL_EMAC_VAL_MAC_CSR10_CLKDIV_128 << OWL_EMAC_OFF_MAC_CSR10_CLKDIV;
> > +
> > +	val |= OWL_EMAC_BIT_MAC_CSR10_SB;
> > +	val |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_CDS << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
> > +	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR10, val);
> > +}
> 
> > +static int owl_emac_phy_init(struct net_device *netdev)
> > +{
> > +	struct owl_emac_priv *priv = netdev_priv(netdev);
> > +	struct device *dev = owl_emac_get_dev(priv);
> > +	struct phy_device *phy;
> > +
> > +	phy = of_phy_get_and_connect(netdev, dev->of_node,
> > +				     owl_emac_adjust_link);
> > +	if (!phy)
> > +		return -ENODEV;
> > +
> > +	if (phy->interface != PHY_INTERFACE_MODE_RMII) {
> > +		netdev_err(netdev, "unsupported phy mode: %s\n",
> > +			   phy_modes(phy->interface));
> > +		phy_disconnect(phy);
> > +		netdev->phydev = NULL;
> > +		return -EINVAL;
> > +	}
> 
> It looks like the MAC only supports symmetric pause. So you should
> call phy_set_sym_pause() to let the PHY know this.

I did not find any reference related to the supported pause types,
is this normally dependant on the PHY interface mode?

The MAC hardware also supports SMII, but I haven't enabled it in the
driver, yet, since I cannot validate this with my SBC.

Can/should I still provide the SMII support in this context?

> > +
> > +	if (netif_msg_link(priv))
> > +		phy_attached_info(phy);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Generate the MAC address based on the system serial number.
> > + */
> > +static int owl_emac_generate_mac_addr(struct net_device *netdev)
> > +{
> > +	int ret = -ENXIO;
> > +
> > +#ifdef CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN
> > +	struct device *dev = netdev->dev.parent;
> > +	struct crypto_sync_skcipher *tfm;
> > +	struct scatterlist sg;
> > +	const u8 key[] = { 1, 4, 13, 21, 59, 67, 69, 127 };
> > +	u64 sn;
> > +	u8 enc_sn[sizeof(key)];
> > +
> > +	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
> > +
> > +	sn = ((u64)system_serial_high << 32) | system_serial_low;
> > +	if (!sn)
> > +		return ret;
> > +
> > +	tfm = crypto_alloc_sync_skcipher("ecb(des)", 0, 0);
> > +	if (IS_ERR(tfm)) {
> > +		dev_err(dev, "failed to allocate cipher: %ld\n", PTR_ERR(tfm));
> > +		return PTR_ERR(tfm);
> > +	}
> > +
> > +	ret = crypto_sync_skcipher_setkey(tfm, key, sizeof(key));
> > +	if (ret) {
> > +		dev_err(dev, "failed to set cipher key: %d\n", ret);
> > +		goto err_free_tfm;
> > +	}
> > +
> > +	memcpy(enc_sn, &sn, sizeof(enc_sn));
> > +
> > +	sg_init_one(&sg, enc_sn, sizeof(enc_sn));
> > +	skcipher_request_set_sync_tfm(req, tfm);
> > +	skcipher_request_set_callback(req, 0, NULL, NULL);
> > +	skcipher_request_set_crypt(req, &sg, &sg, sizeof(enc_sn), NULL);
> > +
> > +	ret = crypto_skcipher_encrypt(req);
> > +	if (ret) {
> > +		dev_err(dev, "failed to encrypt S/N: %d\n", ret);
> > +		goto err_free_tfm;
> > +	}
> > +
> > +	netdev->dev_addr[0] = 0xF4;
> > +	netdev->dev_addr[1] = 0x4E;
> > +	netdev->dev_addr[2] = 0xFD;
> 
> 0xF4 has the locally administered bit 0. So this is a true OUI. Who
> does it belong to? Ah!
> 
> F4:4E:FD Actions Semiconductor Co.,Ltd.(Cayman Islands)
> 
> Which makes sense. But is there any sort of agreement this is allowed?
> It is going to cause problems if they are giving out these MAC
> addresses in a controlled way.

Unfortunately this is another undocumented logic taken from the vendor
code. I have already disabled it from being built by default, although,
personally, I prefer to have it enabled in order to get a stable MAC
address instead of using a randomly generated one or manually providing
it via DT.

Just for clarification, I did not have any agreement or preliminary
discussion with the vendor. This is just a personal initiative to
improve the Owl SoC support in the mainline kernel.

> Maybe it would be better to set bit 1 of byte 0? And then you can use
> 5 bytes from enc_sn, not just 4.

I included the MAC generation feature in the driver to be fully
compatible with the original implementation, but I'm open for changes
if it raises concerns and compatibility is less important.

> > +	netdev->dev_addr[3] = enc_sn[0];
> > +	netdev->dev_addr[4] = enc_sn[4];
> > +	netdev->dev_addr[5] = enc_sn[7];
> > +
> > +err_free_tfm:
> > +	crypto_free_sync_skcipher(tfm);
> > +#endif /* CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN */
> > +
> > +	return ret;
> > +}
> 
> > +static int owl_emac_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct net_device *netdev;
> > +	struct owl_emac_priv *priv;
> > +	int ret, i;

[...]

> > +	ret = clk_set_rate(priv->clks[OWL_EMAC_CLK_RMII].clk, 50000000);
> > +	if (ret) {
> > +		dev_err(dev, "failed to set RMII clock rate: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = devm_add_action_or_reset(dev, owl_emac_clk_disable_unprepare, priv);
> > +	if (ret)
> > +		return ret;
> 
> Maybe this should go before the clk_set_rate(), just in case it fail?

Indeed, I missed this, thanks for spotting it out!

> Otherwise, this look a new clean driver.

Well, I tried to do my best, given my limited experience as a self-taught
kernel developer. Hopefully reviewing my code will not cause too many
headaches! :)

> 	   Andrew

Kind regards,
Cristi
