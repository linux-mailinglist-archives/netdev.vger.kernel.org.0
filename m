Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0D233CA2
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgGaAkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730980AbgGaAkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:40:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD063C061574;
        Thu, 30 Jul 2020 17:40:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D159126C48CE;
        Thu, 30 Jul 2020 17:23:51 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:40:35 -0700 (PDT)
Message-Id: <20200730.174035.2300770809021086660.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     joe@perches.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] liquidio: Replace vmalloc with kmalloc in
 octeon_register_dispatch_fn()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730061140.20223-1-wanghai38@huawei.com>
References: <20200730061140.20223-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:23:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Thu, 30 Jul 2020 14:11:40 +0800

> The size of struct octeon_dispatch is too small, it is better to use
> kmalloc instead of vmalloc.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied, thank you.
