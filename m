Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF02B130A53
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgAEWtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:49:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:49:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFDB015572976;
        Sun,  5 Jan 2020 14:49:45 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:49:45 -0800 (PST)
Message-Id: <20200105.144945.1887147568639526288.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     bh74.an@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Drop obsolete entries from Samsung sxgbe
 ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103172549.11048-1-krzk@kernel.org>
References: <20200103172549.11048-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:49:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Fri,  3 Jan 2020 18:25:49 +0100

> The emails to ks.giri@samsung.com and vipul.pandya@samsung.com bounce
> with 550 error code:
> 
>     host mailin.samsung.com[203.254.224.12] said: 550
>     5.1.1 Recipient address rejected: User unknown (in reply to RCPT TO
>     command)"
> 
> Drop Girish K S and Vipul Pandya from sxgbe maintainers entry.
> 
> Cc: Byungho An <bh74.an@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied.
