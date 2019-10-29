Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF65E8FB6
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbfJ2TJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:09:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58444 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfJ2TJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:09:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7037414D69E30;
        Tue, 29 Oct 2019 12:09:21 -0700 (PDT)
Date:   Tue, 29 Oct 2019 12:09:21 -0700 (PDT)
Message-Id: <20191029.120921.2011958937132520274.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: remove redundant assignment to pointer bdp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025172255.4742-1-colin.king@canonical.com>
References: <20191025172255.4742-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 12:09:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 25 Oct 2019 18:22:55 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer bdp is being assigned with a value that is never
> read, so the assignment is redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
