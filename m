Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A9222C8C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgGPUNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPUNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:13:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F7C061755;
        Thu, 16 Jul 2020 13:13:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8E8011E4591F;
        Thu, 16 Jul 2020 13:13:43 -0700 (PDT)
Date:   Thu, 16 Jul 2020 13:13:41 -0700 (PDT)
Message-Id: <20200716.131341.1043144835432437801.davem@davemloft.net>
To:     asmadeus@codewreck.org
Cc:     hch@lst.de, nazard@nazar.ca, ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716075820.GA3720@nautica>
References: <20200715134756.GB22828@nautica>
        <20200715.142459.1215411672362681844.davem@davemloft.net>
        <20200716075820.GA3720@nautica>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jul 2020 13:13:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The amount of time you used to compose this email exceeds by several
orders of magnitude the amount of effort it would have taken to merge
the fix to Linus, calm the syzbot warnings, and make those warnings
therefore more useful for people doing active development.

I think your priorities are kinda off, but we can agree to disagree
I guess.

Thank you.
