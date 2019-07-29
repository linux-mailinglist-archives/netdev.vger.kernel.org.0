Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596C179283
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfG2Ro4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:44:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfG2Ro4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:44:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 874EF13C49680;
        Mon, 29 Jul 2019 10:44:55 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:44:54 -0700 (PDT)
Message-Id: <20190729.104454.47175217062448880.davem@davemloft.net>
To:     willy@infradead.org
Cc:     netdev@vger.kernel.org, aaro.koskinen@iki.fi, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] octeon: Fix typo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726174425.6845-2-willy@infradead.org>
References: <20190726174425.6845-1-willy@infradead.org>
        <20190726174425.6845-2-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:44:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 26 Jul 2019 10:44:24 -0700

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Compile fix from skb_frag_t conversion.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

As I mentioned I already fixed this.
