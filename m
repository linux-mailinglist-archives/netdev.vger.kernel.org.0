Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF3491E5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfFQVBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:01:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfFQVBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:01:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66C7A150FD127;
        Mon, 17 Jun 2019 14:01:07 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:01:06 -0700 (PDT)
Message-Id: <20190617.140106.2136391777805798865.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: sched: act_ctinfo: fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
References: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 14:01:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Mon, 17 Jun 2019 11:03:25 +0100

> This is first attempt at sending a small series.  Order is important
> because one bug (policy validation) prevents us from encountering the
> more important 'OOPS' generating bug in action creation.  Fix the OOPS
> first.
> 
> Confession time: Until very recently, development of this module has
> been done on 'net-next' tree to 'clean compile' level with run-time
> testing on backports to 4.14 & 4.19 kernels under openwrt.  It turns out
> that sched: action: based code has been under more active change than I
> realised.
> 
> During the back & forward porting during development & testing, the
> critical ACT_P_CREATED return code got missed despite being in the 4.14
> & 4.19 backports.  I have now gone through the init functions, using
> act_csum as reference with a fine toothed comb and am happy they do the
> same things.
> 
> This issue hadn't been caught till now due to another issue caused by
> new strict nla_parse_nested function failing parsing validation before
> action creation.
> 
> Thanks to Marcelo Leitner <marcelo.leitner@gmail.com> for flagging
> extack deficiency (fixed in 733f0766c3de sched: act_ctinfo: use extack
> error reporting) which led to b424e432e770 ("netlink: add validation of
> NLA_F_NESTED flag") and 8cb081746c03 ("netlink: make validation more
> configurable for future strictness”) which led to the policy validation
> fix, which then led to the action creation fix both contained in this
> series.
> 
> If I ever get to a developer conference please feel free to
> tar/feather/apply cone of shame.

:-)  In kernel networking development we prefer brown paper bags over
cones of shame, just FYI :) :) :)

Series applied, thanks.
