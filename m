Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9409A2733D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfEWAWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:22:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEWAWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:22:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 455FB15042EA8;
        Wed, 22 May 2019 17:22:31 -0700 (PDT)
Date:   Wed, 22 May 2019 17:22:30 -0700 (PDT)
Message-Id: <20190522.172230.230166759225525041.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     isdn@linux-pingi.de, zhongjiang@huawei.com, deepa.kernel@gmail.com,
        penguin-kernel@I-love.SAKURA.ne.jp, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mISDN: make sure device name is NUL terminated
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522084513.GA2129@mwanda>
References: <20190522084513.GA2129@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:22:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 22 May 2019 11:45:13 +0300

> The user can change the device_name with the IMSETDEVNAME ioctl, but we
> need to ensure that the user's name is NUL terminated.  Otherwise it
> could result in a buffer overflow when we copy the name back to the user
> with IMGETDEVINFO ioctl.
> 
> I also changed two strcpy() calls which handle the name to strscpy().
> Hopefully, there aren't any other ways to create a too long name, but
> it's nice to do this as a kernel hardening measure.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
