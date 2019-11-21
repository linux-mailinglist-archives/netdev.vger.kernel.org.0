Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796B7105AD4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUUHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:07:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUUHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:07:01 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 646E215044951;
        Thu, 21 Nov 2019 12:07:01 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:07:00 -0800 (PST)
Message-Id: <20191121.120700.742038888535498481.davem@davemloft.net>
To:     mhabets@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] sfc: Only cancel the PPS workqueue if it exists
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157435873481.1746063.7779522257910378266.stgit@mh-desktop.uk.solarflarecom.com>
References: <157435873481.1746063.7779522257910378266.stgit@mh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 12:07:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <mhabets@solarflare.com>
Date: Thu, 21 Nov 2019 17:52:15 +0000

> The workqueue only exists for the primary PF. For other functions
> we hit a WARN_ON in kernel/workqueue.c.
> 
> Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
> Signed-off-by: Martin Habets <mhabets@solarflare.com>

Applied and queued up for -stable, thanks.
