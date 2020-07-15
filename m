Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4ED2216F9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGOVZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOVZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:25:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9964AC061755;
        Wed, 15 Jul 2020 14:25:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0625A11E45909;
        Wed, 15 Jul 2020 14:25:02 -0700 (PDT)
Date:   Wed, 15 Jul 2020 14:24:59 -0700 (PDT)
Message-Id: <20200715.142459.1215411672362681844.davem@davemloft.net>
To:     asmadeus@codewreck.org
Cc:     hch@lst.de, nazard@nazar.ca, ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200715134756.GB22828@nautica>
References: <20200711104923.GA6584@nautica>
        <20200715073715.GA22899@lst.de>
        <20200715134756.GB22828@nautica>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jul 2020 14:25:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>
Date: Wed, 15 Jul 2020 15:47:56 +0200

> It's honestly just a warn on something that would fail anyway so I'd
> rather let it live in -next first, I don't get why syzbot is so verbose
> about this - it sent a mail when it found a c repro and one more once it
> bisected the commit yesterday but it should not be sending more?

I honestly find it hard to understand the resistence to fixing the
warning in mainline.

I merge such fixes aggressively.
