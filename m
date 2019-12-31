Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6E112D55F
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 01:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfLaAyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 19:54:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfLaAyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 19:54:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF9691555E26A;
        Mon, 30 Dec 2019 16:54:17 -0800 (PST)
Date:   Mon, 30 Dec 2019 16:54:15 -0800 (PST)
Message-Id: <20191230.165415.752420426831879647.davem@davemloft.net>
To:     ttttabcd@protonmail.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection
 requests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <yHuJXgAqQR7nYwhgnval7Gzpy1twzeu7B9mniTpp79i9ApTqWQ0ArMUXqR0l4mTecwc0m-zk_-LjvaDqaL-M1_yQMZAL1mEY2PhroSdQfEk=@protonmail.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
        <201912310520.gWWmntOp%lkp@intel.com>
        <yHuJXgAqQR7nYwhgnval7Gzpy1twzeu7B9mniTpp79i9ApTqWQ0ArMUXqR0l4mTecwc0m-zk_-LjvaDqaL-M1_yQMZAL1mEY2PhroSdQfEk=@protonmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 16:54:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ttttabcd <ttttabcd@protonmail.com>
Date: Tue, 31 Dec 2019 00:22:44 +0000

> I have fixed this issue in the previous email, using min_t

You have to post your updated patch as a new list posting, not as a reply
to an existing posting.

Thank you.
