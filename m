Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D542AA0AE1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 21:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfH1T5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 15:57:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfH1T5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 15:57:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60DD315341640;
        Wed, 28 Aug 2019 12:56:59 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:56:58 -0700 (PDT)
Message-Id: <20190828.125658.1743313522645522716.davem@davemloft.net>
To:     matthias.bgg@gmail.com
Cc:     opensource@vdorst.com, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        linux@armlinux.org.uk, frank-w@public-files.de, sr@denx.de
Subject: Re: [PATCH net-next v4 3/3] dt-bindings: net: ethernet: Update
 mt7622 docs and dts to reflect the new phylink API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e45565b1-bb63-66af-16f6-5c7c1094dd67@gmail.com>
References: <20190825174341.20750-1-opensource@vdorst.com>
        <20190825174341.20750-4-opensource@vdorst.com>
        <e45565b1-bb63-66af-16f6-5c7c1094dd67@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 12:56:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>
Date: Wed, 28 Aug 2019 11:29:45 +0200

> Thanks for taking this patch. For the next time, please make sure that dts[i]
> patches are independent from the binding description, as dts[i] should go
> through my tree. No problem for this round, just saying for the future.

That's not always possible nor reasonable, to be quite honest.
