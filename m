Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54538E30A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfHODD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:03:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfHODD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 23:03:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2C39145F4F5D;
        Wed, 14 Aug 2019 20:03:55 -0700 (PDT)
Date:   Wed, 14 Aug 2019 20:03:55 -0700 (PDT)
Message-Id: <20190814.200355.2112803017600842380.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: fix a memory leak bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565687932-2870-1-git-send-email-wenwen@cs.uga.edu>
References: <1565687932-2870-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 20:03:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Tue, 13 Aug 2019 04:18:52 -0500

> In blocked_fl_write(), 't' is not deallocated if bitmap_parse_user() fails,
> leading to a memory leak bug. To fix this issue, free t before returning
> the error.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied.
