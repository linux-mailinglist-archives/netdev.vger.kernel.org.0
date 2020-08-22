Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB77424E9EE
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 23:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgHVVIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgHVVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 17:08:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213FCC061574;
        Sat, 22 Aug 2020 14:08:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83F7F127E41F4;
        Sat, 22 Aug 2020 13:51:13 -0700 (PDT)
Date:   Sat, 22 Aug 2020 14:07:58 -0700 (PDT)
Message-Id: <20200822.140758.1768310758210192749.davem@davemloft.net>
To:     joe@perches.com
Cc:     Jianlin.Lv@arm.com, netdev@vger.kernel.org, kuba@kernel.org,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Remove unnecessary intermediate variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b3be3e91364781dc5211ef99dec6d9649076b701.camel@perches.com>
References: <ae154f9a96a710157f9b402ba21c6888c855dd1e.camel@perches.com>
        <20200822.135941.1718174258763815012.davem@davemloft.net>
        <b3be3e91364781dc5211ef99dec6d9649076b701.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 13:51:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 22 Aug 2020 14:03:31 -0700

> The compiler didn't inline the code without it.

Then the compiler had a good reason for doing so, or it's a compiler
bug that should be reported.

I would reject any patch that added inline to a foo.c file, so unless
you want to make suggestions that will cause a contributor's patch to
be rejected, I'd suggest you not recommend inline usage in this way.

Thank you.
