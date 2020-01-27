Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C4E14A163
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgA0KBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:01:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgA0KBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:01:35 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D342C15072898;
        Mon, 27 Jan 2020 02:01:33 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:01:32 +0100 (CET)
Message-Id: <20200127.110132.1390817709733213399.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, kuni1840@gmail.com
Subject: Re: [PATCH v2 net-next] soreuseport: Cleanup duplicate
 initialization of more_reuse->max_socks.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <336488a1ae764c05acffe4b930dfe787@EX13MTAUEA002.ant.amazon.com>
References: <20200125.102936.1710420903506965271.davem@davemloft.net>
        <336488a1ae764c05acffe4b930dfe787@EX13MTAUEA002.ant.amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:01:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Sat, 25 Jan 2020 10:41:02 +0000

> From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> reuseport_grow() does not need to initialize the more_reuse->max_socks
> again. It is already initialized in __reuseport_alloc().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Applied.
