Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6EC87196
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405353AbfHIFh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:37:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfHIFh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:37:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51BF6143B7FE7;
        Thu,  8 Aug 2019 22:37:27 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:37:26 -0700 (PDT)
Message-Id: <20190808.223726.1572400328135187505.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 0/2] Fix batched event generation for skbedit action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
References: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:37:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Wed,  7 Aug 2019 15:57:27 -0400

> When adding or deleting a batch of entries, the kernel sends up to
> TCA_ACT_MAX_PRIO (defined to 32 in kernel) entries in an event to user
> space. However it does not consider that the action sizes may vary and
> require different skb sizes.
> 
> For example, consider the following script adding 32 entries with all
> supported skbedit parameters and cookie (in order to maximize netlink
> messages size):
 ...
> patch 1 adds callback in tc_action_ops of skbedit action, which calculates
> the action size, and passes size to tcf_add_notify()/tcf_del_notify().
> 
> patch 2 updates the TDC test suite with relevant skbedit test cases.

Series applied and queued up for -stable, thanks.
