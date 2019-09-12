Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F7CB0E27
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfILLmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:42:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730982AbfILLmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:42:32 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD0BC142D41F9;
        Thu, 12 Sep 2019 04:42:30 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:42:29 +0200 (CEST)
Message-Id: <20190912.134229.2035407960151017293.davem@davemloft.net>
To:     torvalds@linux-foundation.org
Cc:     xiyou.wangcong@gmail.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] sch_sfb: fix a crash in sfb_destroy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
References: <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com>
        <CAM_iQpVP6qVbWmV+kA8UGXG6r1LJftyV32UjUbqryGrX5Ud8Nw@mail.gmail.com>
        <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:42:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Sep 2019 11:31:06 +0100

> It depends on what you want to do, of course. Do you want to make sure
> each user is being very careful? Or do you want to make the interfaces
> easy to use without _having_ to be careful? There are arguments both
> ways, but we've tended to move more towards a "easy to use" model than
> the "be careful" one.

Yes, I think allowing NULL or error pointers on free/destroy makes sense.
