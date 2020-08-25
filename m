Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C3251996
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHYN2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHYN2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:28:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C77C061574;
        Tue, 25 Aug 2020 06:28:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4DDF11E45768;
        Tue, 25 Aug 2020 06:11:24 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:28:10 -0700 (PDT)
Message-Id: <20200825.062810.532289828451334856.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: clean up codestyle for net/ipv4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825123211.33235-1-linmiaohe@huawei.com>
References: <20200825123211.33235-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 06:11:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Tue, 25 Aug 2020 08:32:11 -0400

> This is a pure codestyle cleanup patch. Also add a blank line after
> declarations as warned by checkpatch.pl.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to net-next.
