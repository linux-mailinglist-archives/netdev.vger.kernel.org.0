Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F7F17EF00
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCJDOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:14:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJDOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 23:14:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F02412199AD9;
        Mon,  9 Mar 2020 20:14:42 -0700 (PDT)
Date:   Mon, 09 Mar 2020 20:14:41 -0700 (PDT)
Message-Id: <20200309.201441.461523437582217903.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
Subject: Re: [PATCH v4 net-next 0/5] Improve bind(addr, 0) behaviour.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308181615.90135-1-kuniyu@amazon.co.jp>
References: <20200308181615.90135-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 20:14:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Mon, 9 Mar 2020 03:16:10 +0900

> Currently we fail to bind sockets to ephemeral ports when all of the ports
> are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> we still have a chance to connect to the different remote hosts.
> 
> These patches add net.ipv4.ip_autobind_reuse option and fix the behaviour
> to fully utilize all space of the local (addr, port) tuples.
 ...

Eric, please review, thank you.
