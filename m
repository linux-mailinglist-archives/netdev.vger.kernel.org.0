Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A196F2459CF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgHPWPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHPWPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:15:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A289C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:15:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBF65135EDBF7;
        Sun, 16 Aug 2020 14:58:50 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:15:35 -0700 (PDT)
Message-Id: <20200816.151535.1210493160709433775.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        mahesh@bandewar.net
Subject: Re: [PATCH net] ipvlan: fix device features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815055324.3361890-1-maheshb@google.com>
References: <20200815055324.3361890-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 14:58:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Fri, 14 Aug 2020 22:53:24 -0700

> Processing NETDEV_FEAT_CHANGE causes IPvlan links to lose
> NETIF_F_LLTX feature because of the incorrect handling of
> features in ipvlan_fix_features().
 ...
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied and queued up for -stable, thank you.
