Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B368244752E
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhKGTMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhKGTMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 14:12:53 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CFDC061570;
        Sun,  7 Nov 2021 11:10:10 -0800 (PST)
Received: from localhost (225.159.143.150.dyn.plus.net [150.143.159.225])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 345F74FE7B833;
        Sun,  7 Nov 2021 11:10:05 -0800 (PST)
Date:   Sun, 07 Nov 2021 19:09:59 +0000 (GMT)
Message-Id: <20211107.190959.1432110661171124830.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     omosnace@redhat.com, netdev@vger.kernel.org, kuba@kernel.org,
        lucien.xin@gmail.com, richard_c_haines@btinternet.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhQwpKWBF2S=vTutBVXeY9xSfTRuhK9nM9TariLVUSweMA@mail.gmail.com>
References: <20211104195949.135374-1-omosnace@redhat.com>
        <CAHC9VhQwpKWBF2S=vTutBVXeY9xSfTRuhK9nM9TariLVUSweMA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 07 Nov 2021 11:10:07 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Sun, 7 Nov 2021 09:12:57 -0500

> 
> When we change things as significantly as we are doing here, i.e.
> shifting some of the labeling away from the endpoint to the
> association, I much rather we do it as a chunk/patchset so that we can
> review it in a consistent manner.  Some of that has gone out the door
> here because of what I view as recklessness on the part of the netdev
> folks, but that doesn't mean we need to abandon all order.  Let's get
> all the fixes and repairs queued up in a single patchset so that we
> can fully see what the end result of these changes are going to look
> like.  Further, I think it would be good if at least one of the
> patches has a very clear explanation in the commit description (not
> the cover letter, I want to see this in the git log) of what happens

Cover letters show up in the merge commit log message for the patch
series so they show up in the git commit log.

Paul, please stop being so difficult and let's fix this.

Thank you.

