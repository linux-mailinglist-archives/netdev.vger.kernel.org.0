Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09EF7C7A6
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfGaPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:53:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfGaPxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:53:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 135E1140505AC;
        Wed, 31 Jul 2019 08:53:38 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:53:37 -0700 (PDT)
Message-Id: <20190731.085337.207327464892923101.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: mediatek: Drop unneeded dependency on
 NET_VENDOR_MEDIATEK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731131202.16749-1-geert+renesas@glider.be>
References: <20190731131202.16749-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:53:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Wed, 31 Jul 2019 15:12:02 +0200

> The whole block is protected by "if NET_VENDOR_MEDIATEK", so there is
> no need for individual driver config symbols to duplicate this
> dependency.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied.
