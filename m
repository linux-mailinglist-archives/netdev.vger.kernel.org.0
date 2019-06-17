Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2990478D0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 05:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfFQDpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 23:45:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfFQDpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 23:45:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69E4C14DB1C4C;
        Sun, 16 Jun 2019 20:45:53 -0700 (PDT)
Date:   Sun, 16 Jun 2019 20:45:52 -0700 (PDT)
Message-Id: <20190616.204552.1290065029514400171.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     jishi@redhat.com, weiwan@google.com, dsahern@gmail.com,
        kafai@fb.com, edumazet@google.com,
        matti.vaittinen@fi.rohmeurope.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] selftests: pmtu: List/flush IPv4 cached
 routes, improve IPv6 test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1560562631.git.sbrivio@redhat.com>
References: <cover.1560562631.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 20:45:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Sat, 15 Jun 2019 03:38:16 +0200

> This series introduce a new test, list_flush_ipv4_exception, and improves
> the existing list_flush_ipv6_exception test by making it as demanding as
> the IPv4 one.

I suspect this will need a respin because semantics are still being discussed
and I seem to recall a mention of there being some conflict with some of
David A's changes.
