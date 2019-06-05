Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A893136365
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFESep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:34:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFESeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:34:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA20B1510A33F;
        Wed,  5 Jun 2019 11:34:43 -0700 (PDT)
Date:   Wed, 05 Jun 2019 11:34:41 -0700 (PDT)
Message-Id: <20190605.113441.1657641162705180640.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, blogic@openwrt.org, nbd@openwrt.org,
        nelson.chang@mediatek.com, lkp@intel.com
Subject: Re: [PATCH -next] net: ethernet: mediatek: fix mtk_eth_soc build
 errors & warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559726369.9003.4.camel@mtkswgap22>
References: <85d9fdd9-4b7f-6a51-b885-b3a43f199ec9@infradead.org>
        <1559726369.9003.4.camel@mtkswgap22>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 11:34:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>
Date: Wed, 5 Jun 2019 17:19:29 +0800

> Thanks for your help.  But it seems I've already made the same fixup
> for the problem in
> http://lists.infradead.org/pipermail/linux-mediatek/2019-June/020301.html
> as soon as the kbuild test robot reported this.

No, that's not how this works.

You fix networking build fixes by sending the fix here to netdev.

Randy submitted the fix properly, so I'm applying his patch to my
tree.
