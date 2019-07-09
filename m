Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97EEF63BBF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfGITOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:14:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44168 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfGITOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:14:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9682614020FFB;
        Tue,  9 Jul 2019 12:14:02 -0700 (PDT)
Date:   Tue, 09 Jul 2019 12:14:02 -0700 (PDT)
Message-Id: <20190709.121402.1804664264408465946.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     jiri@mellanox.com, roid@mellanox.com, yossiku@mellanox.com,
        ozsh@mellanox.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, aconole@redhat.com, wangzhike@jd.com,
        ronye@mellanox.com, nst-kernel@redhat.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        jpettit@ovn.org
Subject: Re: [PATCH net-next v6 0/4] net/sched: Introduce tc connection
 tracking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562657451-20819-1-git-send-email-paulb@mellanox.com>
References: <1562657451-20819-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 12:14:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Tue,  9 Jul 2019 10:30:47 +0300

> This patch series add connection tracking capabilities in tc sw datapath.
> It does so via a new tc action, called act_ct, and new tc flower classifier matching
> on conntrack state, mark and label.
 ...

Ok, I applied this, but two things:

1) You owe Cong Wang an explanation, a real detailed one, about the L2
   vs L3 design of this feature.  I did not see you address his feedback,
   but if you did I apologize.

2) Because the MPLS changes went in first, TCA_ID_CT ended up in a
   different spot in the enumeration and therefore the value is
   different.

Thanks.
