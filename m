Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725DB4C4F2
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbfFTB0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:26:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfFTB0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:26:24 -0400
Received: from localhost (unknown [50.234.174.228])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFC6C150DB910;
        Wed, 19 Jun 2019 18:26:23 -0700 (PDT)
Date:   Wed, 19 Jun 2019 21:26:19 -0400 (EDT)
Message-Id: <20190619.212619.2235575281889913457.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] page_pool: fix compile warning when CONFIG_PAGE_POOL
 is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156098255254.17592.13888583206213518228.stgit@carbon>
References: <156098255254.17592.13888583206213518228.stgit@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 18:26:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 20 Jun 2019 00:15:52 +0200

> Kbuild test robot reported compile warning:
>  warning: no return statement in function returning non-void
> in function page_pool_request_shutdown, when CONFIG_PAGE_POOL is disabled.
> 
> The fix makes the code a little more verbose, with a descriptive variable.
> 
> Fixes: 99c07c43c4ea ("xdp: tracking page_pool resources and safe removal")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Applied.
