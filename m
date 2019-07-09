Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3163D2D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfGIVSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:18:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGIVSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:18:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17C41141FD118;
        Tue,  9 Jul 2019 14:18:20 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:18:19 -0700 (PDT)
Message-Id: <20190709.141819.2176127473515467438.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.com, boon.leong.ong@intel.com
Subject: Re: [PATCH 0/2 net-next] fix out-of-boundary issue and add taller
 hash table support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709023623.8358-1-biao.huang@mediatek.com>
References: <20190709023623.8358-1-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:18:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Tue, 9 Jul 2019 10:36:21 +0800

> Fix mac address out-of-boundary issue in net-next tree.
> and resend the patch which was discussed in
> https://lore.kernel.org/patchwork/patch/1082117
> but with no further progress.

Series applied, thanks.
