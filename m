Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3D231697
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgG2AFt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jul 2020 20:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2AFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:05:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDB0C061794;
        Tue, 28 Jul 2020 17:05:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E07E4128D304D;
        Tue, 28 Jul 2020 16:49:02 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:05:47 -0700 (PDT)
Message-Id: <20200728.170547.454266815690646224.davem@davemloft.net>
To:     dwmw2@infradead.org
Cc:     frank-w@public-files.de, sean.wang@mediatek.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Mark-MC.Lee@mediatek.com, john@phrozen.org,
        Landen.Chao@mediatek.com, steven.liu@mediatek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource@vdorst.com, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: Always call
 mtk_gmac0_rgmii_adjust() for mt7623
From:   David Miller <davem@davemloft.net>
In-Reply-To: <52f10e30f62b8521fd83525a03ecff94b72d509b.camel@infradead.org>
References: <trinity-fb0cdf15-dfcf-4d60-9144-87d8fbfad5ba-1586179542451@3c-app-gmx-bap62>
        <52f10e30f62b8521fd83525a03ecff94b72d509b.camel@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:49:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 23 Jul 2020 20:07:10 +0100

> From: René van Dorst <opensource@vdorst.com>
> 
> Modify mtk_gmac0_rgmii_adjust() so it can always be called.
> mtk_gmac0_rgmii_adjust() sets-up the TRGMII clocks.
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Signed-off-By: David Woodhouse <dwmw2@infradead.org>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>

Applied.
