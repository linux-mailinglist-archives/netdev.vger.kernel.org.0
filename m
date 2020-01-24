Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ADB1478D9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgAXHMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:12:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgAXHMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:12:46 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D59BA157D8EFE;
        Thu, 23 Jan 2020 23:12:44 -0800 (PST)
Date:   Fri, 24 Jan 2020 08:12:43 +0100 (CET)
Message-Id: <20200124.081243.840308996159716293.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     ralf@linux-mips.org, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] net/rose: fix spelling mistake "to" -> "too"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123092730.10909-1-colin.king@canonical.com>
References: <20200123092730.10909-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 23:12:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 23 Jan 2020 09:27:30 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a printk message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> V2: split the patch, the V1 included another fix.

Applied.
