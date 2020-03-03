Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B251785E8
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgCCWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:50:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCCWui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:50:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEC3415A0BDB6;
        Tue,  3 Mar 2020 14:50:37 -0800 (PST)
Date:   Tue, 03 Mar 2020 14:50:37 -0800 (PST)
Message-Id: <20200303.145037.1729180451232843682.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
Subject: Re: [PATCH] ipv6: Use math to point per net sysctls into the
 appropriate struct net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303065434.81842-1-cambda@linux.alibaba.com>
References: <20200303065434.81842-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 14:50:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Tue,  3 Mar 2020 14:54:34 +0800

> The data pointers of ipv6 sysctl are set one by one which is hard to
> maintain, especially with kconfig. This patch simplifies it by using
> math to point the per net sysctls into the appropriate struct net,
> just like what we did for ipv4.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Applied, thanks.
