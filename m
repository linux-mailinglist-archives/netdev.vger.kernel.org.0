Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383A13B7806
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhF2SvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhF2SvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:51:11 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F653C061760;
        Tue, 29 Jun 2021 11:48:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BC0064F7C60DD;
        Tue, 29 Jun 2021 11:48:40 -0700 (PDT)
Date:   Tue, 29 Jun 2021 11:48:35 -0700 (PDT)
Message-Id: <20210629.114835.1579053754504134348.davem@davemloft.net>
To:     hkelam@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com
Subject: Re: [net-next Patch v2 0/3] DMAC based packet filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210629122033.10051-1-hkelam@marvell.com>
References: <20210629122033.10051-1-hkelam@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 29 Jun 2021 11:48:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Patch #1 creates kdoc warnings:

drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h:43: warning: Function parameter or member 'mcast_filters_count' not described in 'lmac'
New warnings added
0a1
> drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h:43: warning: Function parameter or member 'mcast_filters_count' not described in 'lmac'

Please fix and resubmit, thank you.
