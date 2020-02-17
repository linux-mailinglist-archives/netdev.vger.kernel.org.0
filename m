Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9216091E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBQDlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:41:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:41:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A33E0157AD8A1;
        Sun, 16 Feb 2020 19:41:36 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:41:36 -0800 (PST)
Message-Id: <20200216.194136.603150476098556620.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V2 2/3] net: ks8851-ml: Fix 16-bit data access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215165419.3901611-2-marex@denx.de>
References: <20200215165419.3901611-1-marex@denx.de>
        <20200215165419.3901611-2-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:41:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sat, 15 Feb 2020 17:54:18 +0100

> The packet data written to and read from Micrel KSZ8851-16MLLI must be
> byte-swapped in 16-bit mode, add this byte-swapping.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
