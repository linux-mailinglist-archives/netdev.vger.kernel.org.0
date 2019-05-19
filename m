Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDF2227BB
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfESRcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:32:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfESRcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:32:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEEC613EE2AF4;
        Sun, 19 May 2019 10:32:00 -0700 (PDT)
Date:   Sun, 19 May 2019 10:31:58 -0700 (PDT)
Message-Id: <20190519.103158.398765503030510997.davem@davemloft.net>
To:     ptalbert@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: Treat sock->sk_drops as an unsigned int when
 printing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190517151128.14444-1-ptalbert@redhat.com>
References: <20190517151128.14444-1-ptalbert@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 May 2019 10:32:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick Talbert <ptalbert@redhat.com>
Date: Fri, 17 May 2019 17:11:28 +0200

> Currently, procfs socket stats format sk_drops as a signed int (%d). For large
> values this will cause a negative number to be printed.
> 
> We know the drop count can never be a negative so change the format specifier to
> %u.
> 
> Signed-off-by: Patrick Talbert <ptalbert@redhat.com>

Yep, looks reasonable, applied.
