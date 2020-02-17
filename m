Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0D1608F2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBQDau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:30:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:30:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 606A31574C430;
        Sun, 16 Feb 2020 19:30:49 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:30:48 -0800 (PST)
Message-Id: <20200216.193048.970019609345533158.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     sameo@linux.intel.com, joe@perches.com, gregkh@linuxfoundation.org,
        allison@lohutok.net, tglx@linutronix.de,
        kstewart@linuxfoundation.org, natechancellor@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: pn544: Fix a typo in a debug message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215071728.302-1-christophe.jaillet@wanadoo.fr>
References: <20200215071728.302-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:30:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 15 Feb 2020 08:17:28 +0100

> The ending character of the string shoulb be \n, not \b.
> 
> Fixes: 17936b43f0fd ("NFC: Standardize logging style")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
