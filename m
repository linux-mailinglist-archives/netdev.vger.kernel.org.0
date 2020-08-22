Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB4B24E9E4
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgHVU7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgHVU7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:59:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD04EC061573;
        Sat, 22 Aug 2020 13:59:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D27211E49A9D;
        Sat, 22 Aug 2020 13:42:58 -0700 (PDT)
Date:   Sat, 22 Aug 2020 13:59:41 -0700 (PDT)
Message-Id: <20200822.135941.1718174258763815012.davem@davemloft.net>
To:     joe@perches.com
Cc:     Jianlin.Lv@arm.com, netdev@vger.kernel.org, kuba@kernel.org,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Remove unnecessary intermediate variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ae154f9a96a710157f9b402ba21c6888c855dd1e.camel@perches.com>
References: <20200822020431.125732-1-Jianlin.Lv@arm.com>
        <20200822.123315.787815838209253525.davem@davemloft.net>
        <ae154f9a96a710157f9b402ba21c6888c855dd1e.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 13:42:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 22 Aug 2020 13:39:28 -0700

> It _might_ be slightly faster to use inlines

We are not using the inline directive in foo.c files and are letting
the compiler decide.

Please don't give out advice like this.

Thank you.
