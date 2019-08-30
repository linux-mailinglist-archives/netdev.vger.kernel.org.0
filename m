Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4707AA4027
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfH3WKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:10:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3WKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:10:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AA2C154FFB1A;
        Fri, 30 Aug 2019 15:10:13 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:10:12 -0700 (PDT)
Message-Id: <20190830.151012.1309931638957540000.davem@davemloft.net>
To:     luke.w.hsiao@gmail.com
Cc:     netdev@vger.kernel.org, lukehsiao@google.com, soheil@google.com,
        ncardwell@google.com, priyarjha@google.com
Subject: Re: [PATCH net-next] tcp_bbr: clarify that bbr_bdp() rounds up in
 comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829140244.195954-1-luke.w.hsiao@gmail.com>
References: <20190829140244.195954-1-luke.w.hsiao@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 15:10:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <luke.w.hsiao@gmail.com>
Date: Thu, 29 Aug 2019 10:02:44 -0400

> From: Luke Hsiao <lukehsiao@google.com>
> 
> This explicitly clarifies that bbr_bdp() returns the rounded-up value of
> the bandwidth-delay product and why in the comments.
> 
> Signed-off-by: Luke Hsiao <lukehsiao@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Priyaranjan Jha <priyarjha@google.com>

Applied.
