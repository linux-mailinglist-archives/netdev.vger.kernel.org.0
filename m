Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C900217B1E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgGGWmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGWmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:42:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9B7C061755;
        Tue,  7 Jul 2020 15:42:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2229120F19EC;
        Tue,  7 Jul 2020 15:42:05 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:42:05 -0700 (PDT)
Message-Id: <20200707.154205.2251580524222701764.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] bnx2x: fix spelling mistake "occurd" ->
 "occurred"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706121240.486132-1-colin.king@canonical.com>
References: <20200706121240.486132-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:42:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  6 Jul 2020 13:12:40 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are spelling mistakes in various literal strings. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
