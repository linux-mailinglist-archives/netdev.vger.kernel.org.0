Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E496760DBC
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGEWWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:22:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfGEWWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:22:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C59A815042091;
        Fri,  5 Jul 2019 15:22:40 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:22:40 -0700 (PDT)
Message-Id: <20190705.152240.1003601540473803459.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, arvid.brodin@alten.se
Subject: Re: [Patch net 0/3] hsr: a few bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
References: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:22:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed,  3 Jul 2019 17:21:11 -0700

> This patchset contains 3 bug fixes for hsr triggered by a syzbot
> reproducer, please check each patch for details.
> 
> Cc: Arvid Brodin <arvid.brodin@alten.se>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Series applied, thanks.
