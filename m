Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262CAEA88C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfJaBMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:12:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJaBMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:12:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B852414D68F87;
        Wed, 30 Oct 2019 18:12:11 -0700 (PDT)
Date:   Wed, 30 Oct 2019 18:12:11 -0700 (PDT)
Message-Id: <20191030.181211.1728074577147611297.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com,
        shahjada@chelsio.com
Subject: Re: [PATCH net v2] cxgb4: fix panic when attaching to ULD fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572446877-29202-1-git-send-email-vishal@chelsio.com>
References: <1572446877-29202-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 18:12:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 30 Oct 2019 20:17:57 +0530

> Release resources when attaching to ULD fail. Otherwise, data
> mismatch is seen between LLD and ULD later on, which lead to
> kernel panic when accessing resources that should not even
> exist in the first place.
> 
> Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
> Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied and queued up for -stable, thank you.
