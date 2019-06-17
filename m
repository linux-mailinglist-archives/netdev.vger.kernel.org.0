Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DFE47F84
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfFQKUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbfFQKUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 06:20:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19EA390C87;
        Mon, 17 Jun 2019 10:20:23 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A68B12C91;
        Mon, 17 Jun 2019 10:20:17 +0000 (UTC)
Date:   Mon, 17 Jun 2019 12:20:13 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jishi@redhat.com, weiwan@google.com, dsahern@gmail.com,
        kafai@fb.com, edumazet@google.com,
        matti.vaittinen@fi.rohmeurope.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] selftests: pmtu: List/flush IPv4 cached
 routes, improve IPv6 test
Message-ID: <20190617122013.37a22626@redhat.com>
In-Reply-To: <20190616.204552.1290065029514400171.davem@davemloft.net>
References: <cover.1560562631.git.sbrivio@redhat.com>
        <20190616.204552.1290065029514400171.davem@davemloft.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 17 Jun 2019 10:20:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Jun 2019 20:45:52 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stefano Brivio <sbrivio@redhat.com>
> Date: Sat, 15 Jun 2019 03:38:16 +0200
> 
> > This series introduce a new test, list_flush_ipv4_exception, and improves
> > the existing list_flush_ipv6_exception test by making it as demanding as
> > the IPv4 one.  
> 
> I suspect this will need a respin because semantics are still being discussed

Maybe not a respin, because we're discussing netlink semantics and how
many past versions of iproute2 need to work, whereas user interface and
expectations of fixed, recent kernel/iproute2 are untouched.

Anyway, sure, it doesn't make sense to merge this before the fix is
final -- I'll resend then.

This prompts some questions though (answer this quick survey and win a
patch for netdev-FAQ.rst): when (and against which tree) do tests that
are fixed by a recent patch need to be submitted? Is it a problem if
the test is merged before the fix? Would a "dependency" note help?

> and I seem to recall a mention of there being some conflict with some of
> David A's changes.

That was for e28799e52a0a ("selftests: pmtu: Introduce
list_flush_ipv6_exception test case") on top of 438a9a856ba4 ("selftests: pmtu:
Add support for routing via nexthop objects"), but you already fixed the
conflict.

That test case, by the way, will also fail until we agree on the fix.

-- 
Stefano
