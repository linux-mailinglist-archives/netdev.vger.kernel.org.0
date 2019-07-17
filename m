Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04D6C314
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfGQWX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:23:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfGQWX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:23:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D2FF14EC582F;
        Wed, 17 Jul 2019 15:23:56 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:23:55 -0700 (PDT)
Message-Id: <20190717.152355.324255823976095143.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [Patch net v3 0/2] ipv4: relax source validation check for
 loopback packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:23:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 17 Jul 2019 14:41:57 -0700

> This patchset fixes a corner case when loopback packets get dropped
> by rp_filter when we route them from veth to lo. Patch 1 is the fix
> and patch 2 provides a simplified test case for this scenario.

Series applied, thanks Cong.
