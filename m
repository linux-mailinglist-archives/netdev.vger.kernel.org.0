Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BAF1A198D
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDHB3j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Apr 2020 21:29:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgDHB3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:29:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC4AA1210A3E5;
        Tue,  7 Apr 2020 18:29:36 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:29:36 -0700 (PDT)
Message-Id: <20200407.182936.1103575868210940131.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, Landen.Chao@mediatek.com,
        steven.liu@mediatek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        opensource@vdorst.com
Subject: Re: [PATCH v2 net 2/2] net: ethernet: mediatek: move mt7623
 settings out off the mt7530
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1586122974-22125-2-git-send-email-sean.wang@mediatek.com>
References: <1586122974-22125-1-git-send-email-sean.wang@mediatek.com>
        <1586122974-22125-2-git-send-email-sean.wang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:29:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sean.wang@mediatek.com>
Date: Mon, 6 Apr 2020 05:42:54 +0800

> From: René van Dorst <opensource@vdorst.com>
> 
> Moving mt7623 logic out off mt7530, is required to make hardware setting
> consistent after we introduce phylink to mtk driver.
> 
> Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
> Reviewed-by: Sean Wang <sean.wang@mediatek.com>
> Tested-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> ---
> v1 -> v2: split out logic changing mtk_gmac0_rgmii_adjust that should be
> 	  refined further and actualy belonged to separate patch.

Applied.
