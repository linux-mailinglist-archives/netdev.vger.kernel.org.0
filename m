Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344F6AFE97
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfIKOUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:20:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfIKOUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:20:37 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAB0811F5F66F;
        Wed, 11 Sep 2019 07:20:35 -0700 (PDT)
Date:   Wed, 11 Sep 2019 16:20:34 +0200 (CEST)
Message-Id: <20190911.162034.26944502948221949.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4: fix spelling mistake "veify" -> "verify"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911141811.8370-1-colin.king@canonical.com>
References: <20190911141811.8370-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 07:20:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 11 Sep 2019 15:18:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a mlx4_err error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
