Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2180952B2
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfHTAU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:20:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbfHTAU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:20:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D86C14A6FBBE;
        Mon, 19 Aug 2019 17:20:27 -0700 (PDT)
Date:   Mon, 19 Aug 2019 17:20:26 -0700 (PDT)
Message-Id: <20190819.172026.1401776982746320439.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     gnault@redhat.com, haliu@redhat.com, edumazet@google.com,
        linus.luessing@c0d3.blue, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Fix return value of ipv6_mc_may_pull() for
 malformed packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819121252.5fccbef2@redhat.com>
References: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
        <20190814.125858.37782529545578263.davem@davemloft.net>
        <20190819121252.5fccbef2@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 17:20:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Mon, 19 Aug 2019 12:12:52 +0200

> I don't see this on net.git, but it's in your stable bundle on
> Patchwork. Should I resend? Thanks.

I applied it on my laptop while travelling and never pushed it out so it
just rot there, sorry.

Fixed, should be in 'net' now.
