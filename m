Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AC4736DE
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGXSqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:46:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfGXSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:46:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5191F1540A46F;
        Wed, 24 Jul 2019 11:46:18 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:46:17 -0700 (PDT)
Message-Id: <20190724.114617.1121382688510615505.davem@davemloft.net>
To:     willy@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] Build fixes for skb_frag_size conversion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724113615.11961-1-willy@infradead.org>
References: <20190724113615.11961-1-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:46:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 24 Jul 2019 04:36:15 -0700

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> I missed a few places.  One is in some ifdeffed code which will probably
> never be re-enabled; the others are in drivers which can't currently be
> compiled on x86.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Applied, thanks for following up.
