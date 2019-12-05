Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98312114843
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfLEUm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:42:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEUm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:42:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66ECB15047116;
        Thu,  5 Dec 2019 12:42:26 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:42:25 -0800 (PST)
Message-Id: <20191205.124225.1227757906747730493.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix extra rx interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205151817.1076-1-grygorii.strashko@ti.com>
References: <20191205151817.1076-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 12:42:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 5 Dec 2019 17:18:17 +0200

> This is an old issue, but I can't specify Fixes tag.

This is never true, there is always an appropriate Fixes: tag
even it means specifying the tag that created Linus's GIT repo.

> And, unfortunatelly,
> it can't be backported as is even in v5.4.

This I always don't understand.

You must elaborate and specify a Fixes: tag.
