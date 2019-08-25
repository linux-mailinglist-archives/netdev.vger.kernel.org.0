Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8760D9C654
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfHYVuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 17:50:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfHYVuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 17:50:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B069614EB33E0;
        Sun, 25 Aug 2019 14:49:59 -0700 (PDT)
Date:   Sun, 25 Aug 2019 14:49:58 -0700 (PDT)
Message-Id: <20190825.144958.1562423796796471536.davem@davemloft.net>
To:     yihung.wei@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net v2] openvswitch: Fix conntrack cache with timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
References: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 14:49:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>
Date: Thu, 22 Aug 2019 13:17:50 -0700

> This patch addresses a conntrack cache issue with timeout policy.
> Currently, we do not check if the timeout extension is set properly in the
> cached conntrack entry.  Thus, after packet recirculate from conntrack
> action, the timeout policy is not applied properly.  This patch fixes the
> aforementioned issue.
> 
> Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>

Applied and queued up for -stable, thanks.
