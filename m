Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3478B1F00C3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgFEUIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgFEUIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:08:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1025C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 13:08:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DDD3127AF904;
        Fri,  5 Jun 2020 13:08:20 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:08:17 -0700 (PDT)
Message-Id: <20200605.130817.2097884782287897002.davem@davemloft.net>
To:     tseewald@gmail.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, kuba@kernel.org
Subject: Re: [PATCH v2] cxgb4: Fix 'defined but not used' warning for
 cxgb4_uld_in_use()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605013632.781-1-tseewald@gmail.com>
References: <20200605000748.31442-1-tseewald@gmail.com>
        <20200605013632.781-1-tseewald@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:08:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>
Date: Thu,  4 Jun 2020 20:36:32 -0500

> The only user of cxgb4_uld_in_use() is cxgb4_set_ktls_feature() which is
> only available when CONFIG_CHELSIO_TLS_DEVICE=y. To avoid this compiler
> warning when CONFIG_CHELSIO_TLS_DEVICE=n, place cxgb4_uld_in_use() behind
> the same ifdef.
> 
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

This doesn't apply to the net GIT tree.
