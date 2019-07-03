Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6C5EDCE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGCUrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:47:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCUrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:47:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83825144CBBEB;
        Wed,  3 Jul 2019 13:47:01 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:47:00 -0700 (PDT)
Message-Id: <20190703.134700.1755482990570068688.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702235442.1925-1-saeedm@mellanox.com>
References: <20190702235442.1925-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:47:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 2 Jul 2019 23:55:07 +0000

> This humble 2 patch series from Shay adds the support for devlink fw
> versions query to mlx5 driver.
> 
> In the first patch we implement the needed fw commands to support this
> feature.
> In the 2nd patch we implement the devlink callbacks themselves.
> 
> I am not sending this as a pull request since i am not sure when my next
> pull request is going to be ready, and these two patches are straight
> forward net-next patches.

Series applied to net-next, thanks.
