Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15413E49
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfEEHwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:52:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEHwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:52:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7F8A14C048DE;
        Sun,  5 May 2019 00:52:22 -0700 (PDT)
Date:   Sun, 05 May 2019 00:52:22 -0700 (PDT)
Message-Id: <20190505.005222.425677449950429602.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] openvswitch: check for null pointer return from
 nla_nest_start_noflag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501134158.15307-1-colin.king@canonical.com>
References: <20190501134158.15307-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 00:52:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed,  1 May 2019 14:41:58 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to nla_nest_start_noflag can return null in the unlikely
> event that nla_put returns -EMSGSIZE.  Check for this condition to
> avoid a null pointer dereference on pointer nla_reply.
> 
> Addresses-Coverity: ("Dereference null return value")
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you.
