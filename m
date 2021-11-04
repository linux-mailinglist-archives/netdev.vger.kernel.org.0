Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F374451EC
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKDLFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhKDLE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:04:59 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC8C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 04:02:21 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4C6B14D2CB6AD;
        Thu,  4 Nov 2021 04:02:18 -0700 (PDT)
Date:   Thu, 04 Nov 2021 11:02:13 +0000 (GMT)
Message-Id: <20211104.110213.948977313836077922.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     lucien.xin@gmail.com, omosnace@redhat.com, netdev@vger.kernel.org,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-sctp@vger.kernel.org, kuba@kernel.org,
        marcelo.leitner@gmail.com, jmorris@namei.org,
        richard_c_haines@btinternet.com
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established
 hook in selinux
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
References: <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
        <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com>
        <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 04 Nov 2021 04:02:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Wed, 3 Nov 2021 23:17:00 -0400

> 
> While I understand you did not intend to mislead DaveM and the netdev
> folks with the v2 patchset, your failure to properly manage the
> patchset's metadata *did* mislead them and as a result a patchset with
> serious concerns from the SELinux side was merged.  You need to revert
> this patchset while we continue to discuss, develop, and verify a
> proper fix that we can all agree on.  If you decide not to revert this
> patchset I will work with DaveM to do it for you, and that is not
> something any of us wants.

I would prefer a follow-up rathewr than a revert at this point.

Please work with Xin to come up with a fix that works for both of you.

Thanks.
