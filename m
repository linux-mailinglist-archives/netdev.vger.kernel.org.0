Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF53215FC8
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGFT7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgGFT7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:59:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C7BC061755;
        Mon,  6 Jul 2020 12:59:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8380E120ED49A;
        Mon,  6 Jul 2020 12:59:17 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:59:16 -0700 (PDT)
Message-Id: <20200706.125916.1531643056527635516.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net/amd: Remove needless assignment and the extra
 brank lines
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706144701.7500-1-tangbin@cmss.chinamobile.com>
References: <20200706144701.7500-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:59:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Mon,  6 Jul 2020 22:47:01 +0800

> The variable 'err = -ENODEV;' in au1000_probe() is
> duplicate, so remove redundant one. And remove the
> extra blank lines in the file au1000_eth.c
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Applied to net-next, thanks.
