Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB427B7F4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgI1XTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgI1XSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:18:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CFBC0613D4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 14:59:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 936D011E3E4CE;
        Mon, 28 Sep 2020 14:42:12 -0700 (PDT)
Date:   Mon, 28 Sep 2020 14:58:59 -0700 (PDT)
Message-Id: <20200928.145859.599173570118920472.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH v2 net-next] net: mvneta: try to use in-irq pp cache in
 mvneta_txq_bufs_free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d1fd2d8908c949c7469b78d0d6b6a4b9ac43aa94.1601042644.git.lorenzo@kernel.org>
References: <d1fd2d8908c949c7469b78d0d6b6a4b9ac43aa94.1601042644.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 14:42:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 25 Sep 2020 16:09:11 +0200

> Try to recycle the xdp tx buffer into the in-irq page_pool cache if
> mvneta_txq_bufs_free is executed in the NAPI context for XDP_TX use case
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - run xdp_return_frame_rx_napi for XDP_TX only

Applied, thank you.
