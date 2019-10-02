Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE55C94CC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfJBXZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:25:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfJBXZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:25:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AE3F1551EF10;
        Wed,  2 Oct 2019 16:25:18 -0700 (PDT)
Date:   Wed, 02 Oct 2019 16:25:09 -0700 (PDT)
Message-Id: <20191002.162509.887188013929694661.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        maxime.chevallier@bootlin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mvpp2: remove misleading comment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002214904.10887-1-mcroce@redhat.com>
References: <20191002214904.10887-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 16:25:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Wed,  2 Oct 2019 23:49:04 +0200

> Recycling in mvpp2 has gone long time ago, but two comment still refers
> to it. Remove those two misleading comments as they generate confusion.
> 
> Fixes: 7ef7e1d949cd ("net: mvpp2: drop useless fields in mvpp2_bm_pool and related code")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks.
