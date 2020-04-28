Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB71BCE30
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD1VHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726274AbgD1VHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:07:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB1EC03C1AC;
        Tue, 28 Apr 2020 14:07:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E69ED1210A3EF;
        Tue, 28 Apr 2020 14:07:46 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:07:46 -0700 (PDT)
Message-Id: <20200428.140746.1017253285576997409.davem@davemloft.net>
To:     steve@sk2.org
Cc:     joe@perches.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Protect INET_ADDR_COOKIE on 32-bit architectures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428075231.29687-1-steve@sk2.org>
References: <20200428075231.29687-1-steve@sk2.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 14:07:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Kitt <steve@sk2.org>
Date: Tue, 28 Apr 2020 09:52:31 +0200

> This patch changes INET_ADDR_COOKIE to declare a dummy typedef (so it
> makes checkpatch.pl complain, sorry...)

This is trading one problem for another, so in the end doesn't really
move us forward.
