Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F85A16093F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBQDuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:50:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:50:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37104157D8A6F;
        Sun, 16 Feb 2020 19:50:20 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:50:19 -0800 (PST)
Message-Id: <20200216.195019.1025089439014688300.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH -net] skbuff.h: fix all kernel-doc warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ce570d32-1a3d-0438-d5fc-0e16b2d417df@infradead.org>
References: <ce570d32-1a3d-0438-d5fc-0e16b2d417df@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:50:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 15 Feb 2020 15:34:07 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix all kernel-doc warnings in <linux/skbuff.h>.
> Fixes these warnings:
 ...
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
