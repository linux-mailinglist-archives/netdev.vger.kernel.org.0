Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7169E273768
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgIVA2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgIVA2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:28:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74E2C061755;
        Mon, 21 Sep 2020 17:28:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F398E12788D3C;
        Mon, 21 Sep 2020 17:11:53 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:28:40 -0700 (PDT)
Message-Id: <20200921.172840.49240469777318612.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        objelf@gmail.com, steven.liu@mediatek.com, Landen.Chao@mediatek.com
Subject: Re: [PATCH net-next] net: Update MAINTAINERS for MediaTek switch
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5d601ae7347d49268822356121d5388739311459.1600729601.git.objelf@gmail.com>
References: <5d601ae7347d49268822356121d5388739311459.1600729601.git.objelf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:11:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sean.wang@mediatek.com>
Date: Tue, 22 Sep 2020 07:09:23 +0800

> From: Sean Wang <objelf@gmail.com>
> 
> Update maintainers for MediaTek switch driver with Landen Chao who is
> familiar with MediaTek MT753x switch devices and will help maintenance
> from the vendor side.
> 
> Cc: Steven Liu <steven.liu@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Landen Chao <Landen.Chao@mediatek.com>

Applied to 'net' as it's important to have the mainline MAINTAINERS
information as uptodate as possible.

Thanks.
