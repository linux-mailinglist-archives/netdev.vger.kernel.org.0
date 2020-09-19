Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC86927116E
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgISXwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:52:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA29C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 16:52:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57B1C121176B8;
        Sat, 19 Sep 2020 16:35:16 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:52:02 -0700 (PDT)
Message-Id: <20200919.165202.1176888840009935961.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org, csully@google.com, yangchun@google.com
Subject: Re: [PATCH 1/3] gve: Add support for raw addressing device option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918180720.2080407-2-awogbemila@google.com>
References: <20200918180720.2080407-1-awogbemila@google.com>
        <20200918180720.2080407-2-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:35:16 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Fri, 18 Sep 2020 11:07:18 -0700

> @@ -514,10 +517,54 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>  	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
>  	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
>  		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
> -			priv->rx_pages_per_qpl);
> +			  priv->rx_pages_per_qpl);
>  		priv->rx_desc_cnt = priv->rx_pages_per_qpl;

The indentation is correct here, please don't break it.
