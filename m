Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617924FC7B
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfFWPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:36:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:36:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC420152F693C;
        Sun, 23 Jun 2019 08:36:52 -0700 (PDT)
Date:   Sun, 23 Jun 2019 08:36:52 -0700 (PDT)
Message-Id: <20190623.083652.1200010744616612417.davem@davemloft.net>
To:     sergej.benilov@googlemail.com
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: increment revision number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623074707.6348-1-sergej.benilov@googlemail.com>
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 08:36:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>
Date: Sun, 23 Jun 2019 09:47:07 +0200

> Increment revision number to 1.08.11 (TX completion fix).
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

These are useless, really...

People are going to backport the TX completion fix all by itself
and not this change if I were to merge it.

I really want to heavily discourage these kinds of things, sorry.
Code is code, the fix is there or it isn't.
