Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6CB62BE8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfGHWkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:40:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbfGHWkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:40:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3197212D6C874;
        Mon,  8 Jul 2019 15:40:35 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:40:34 -0700 (PDT)
Message-Id: <20190708.154034.2114427019293786374.davem@davemloft.net>
To:     debrabander@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: txring_overwrite: fix incorrect test of
 mmap() return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562326994-4569-1-git-send-email-debrabander@gmail.com>
References: <1562326994-4569-1-git-send-email-debrabander@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:40:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank de Brabander <debrabander@gmail.com>
Date: Fri,  5 Jul 2019 13:43:14 +0200

> If mmap() fails it returns MAP_FAILED, which is defined as ((void *) -1).
> The current if-statement incorrectly tests if *ring is NULL.
> 
> Signed-off-by: Frank de Brabander <debrabander@gmail.com>

Applied with fixes tag added and queued up for -stable, thanks.
