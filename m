Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03019118E20
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLJQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:49:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbfLJQtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iOz/6/0r92zuFKGcrFy7F2rvroSXU33rpP0w5fe4E3U=; b=IIdANMqMHtcM+54gM190UsDtPk
        SUHzsAqkxb4XGBvxmuA1c515zloQfMWEiXz+Oj3/kwS8lswkNGoCf6E1PKE7C/RqA1LItg1GwPRMc
        lff4LzwcffjJCBLQcQUCjNA+XiU05arpHnchX8RWm1i6ANWPAspUmaGSYpdmNIGBx4JA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieigx-0005Pm-P1; Tue, 10 Dec 2019 17:48:55 +0100
Date:   Tue, 10 Dec 2019 17:48:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        matthias.bgg@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of MT7531
 switch
Message-ID: <20191210164855.GE27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mt7531_setup(struct dsa_switch *ds)
> +{
> +	/* Enable PHY power, since phy_device has not yet been created
> +	 * provided for phy_[read,write]_mmd_indirect is called, we provide
> +	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
> +	 * function.
> +	 */
> +	val = mt7531_ind_mmd_phy_read(priv, 0, PHY_DEV1F,
> +				      MT7531_PHY_DEV1F_REG_403);
> +	val |= MT7531_PHY_EN_BYPASS_MODE;
> +	val &= ~MT7531_PHY_POWER_OFF;
> +	mt7531_ind_mmd_phy_write(priv, 0, PHY_DEV1F,
> +				 MT7531_PHY_DEV1F_REG_403, val);
> +

Is this power to all the PHYs? Or just one?

   Andrew
