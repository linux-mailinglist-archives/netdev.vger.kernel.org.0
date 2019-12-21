Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBF61287AC
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLUFwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:52:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57062 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:52:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83BBC153D9841;
        Fri, 20 Dec 2019 21:52:31 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:52:30 -0800 (PST)
Message-Id: <20191220.215230.743782564937736496.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, sd@queasysnail.net, sbrivio@redhat.com
Subject: Re: [PATCH net] selftests: pmtu: fix init mtu value in description
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191220070806.9855-1-liuhangbin@gmail.com>
References: <20191220070806.9855-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:52:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri, 20 Dec 2019 15:08:06 +0800

> There is no a_r3, a_r4 in the testing topology.
> It should be b_r1, b_r2. Also b_r1 mtu is 1400 and b_r2 mtu is 1500.
> 
> Fixes: e44e428f59e4 ("selftests: pmtu: add basic IPv4 and IPv6 PMTU tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
