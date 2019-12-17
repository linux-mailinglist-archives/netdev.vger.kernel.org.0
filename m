Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB5121F4A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLQAKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:10:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfLQAKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:10:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42BC81556D1F2;
        Mon, 16 Dec 2019 16:10:03 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:10:02 -0800 (PST)
Message-Id: <20191216.161002.378231914918115139.davem@davemloft.net>
To:     sven@narfation.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ipv6: Annotate ipv6_addr_is_* bitwise pointer casts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213202428.13869-2-sven@narfation.org>
References: <20191213202428.13869-1-sven@narfation.org>
        <20191213202428.13869-2-sven@narfation.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:10:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>
Date: Fri, 13 Dec 2019 21:24:28 +0100

> The sparse commit 6002ded74587 ("add a flag to warn on casts to/from
> bitwise pointers") introduced a check for non-direct casts from/to
> restricted datatypes (when -Wbitwise-pointer is enabled).
> 
> This triggered a warning in the 64 bit optimized ipv6_addr_is_*() functions
> because sparse doesn't know that the buffer already points to some data in
> the correct bitwise integer format. But these were correct and can
> therefore be marked with __force to signalize sparse an intended cast to a
> specific bitwise type.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Applied to net-next
