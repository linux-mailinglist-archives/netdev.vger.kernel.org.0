Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53810A743
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKZXxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:53:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfKZXxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:53:32 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D87FB14DDBF7D;
        Tue, 26 Nov 2019 15:53:31 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:53:29 -0800 (PST)
Message-Id: <20191126.155329.693030888355093971.davem@davemloft.net>
To:     jeroendb@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net] gve: Fix the queue page list allocated pages count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126233619.235892-1-jeroendb@google.com>
References: <20191126233619.235892-1-jeroendb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 15:53:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeroen de Borst <jeroendb@google.com>
Date: Tue, 26 Nov 2019 15:36:19 -0800

> In gve_alloc_queue_page_list(), when a page allocation fails,
> qpl->num_entries will be wrong.  In this case priv->num_registered_pages
> can underflow in gve_free_queue_page_list(), causing subsequent calls
> to gve_alloc_queue_page_list() to fail.
> 
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>

Applied and queued up for -stable.
