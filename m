Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073BE90AE8
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfHPWZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:25:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfHPWZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:25:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 044D6140B09F5;
        Fri, 16 Aug 2019 15:25:23 -0700 (PDT)
Date:   Fri, 16 Aug 2019 15:24:54 -0700 (PDT)
Message-Id: <20190816.152454.820414129398569362.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan78xx: Fix memory leaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565799793-7446-1-git-send-email-wenwen@cs.uga.edu>
References: <1565799793-7446-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 15:25:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Wed, 14 Aug 2019 11:23:13 -0500

> In lan78xx_probe(), a new urb is allocated through usb_alloc_urb() and
> saved to 'dev->urb_intr'. However, in the following execution, if an error
> occurs, 'dev->urb_intr' is not deallocated, leading to memory leaks. To fix
> this issue, invoke usb_free_urb() to free the allocated urb before
> returning from the function.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied.
