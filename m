Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18409C0F2
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfHXXTP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Aug 2019 19:19:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXXTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:19:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E0F91525F715;
        Sat, 24 Aug 2019 16:19:14 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:19:12 -0700 (PDT)
Message-Id: <20190824.161912.1377369658338940538.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     sean.wang@mediatek.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        linux-mips@vger.kernel.org, frank-w@public-files.de
Subject: Re: [PATCH net-next v2 3/3] net: dsa: mt7530: Add support for port
 5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821144547.15113-4-opensource@vdorst.com>
References: <20190821144547.15113-1-opensource@vdorst.com>
        <20190821144547.15113-4-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:19:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Wed, 21 Aug 2019 16:45:47 +0200

> +	dev_info(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
> +		 val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));

This is debugging, at best.  Please make this a debugging message or
remove it entirely.
