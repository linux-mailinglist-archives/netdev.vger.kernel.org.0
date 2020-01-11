Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5251137BEB
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 08:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAKHE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 02:04:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgAKHE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 02:04:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8CE415995586;
        Fri, 10 Jan 2020 23:04:25 -0800 (PST)
Date:   Fri, 10 Jan 2020 23:04:22 -0800 (PST)
Message-Id: <20200110.230422.1046090850110878316.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, gospo@broadcom.com,
        michael.chan@broadcom.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] bnxt: Detach page from page pool before
 sending up the stack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
References: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 23:04:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Thu, 9 Jan 2020 11:35:42 -0800

> When running in XDP mode, pages come from the page pool, and should
> be freed back to the same pool or specifically detached.  Currently,
> when the driver re-initializes, the page pool destruction is delayed
> forever since it thinks there are oustanding pages.
> 
> Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied, thank you.
