Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C755A155
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfF1QtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:49:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:49:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C826814E03B36;
        Fri, 28 Jun 2019 09:49:05 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:49:05 -0700 (PDT)
Message-Id: <20190628.094905.1673194288384587104.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 00/10] pull request for net-next: batman-adv 2019-06-27
 v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:49:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 28 Jun 2019 15:55:54 +0200

> here is the updated feature/cleanup pull request of batman-adv for net-next
> from yesterday. Your change suggestions have been integrated into Patch 6
> of the series, everything else is unchanged.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.

I think that when you have the read_lock held, RCU is not necessary in order
to use __in6_dev_get() but I may be mistaken.  Just FYI...
