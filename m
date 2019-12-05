Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FA31147F8
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfLEUKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:10:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLEUKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:10:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86E8E15038AB5;
        Thu,  5 Dec 2019 12:10:10 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:10:06 -0800 (PST)
Message-Id: <20191205.121006.1746994374411312901.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        treeze.taeung@gmail.com
Subject: Re: [PATCH v2 net] hsr: fix a NULL pointer dereference in
 hsr_dev_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205072339.21906-1-ap420073@gmail.com>
References: <20191205072339.21906-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 12:10:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  5 Dec 2019 07:23:39 +0000

> hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
> return NULL if master node is not existing in the list.
> But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
> could occur.
> 
> Test commands:
 ...
> Splat looks like:
 ...
> Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for v5.3 -stable, thanks.
