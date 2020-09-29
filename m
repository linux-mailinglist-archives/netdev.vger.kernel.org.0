Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23C27BA7D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgI2BuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:50:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE3FC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:50:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3783127C6C1E;
        Mon, 28 Sep 2020 18:33:33 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:50:20 -0700 (PDT)
Message-Id: <20200928.185020.239065830030111620.davem@davemloft.net>
To:     kevinbrace@gmx.com
Cc:     netdev@vger.kernel.org, kevinbrace@bracecomputerlab.com
Subject: Re: [PATCH net 4/4] via-rhine: Version bumped to 1.5.2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928220041.6654-5-kevinbrace@gmx.com>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
        <20200928220041.6654-5-kevinbrace@gmx.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:33:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@gmx.com>
Date: Mon, 28 Sep 2020 15:00:41 -0700

> @@ -32,8 +32,8 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
>  #define DRV_NAME	"via-rhine"
> -#define DRV_VERSION	"1.5.1"
> -#define DRV_RELDATE	"2010-10-09"
> +#define DRV_VERSION	"1.5.2"
> +#define DRV_RELDATE	"2020-09-18"

Driver versions like this are deprecated and we are removing them
from every driver.

Please remove, rather than update, such values.

Thank you.
