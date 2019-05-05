Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3134714160
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfEERUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:20:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEERUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:20:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20E2014D9FADE;
        Sun,  5 May 2019 10:20:00 -0700 (PDT)
Date:   Sun, 05 May 2019 10:19:59 -0700 (PDT)
Message-Id: <20190505.101959.1864240642373241547.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: rds: fix spelling mistake "syctl" -> "sysctl"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503121017.5227-1-colin.king@canonical.com>
References: <20190503121017.5227-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:20:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri,  3 May 2019 13:10:17 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a pr_warn warning. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
