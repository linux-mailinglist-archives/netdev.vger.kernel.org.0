Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2773D22DCFE
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgGZHqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGZHqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 03:46:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC30C0619D2;
        Sun, 26 Jul 2020 00:46:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::460])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C3271277D61E;
        Sun, 26 Jul 2020 00:30:02 -0700 (PDT)
Date:   Sun, 26 Jul 2020 00:46:44 -0700 (PDT)
Message-Id: <20200726.004644.71243023033363639.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200726070311.GA16687@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
        <20200724.154342.1433271593505001306.davem@davemloft.net>
        <20200726070311.GA16687@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jul 2020 00:30:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sun, 26 Jul 2020 09:03:11 +0200

> On Fri, Jul 24, 2020 at 03:43:42PM -0700, David Miller wrote:
>> > Changes since v1:
>> >  - check that users don't pass in kernel addresses
>> >  - more bpfilter cleanups
>> >  - cosmetic mptcp tweak
>> 
>> Series applied to net-next, I'm build testing and will push this out when
>> that is done.
> 
> The buildbot found one warning with the isdn debug code after a few
> days, here is what I think is the best fix:

I already fixed this in net-next.
