Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645A2EE852
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfKDT3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:29:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDT3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:29:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55E95151D4FAE;
        Mon,  4 Nov 2019 11:29:02 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:29:01 -0800 (PST)
Message-Id: <20191104.112901.324102549371781151.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv6: use jhash2() in rt6_exception_hash()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104022416.100184-1-edumazet@google.com>
References: <20191104022416.100184-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:29:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun,  3 Nov 2019 18:24:16 -0800

> Faster jhash2() can be used instead of jhash(), since
> IPv6 addresses have the needed alignment requirement.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
