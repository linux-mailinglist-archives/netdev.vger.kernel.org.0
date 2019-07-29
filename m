Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7800A79285
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfG2RpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:45:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfG2RpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:45:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F095A13FB6F7F;
        Mon, 29 Jul 2019 10:45:02 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:45:02 -0700 (PDT)
Message-Id: <20190729.104502.257584587185971318.davem@davemloft.net>
To:     willy@infradead.org
Cc:     netdev@vger.kernel.org, aaro.koskinen@iki.fi, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] staging/octeon: Allow test build on !MIPS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726174425.6845-3-willy@infradead.org>
References: <20190726174425.6845-1-willy@infradead.org>
        <20190726174425.6845-3-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:45:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 26 Jul 2019 10:44:25 -0700

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Add compile test support by moving all includes of files under
> asm/octeon into octeon-ethernet.h, and if we're not on MIPS,
> stub out all the calls into the octeon support code in octeon-stubs.h
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Applied to net-next.
