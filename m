Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFAE7CCE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfJ1XYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:24:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfJ1XYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:24:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3910E14BE91D7;
        Mon, 28 Oct 2019 16:24:11 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:24:10 -0700 (PDT)
Message-Id: <20191028.162410.844978847156294593.davem@davemloft.net>
To:     benh@kernel.crashing.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vijaykhemka@fb.com, openbmc@lists.ozlabs.org, joel@jms.id.au,
        linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH] net: ethernet: ftgmac100: Fix DMA coherency issue with
 SW checksum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <572a7d510ace5e5a5ba41c4774d330133291c82a.camel@kernel.crashing.org>
References: <572a7d510ace5e5a5ba41c4774d330133291c82a.camel@kernel.crashing.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:24:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 25 Oct 2019 13:47:24 +1100

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Fixes: 05690d633f30 ftgmac100: Upgrade to NETIF_F_HW_CSUM

Please put the commit header string inside double quotes and parenthesis
(" ")

> CC: stable@vger.kernel.org [v4.12+]

Do not CC: stable for networking submissions as per the netdev FAQ.

All fixed up, and queued up for -stable, thanks Ben.
