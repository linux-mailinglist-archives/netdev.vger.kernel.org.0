Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767B5CC4F4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbfJDVmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:42:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfJDVmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:42:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CB9614F123B6;
        Fri,  4 Oct 2019 14:42:32 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:42:31 -0700 (PDT)
Message-Id: <20191004.144231.1256170605304174323.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, shahjada@chelsio.com
Subject: Re: [PATCH net V2] cxgb4:Fix out-of-bounds MSI-X info array access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570142175-6546-1-git-send-email-vishal@chelsio.com>
References: <1570142175-6546-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:42:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Fri,  4 Oct 2019 04:06:15 +0530

> When fetching free MSI-X vectors for ULDs, check for the error code
> before accessing MSI-X info array. Otherwise, an out-of-bounds access is
> attempted, which results in kernel panic.
> 
> Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
> Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> ---
> V2:
> - Fix compilation warning
> - Don't split Fixes tag into multiple lines

Applied, thanks.
