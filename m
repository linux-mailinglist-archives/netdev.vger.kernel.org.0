Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC3121F49
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLQAJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:09:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfLQAJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:09:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3338C1556D1F2;
        Mon, 16 Dec 2019 16:09:55 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:09:54 -0800 (PST)
Message-Id: <20191216.160954.121908386170799472.davem@davemloft.net>
To:     sven@narfation.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ipv6: Annotate bitwise IPv6 dsfield pointer cast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213202428.13869-1-sven@narfation.org>
References: <20191213202428.13869-1-sven@narfation.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:09:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>
Date: Fri, 13 Dec 2019 21:24:27 +0100

> The sparse commit 6002ded74587 ("add a flag to warn on casts to/from
> bitwise pointers") introduced a check for non-direct casts from/to
> restricted datatypes (when -Wbitwise-pointer is enabled).
> 
> This triggered a warning in ipv6_get_dsfield() because sparse doesn't know
> that the buffer already points to some data in the correct bitwise integer
> format. This was already fixed in ipv6_change_dsfield() by the __force
> attribute and can be fixed here the same way.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Applied to net-next
