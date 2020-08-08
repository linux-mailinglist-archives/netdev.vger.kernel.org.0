Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5549C23F910
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgHHVWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgHHVWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:22:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83845C061756;
        Sat,  8 Aug 2020 14:22:09 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F0C012730D13;
        Sat,  8 Aug 2020 14:05:23 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:22:08 -0700 (PDT)
Message-Id: <20200808.142208.270913965963665073.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, viro@zeniv.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] net: Set fput_needed iff FDPUT_FPUT is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596714796-25298-1-git-send-email-linmiaohe@huawei.com>
References: <1596714796-25298-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 14:05:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Thu, 6 Aug 2020 19:53:16 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We should fput() file iff FDPUT_FPUT is set. So we should set fput_needed
> accordingly.
> 
> Fixes: 00e188ef6a7e ("sockfd_lookup_light(): switch to fdget^W^Waway from fget_light")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
