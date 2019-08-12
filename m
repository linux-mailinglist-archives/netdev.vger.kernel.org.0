Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC4189649
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfHLEbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:31:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLEbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:31:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEFA5145A92FB;
        Sun, 11 Aug 2019 21:31:35 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:31:35 -0700 (PDT)
Message-Id: <20190811.213135.247211376954677812.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, rfontana@redhat.com, swinslow@gmail.com
Subject: Re: [PATCH] caif: no need to check return value of debugfs_create
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190810104243.GA24741@kroah.com>
References: <20190810104243.GA24741@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:31:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 10 Aug 2019 12:42:43 +0200

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Richard Fontana <rfontana@redhat.com>
> Cc: Steve Winslow <swinslow@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied.
