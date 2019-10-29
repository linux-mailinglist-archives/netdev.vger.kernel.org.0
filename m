Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A26E8E8D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfJ2RsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:48:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfJ2RsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:48:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 854EA14CDECCB;
        Tue, 29 Oct 2019 10:48:08 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:48:08 -0700 (PDT)
Message-Id: <20191029.104808.1135935798148200898.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: aquantia: fix spelling mistake: tx_queus ->
 tx_queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025113828.19710-1-colin.king@canonical.com>
References: <20191025113828.19710-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 10:48:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 25 Oct 2019 12:38:28 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a netdev_err error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
