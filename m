Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61229123FA8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLRGeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:34:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRGeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:34:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D30615008C83;
        Tue, 17 Dec 2019 22:34:09 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:34:08 -0800 (PST)
Message-Id: <20191217.223408.1618564088748917156.davem@davemloft.net>
To:     shahjada@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next 0/2] cxgb4/chtls: fix issues related to high
 priority region
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217064209.8526-1-shahjada@chelsio.com>
References: <20191217064209.8526-1-shahjada@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:34:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahjada Abul Husain <shahjada@chelsio.com>
Date: Tue, 17 Dec 2019 12:12:07 +0530

> The high priority region introduced by:
> 
> commit c21939998802 ("cxgb4: add support for high priority filters")
> 
> had caused regression in some code paths, leading to connection
> failures for the ULDs.
> 
> This series of patches attempt to fix the regressions.
> 
> Patch 1 fixes some code paths that have been missed to consider
> the high priority region.
> 
> Patch 2 fixes ULD connection failures due to wrong TID base that
> had been shifted after the high priority region.

Series applied, thanks.
