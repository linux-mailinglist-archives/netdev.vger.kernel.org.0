Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FC07732C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfGZVEV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Jul 2019 17:04:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfGZVEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:04:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8CF91266535F;
        Fri, 26 Jul 2019 14:04:20 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:04:20 -0700 (PDT)
Message-Id: <20190726.140420.688330328284393964.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, matthias.bgg@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mt7530: Add support for port 5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724192549.24615-4-opensource@vdorst.com>
References: <20190724192549.24615-1-opensource@vdorst.com>
        <20190724192549.24615-4-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:04:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Wed, 24 Jul 2019 21:25:49 +0200

> @@ -1167,6 +1236,10 @@ mt7530_setup(struct dsa_switch *ds)
>  	u32 id, val;
>  	struct device_node *dn;
>  	struct mt7530_dummy_poll p;
> +	phy_interface_t interface;
> +	struct device_node *mac_np;
> +	struct device_node *phy_node;
> +	const __be32 *_id;

Reverse christmas tree here please.

Thank you.
