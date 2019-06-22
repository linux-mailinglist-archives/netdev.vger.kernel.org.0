Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B270E4F901
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfFVXnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:43:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVXnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:43:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DCA6153913F1;
        Sat, 22 Jun 2019 16:43:32 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:43:31 -0700 (PDT)
Message-Id: <20190622.164331.1876304524425958459.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, tiny.windzz@gmail.com
Subject: Re: [PATCH] fjes: no need to check return value of debugfs_create
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620073106.GA22356@kroah.com>
References: <20190620073106.GA22356@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:43:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 20 Jun 2019 09:31:06 +0200

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to net-next, thanks Greg.
