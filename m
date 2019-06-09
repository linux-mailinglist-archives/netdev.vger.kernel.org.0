Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787503ABCB
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfFIUgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:36:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIUgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:36:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E51A114DF4267;
        Sun,  9 Jun 2019 13:36:22 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:36:22 -0700 (PDT)
Message-Id: <20190609.133622.727594888423105130.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, joe@perches.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] bonding: clean up and standarize logging
 printks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:36:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri,  7 Jun 2019 10:59:25 -0400

> This set improves a few somewhat terse bonding debug messages, fixes some
> errors in others, and then standarizes the majority of them, using new
> slave_* printk macros that wrap around netdev_* to ensure both master
> and slave information is provided consistently, where relevant. This set
> proves very useful in debugging issues on hosts with multiple bonds.
> 
> I've run an array of LNST tests over this set, creating and destroying
> quite a few different bonds of the course of testing, fixed the little
> gotchas here and there, and everything looks stable and reasonable to me,
> but I can't guarantee I've tested every possible message and scenario to
> catch every possible "slave could be NULL" case.

Series applied, thanks.
