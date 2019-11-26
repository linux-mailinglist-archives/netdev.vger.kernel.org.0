Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BF710A656
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKZWFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:05:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:05:44 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05EB814D4413E;
        Tue, 26 Nov 2019 14:05:43 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:05:43 -0800 (PST)
Message-Id: <20191126.140543.12960644904577654.davem@davemloft.net>
To:     jeroendb@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net] gve: Fix the queue page list allocated pages count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126173313.137860-1-jeroendb@google.com>
References: <20191126173313.137860-1-jeroendb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 14:05:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeroen de Borst <jeroendb@google.com>
Date: Tue, 26 Nov 2019 09:33:13 -0800

> In gve_alloc_queue_page_list(), when a page allocation fails,
> qpl->num_entries will be wrong.  In this case priv->num_registered_pages
> can underflow in gve_free_queue_page_list(), causing subsequent calls
> to gve_alloc_queue_page_list() to fail.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>

You need to add an appropriate Fixes: tag.

Please take care of this and resubmit, thank you.
