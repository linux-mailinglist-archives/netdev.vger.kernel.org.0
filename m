Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D0089648
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfHLEaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:30:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLEaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:30:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEC9F145487CD;
        Sun, 11 Aug 2019 21:30:13 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:30:13 -0700 (PDT)
Message-Id: <20190811.213013.1995644313060273325.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     wei.liu@kernel.org, paul.durrant@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen-netback: no need to check return value of
 debugfs_create functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190810103108.GA29487@kroah.com>
References: <20190810103108.GA29487@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:30:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 10 Aug 2019 12:31:08 +0200

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Paul Durrant <paul.durrant@citrix.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to net-next.
