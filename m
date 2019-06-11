Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162FB3D5A2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391936AbfFKSk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:40:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391882AbfFKSk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:40:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3369C15259C8A;
        Tue, 11 Jun 2019 11:40:28 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:40:13 -0700 (PDT)
Message-Id: <20190611.114013.490520567201319930.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     jishi@redhat.com, weiwan@google.com, dsahern@gmail.com,
        kafai@fb.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: pmtu: Introduce
 list_flush_ipv6_exception test case
From:   David Miller <davem@davemloft.net>
In-Reply-To: <557584d1724aba01c3ba56c5c39173334e180db6.1559851698.git.sbrivio@redhat.com>
References: <557584d1724aba01c3ba56c5c39173334e180db6.1559851698.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:40:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Thu,  6 Jun 2019 22:15:09 +0200

> This test checks that route exceptions can be successfully listed and
> flushed using ip -6 route {list,flush} cache.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This will cause a minor conflict with David Ahern's patch:
> "[PATCH net-next 17/19] selftests: pmtu: Add support for routing
> via nexthop objects", currently under review. The "re-run with nh"
> flag for this test in the test list will need to be set to 1.
> 
> I can also re-submit this based on that patch, if it helps.

Applied, thanks.
