Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFC1C9FF5
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHBL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHBL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:11:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F965C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:11:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CEBC119376DE;
        Thu,  7 May 2020 18:11:26 -0700 (PDT)
Date:   Thu, 07 May 2020 18:11:25 -0700 (PDT)
Message-Id: <20200507.181125.768030125933881729.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/5] bonding: report transmit status to callers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:11:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 May 2020 09:32:17 -0700

> First patches cleanup netpoll, and make sure it provides tx status to its users.
> 
> Last patch changes bonding to not pretend packets were sent without error.
> 
> By providing more accurate status, TCP stack can avoid adding more
> packets if the slave qdisc is already full.
> 
> This came while testing latest horizon feature in sch_fq, with
> very low pacing rate flows, but should benefit hosts under stress.

Looks good, series applied, thanks Eric.
