Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57567AFC4
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfG3RYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:24:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfG3RYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:24:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1C9D12659275;
        Tue, 30 Jul 2019 10:24:34 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:24:34 -0700 (PDT)
Message-Id: <20190730.102434.1438984182304969810.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     petkan@nucleusys.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fix improper read if
 get_registers() fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730131357.30697-1-dkirjanov@suse.com>
References: <20190730131357.30697-1-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 10:24:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Tue, 30 Jul 2019 15:13:57 +0200

> get_registers() may fail with -ENOMEM and in this
> case we can read a garbage from the status variable tmp.
> 
> Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Why did you post this patch twice?  What is different between the two
versions?
