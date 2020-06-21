Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8586920279B
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgFUAaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUAaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:30:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A716C061794;
        Sat, 20 Jun 2020 17:30:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6DE9120ED49C;
        Sat, 20 Jun 2020 17:30:08 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:30:08 -0700 (PDT)
Message-Id: <20200620.173008.2285901120385281136.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618203632.15438-1-gaurav1086@gmail.com>
References: <20200618040056.30792-1-gaurav1086@gmail.com>
        <20200618203632.15438-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:30:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Thu, 18 Jun 2020 16:36:31 -0400

> parent cannot be NULL here since its in the else part
> of the if (parent == NULL) condition. Remove the extra
> check on parent pointer.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied to net-next, thanks.
