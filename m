Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69821EA5D0
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfJ3V4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:56:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfJ3V4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:56:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E880F14D053E3;
        Wed, 30 Oct 2019 14:56:30 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:56:30 -0700 (PDT)
Message-Id: <20191030.145630.1191634933328855920.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, ycheng@google.com, ncardwell@google.com,
        edumazet@google.com
Subject: Re: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:56:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 22 Oct 2019 16:10:48 -0700

> This patchset contains 3 patches: patch 1 is a cleanup,
> patch 2 is a small change preparing for patch 3, patch 3 is the
> one does the actual change. Please find details in each of them.

I'm marking this deferred until someone can drill down why this is
only seen in such a specific configuration, and not to ANY EXTENT
whatsoever with just a slightly lower number of CPUs on other
machines.

It's really hard to justify this set of changes without a full
understanding and detailed analysis.

Thanks.
