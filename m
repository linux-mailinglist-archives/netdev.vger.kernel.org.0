Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF30D21FFBB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgGNVMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgGNVMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:12:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341ABC061755;
        Tue, 14 Jul 2020 14:12:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B6B915E2E748;
        Tue, 14 Jul 2020 14:12:00 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:11:59 -0700 (PDT)
Message-Id: <20200714.141159.1780768034773147896.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jes@trained-monkey.org, kuba@kernel.org, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] hippi: Fix a size used in a 'pci_free_consistent()' in
 an error handling path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714110027.301728-1-christophe.jaillet@wanadoo.fr>
References: <20200714110027.301728-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:12:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue, 14 Jul 2020 13:00:27 +0200

> The size used when calling 'pci_alloc_consistent()' and
> 'pci_free_consistent()' should match.
> 
> Fix it and have it consistent with the corresponding call in 'rr_close()'.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thank you.
