Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B620FD89
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgF3UVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:21:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D039BC061755;
        Tue, 30 Jun 2020 13:21:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B36E41277D602;
        Tue, 30 Jun 2020 13:21:13 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:21:12 -0700 (PDT)
Message-Id: <20200630.132112.1161418939084868350.davem@davemloft.net>
To:     torvalds@linux-foundation.org
Cc:     edumazet@google.com, mathieu.desnoyers@efficios.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ycheng@google.com, joraj@efficios.com
Subject: Re: [regression] TCP_MD5SIG on established sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
References: <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
        <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
        <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:21:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 Jun 2020 12:43:21 -0700

> If you're not willing to do the work to fix it, I will revert that
> commit.

Please let me handle this situation instead of making threats, this
just got reported.

Thank you.

