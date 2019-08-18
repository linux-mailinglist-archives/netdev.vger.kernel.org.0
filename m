Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8191967
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 22:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfHRUCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 16:02:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48002 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHRUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 16:02:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F9B0143D06BA;
        Sun, 18 Aug 2019 13:02:11 -0700 (PDT)
Date:   Sun, 18 Aug 2019 13:02:11 -0700 (PDT)
Message-Id: <20190818.130211.369227823724788578.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     tglx@linutronix.de, swinslow@gmail.com, opensource@jilayne.com,
        kstewart@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cx82310_eth: fix a memory leak bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565805819-8113-1-git-send-email-wenwen@cs.uga.edu>
References: <1565805819-8113-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 13:02:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Wed, 14 Aug 2019 13:03:38 -0500

> In cx82310_bind(), 'dev->partial_data' is allocated through kmalloc().
> Then, the execution waits for the firmware to become ready. If the firmware
> is not ready in time, the execution is terminated. However, the allocated
> 'dev->partial_data' is not deallocated on this path, leading to a memory
> leak bug. To fix this issue, free 'dev->partial_data' before returning the
> error.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied.
