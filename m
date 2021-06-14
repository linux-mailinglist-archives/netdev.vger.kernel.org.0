Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A4E3A6F62
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhFNTuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhFNTuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 15:50:21 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEBDC061574;
        Mon, 14 Jun 2021 12:48:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id CC35D4D079861;
        Mon, 14 Jun 2021 12:48:14 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:48:11 -0700 (PDT)
Message-Id: <20210614.124811.2218908588950372515.davem@davemloft.net>
To:     code@reto-schneider.ch
Cc:     devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, sr@denx.de,
        reto.schneider@husqvarnagroup.com, nbd@nbd.name, kuba@kernel.org,
        john@phrozen.org, Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, sean.wang@mediatek.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: ethernet: mtk_eth_soc: Support custom
 ifname
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210613115820.1525478-2-code@reto-schneider.ch>
References: <20210613115820.1525478-1-code@reto-schneider.ch>
        <20210613115820.1525478-2-code@reto-schneider.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 14 Jun 2021 12:48:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reto Schneider <code@reto-schneider.ch>
Date: Sun, 13 Jun 2021 13:58:19 +0200

> From: Reto Schneider <reto.schneider@husqvarnagroup.com>
> 
> Name the MAC interface name according to the label property. If the
> property is missing, the default name (ethX) gets used.
> 
> Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>

Please solve naming issues in userspace via udev, thank you.

