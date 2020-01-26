Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492BF149C9C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAZT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:56:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZT4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:56:17 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09E7E155526E4;
        Sun, 26 Jan 2020 11:56:14 -0800 (PST)
Date:   Sun, 26 Jan 2020 20:56:13 +0100 (CET)
Message-Id: <20200126.205613.19167395629782356.davem@davemloft.net>
To:     lkp@intel.com
Cc:     niu_xilei@163.com, kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [net-next:master 7/69] pktgen.c:(.text.mod_cur_headers+0xba0):
 undefined reference to `__umoddi3'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <202001270204.5GzZI0sm%lkp@intel.com>
References: <202001270204.5GzZI0sm%lkp@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 11:56:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Niu, seriously, when are you going to fix this build regression you
introduced into the net-next tree?

You've received at least three separate reports about this and
have done nothing about it.

That is not acceptable.

If you don't fix this quickly I am reverting your changes.

Thank you.
