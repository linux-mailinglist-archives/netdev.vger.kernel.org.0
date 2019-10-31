Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3587EA868
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfJaA6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:58:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfJaA6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:58:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B22B314E7C113;
        Wed, 30 Oct 2019 17:58:43 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:58:43 -0700 (PDT)
Message-Id: <20191030.175843.1675423957559675418.davem@davemloft.net>
To:     zhongjiang@huawei.com
Cc:     linux-wimax@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs
 fops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572404134-45159-1-git-send-email-zhongjiang@huawei.com>
References: <1572404134-45159-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:58:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Date: Wed, 30 Oct 2019 10:55:34 +0800

> It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
> operation rather than DEFINE_SIMPLE_ATTRIBUTE.
> 
> It is detected with the help of coccinelle.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Applied.
