Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9384FDA9
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFWSeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:34:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfFWSeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:34:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C65412D8C0E7;
        Sun, 23 Jun 2019 11:34:24 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:34:23 -0700 (PDT)
Message-Id: <20190623.113423.151452943171499414.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/4] cxgb4: Re-work the logic for mps
 refcounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621143636.20422-2-rajur@chelsio.com>
References: <20190621143636.20422-1-rajur@chelsio.com>
        <20190621143636.20422-2-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:34:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Fri, 21 Jun 2019 20:06:33 +0530

> +struct mps_entries_ref {
> +	struct list_head list;
> +	u8 addr[ETH_ALEN];
> +	u8 mask[ETH_ALEN];
> +	u16 idx;
> +	atomic_t refcnt;
> +};

Since you're making this change, please use refcnt_t.
