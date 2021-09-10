Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12D34068D1
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 11:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhIJJEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 05:04:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52014 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhIJJEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 05:04:39 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 800B24F69512E;
        Fri, 10 Sep 2021 02:03:26 -0700 (PDT)
Date:   Fri, 10 Sep 2021 10:03:21 +0100 (BST)
Message-Id: <20210910.100321.64569517393078303.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com
Subject: Re: [PATCH net 0/3] net: sched: update default qdisc visibility
 after Tx queue cnt changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210909231004.196905-1-kuba@kernel.org>
References: <20210909231004.196905-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 10 Sep 2021 02:03:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit when net-next opens back up.

Thank you!
