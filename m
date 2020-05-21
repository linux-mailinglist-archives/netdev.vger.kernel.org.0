Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430851DC608
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 06:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgEUEB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 00:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgEUEBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 00:01:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE170C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 21:01:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CBC612769225;
        Wed, 20 May 2020 21:01:25 -0700 (PDT)
Date:   Wed, 20 May 2020 21:01:24 -0700 (PDT)
Message-Id: <20200520.210124.635320957617365187.davem@davemloft.net>
To:     sworley@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        sharpd@cumulusnetworks.com, anuradhak@cumulusnetworks.com,
        roopa@cumulusnetworks.com, sworley1995@gmail.com
Subject: Re: [PATCH] net: nlmsg_cancel() if put fails for nhmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520015712.1693005-1-sworley@cumulusnetworks.com>
References: <20200520015712.1693005-1-sworley@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 21:01:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Worley <sworley@cumulusnetworks.com>
Date: Tue, 19 May 2020 21:57:12 -0400

> Fixes data remnant seen when we fail to reserve space for a
> nexthop group during a larger dump.
> 
> If we fail the reservation, we goto nla_put_failure and
> cancel the message.
> 
> Reproduce with the following iproute2 commands:
 ...
> Fixes: ab84be7e54fc ("net: Initial nexthop code")
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>

Applied and queued up for -stable, thanks.
