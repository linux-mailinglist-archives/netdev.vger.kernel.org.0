Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD2268173
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgIMVZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMVZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:25:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F082C06174A;
        Sun, 13 Sep 2020 14:25:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8B51127FC36C;
        Sun, 13 Sep 2020 14:08:36 -0700 (PDT)
Date:   Sun, 13 Sep 2020 14:25:22 -0700 (PDT)
Message-Id: <20200913.142522.1753407855743748880.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     greg@kroah.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in
 __sys_sendmmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <89526337-9657-8f4d-3022-9f2ad830fbe9@gmail.com>
References: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
        <20200913061351.GA585618@kroah.com>
        <89526337-9657-8f4d-3022-9f2ad830fbe9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 13 Sep 2020 14:08:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Sun, 13 Sep 2020 11:50:52 +0530

> My apologies. I think I ended up overlooking the build warning.

You "think" you overlooked the build warning?  You don't actually
know?

If you aren't willing to even make sure the build is clean after your
changes, why should we be willing to review and integrate your changes?

This kind of carelessness costs other developers their valuable time,
please treat it with more respect than you have.

Thank you.

