Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639B104AC0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 07:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKUGXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 01:23:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKUGXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 01:23:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D75C14DE0F32;
        Wed, 20 Nov 2019 22:23:49 -0800 (PST)
Date:   Wed, 20 Nov 2019 22:23:48 -0800 (PST)
Message-Id: <20191120.222348.90358085054106479.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, jbenc@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv2 net-next] tcp: warn if offset reach the maxlen limit
 when using snprintf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120083808.16382-1-liuhangbin@gmail.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
        <20191120083808.16382-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 22:23:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 20 Nov 2019 16:38:08 +0800

> snprintf returns the number of chars that would be written, not number
> of chars that were actually written. As such, 'offs' may get larger than
> 'tbl.maxlen', causing the 'tbl.maxlen - offs' being < 0, and since the
> parameter is size_t, it would overflow.
> 
> Since using scnprintf may hide the limit error, while the buffer is still
> enough now, let's just add a WARN_ON_ONCE in case it reach the limit
> in future.
> 
> v2: Use WARN_ON_ONCE as Jiri and Eric suggested.
> 
> Suggested-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
