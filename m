Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D6169B45
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 01:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgBXAlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 19:41:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXAlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 19:41:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1465158E0671;
        Sun, 23 Feb 2020 16:41:54 -0800 (PST)
Date:   Sun, 23 Feb 2020 16:41:54 -0800 (PST)
Message-Id: <20200223.164154.1411149705613568241.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ena: ethtool: remove redundant non-zero check on
 rc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221232653.33134-1-colin.king@canonical.com>
References: <20200221232653.33134-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 16:41:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 21 Feb 2020 23:26:53 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The non-zero check on rc is redundant as a previous non-zero
> check on rc will always return and the second check is never
> reached, hence it is redundant and can be removed.  Also
> remove a blank line.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
