Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFCC9566
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfJCAMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:12:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJCAMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:12:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AF63155274EC;
        Wed,  2 Oct 2019 17:12:36 -0700 (PDT)
Date:   Wed, 02 Oct 2019 17:12:29 -0700 (PDT)
Message-Id: <20191002.171229.1495727500341484392.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: Re: [RFC PATCH v2 00/45] Multipath TCP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 17:12:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Wed,  2 Oct 2019 16:36:10 -0700

> The MPTCP upstreaming community has prepared a net-next RFCv2 patch set
> for review.

Nobody is going to read 45 patches and properly review them.

And I do mean nobody.

Please make smaller, more reasonable (like 12-20 MAX), patch sets to
start building up the MPTCP infrastructure.

This is for your sake as well as everyone else's.
