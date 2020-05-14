Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB61D3DEC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgENTt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727833AbgENTtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:49:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354B2C061A0C;
        Thu, 14 May 2020 12:49:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7E8E128CF135;
        Thu, 14 May 2020 12:49:54 -0700 (PDT)
Date:   Thu, 14 May 2020 12:49:54 -0700 (PDT)
Message-Id: <20200514.124954.1909205796405577142.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH RESEND net-next] selftests: fix flower parent qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514063552.26678-1-vladbu@mellanox.com>
References: <20200514063552.26678-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:49:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 14 May 2020 09:35:52 +0300

> Flower tests used to create ingress filter with specified parent qdisc
> "parent ffff:" but dump them on "ingress". With recent commit that fixed
> tcm_parent handling in dump those are not considered same parent anymore,
> which causes iproute2 tc to emit additional "parent ffff:" in first line of
> filter dump output. The change in output causes filter match in tests to
> fail.
> 
> Prevent parent qdisc output when dumping filters in flower tests by always
> correctly specifying "ingress" parent both when creating and dumping
> filters.
> 
> Fixes: a7df4870d79b ("net_sched: fix tcm_parent in tc filter dump")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied, thanks.
