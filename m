Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD01EB10D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgFAVkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAVkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:40:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D1C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 14:40:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7315E11F5F637;
        Mon,  1 Jun 2020 14:40:11 -0700 (PDT)
Date:   Mon, 01 Jun 2020 14:40:08 -0700 (PDT)
Message-Id: <20200601.144008.2114976182852633034.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     Jason@zx2c4.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of
 cycle
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz>
References: <20200601.110044.945252928135960732.davem@davemloft.net>
        <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
        <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 14:40:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 1 Jun 2020 23:13:07 +0200

> On Mon, Jun 01, 2020 at 01:33:46PM -0600, Jason A. Donenfeld wrote:
>> This possibility had occurred to me too, which is why I mentioned the
>> project being sufficiently young that this can work out. It's not
>> actually in any LTS yet, which means at the worst, this will apply
>> temporarily for 5.6,
> 
> It's not only about stable. The code has been backported e.g. into SLE15
> SP2 and openSUSE Leap 15.2 kernels which which are deep in RC phase so
> that we would face the choice between backporting this huge patch in
> a maintenance update and keeping to stumble over it in most of future
> backports (for years). Neither is very appealing (to put it mildly).
> I have no idea how many other distributions would be affected or for how
> long but I doubt we are the only ones.

And google and Facebook and twitter and Amazon and whatever else major
infrastructure provider decides to pull Wireguard into their tree.

Jason, I bet you're pretty happy about the uptake of Wireguard but
that popularity and distribution has consequences.  Small things have
huge ramifications for developers all over the place who now have to
keep up with your work and do backports of your fixes.
