Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010B31419B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfEERoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:44:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:44:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87EB214DA6480;
        Sun,  5 May 2019 10:44:24 -0700 (PDT)
Date:   Sun, 05 May 2019 10:44:24 -0700 (PDT)
Message-Id: <20190505.104424.957125919026107215.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH net] um: vector netdev: adjust to xmit_more API change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503182133.16856-1-johannes@sipsolutions.net>
References: <20190503182133.16856-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:44:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  3 May 2019 20:21:33 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Replace skb->xmit_more usage by netdev_xmit_more().
> 
> Fixes: 4f296edeb9d4 ("drivers: net: aurora: use netdev_xmit_more helper")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Seems to be a net-next only change, so I applied it there.

Thanks.
