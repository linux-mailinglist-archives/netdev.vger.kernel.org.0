Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC40C1C61DB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgEEUQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEUQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:16:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11096C061A0F;
        Tue,  5 May 2020 13:16:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8F901280BC3C;
        Tue,  5 May 2020 13:16:53 -0700 (PDT)
Date:   Tue, 05 May 2020 13:16:52 -0700 (PDT)
Message-Id: <20200505.131652.1946015805247904067.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     vishal@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] cxgb4/cxgb4vf: Remove superfluous void * cast
 in debugfs_create_file() call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505133400.25747-1-geert+renesas@glider.be>
References: <20200505133400.25747-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 13:16:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue,  5 May 2020 15:34:00 +0200

> There is no need to cast a typed pointer to a void pointer when calling
> a function that accepts the latter.  Remove it, as the cast prevents
> further compiler checks.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thanks.
