Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC60E786B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbfJ1S3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:29:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfJ1S3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:29:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03A9714970B6F;
        Mon, 28 Oct 2019 11:29:04 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:29:04 -0700 (PDT)
Message-Id: <20191028.112904.824821320861730754.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 11:29:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 22 Oct 2019 16:10:48 -0700

> This patchset contains 3 patches: patch 1 is a cleanup,
> patch 2 is a small change preparing for patch 3, patch 3 is the
> one does the actual change. Please find details in each of them.

Eric, have you had a chance to test this on a system with
suitable CPU arity?
