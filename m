Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9536248F8B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgHRUSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgHRUST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:18:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A619C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:18:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB7EF127B4201;
        Tue, 18 Aug 2020 13:01:32 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:18:18 -0700 (PDT)
Message-Id: <20200818.131818.1808468591889996886.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org, csully@google.com, yangchun@google.com
Subject: Re: [PATCH net-next 10/18] gve: Add support for raw addressing to
 the rx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818194417.2003932-11-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-11-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 13:01:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Tue, 18 Aug 2020 12:44:09 -0700

>  static void gve_rx_free_ring(struct gve_priv *priv, int idx)
>  {
>  	struct gve_rx_ring *rx = &priv->rx[idx];
>  	struct device *dev = &priv->pdev->dev;
>  	size_t bytes;
> -	u32 slots;
> +	u32 slots = rx->mask + 1;

Reverse christmas tree ordering for local variables please.
