Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C596436958
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFFBlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:41:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfFFBlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:41:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1BEC144CBBF1;
        Wed,  5 Jun 2019 18:41:17 -0700 (PDT)
Date:   Wed, 05 Jun 2019 18:41:12 -0700 (PDT)
Message-Id: <20190605.184112.199298828409456934.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, zenczykowski@gmail.com,
        lorenzo@google.com, dsa@cumulusnetworks.com, thaller@redhat.com,
        yaro330@gmail.com
Subject: Re: [PATCH net] Revert "fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606012351.GA29571@archlinux-epyc>
References: <20190605042714.28532-1-liuhangbin@gmail.com>
        <20190605.175526.1448552541340120763.davem@davemloft.net>
        <20190606012351.GA29571@archlinux-epyc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 18:41:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 5 Jun 2019 18:23:51 -0700

> On Wed, Jun 05, 2019 at 05:55:26PM -0700, David Miller wrote:
>> From: Hangbin Liu <liuhangbin@gmail.com>
>> Date: Wed,  5 Jun 2019 12:27:14 +0800
>> 
>> > This reverts commit e9919a24d3022f72bcadc407e73a6ef17093a849.
>> > 
>> > Nathan reported the new behaviour breaks Android, as Android just add
>> > new rules and delete old ones.
>> > 
>> > If we return 0 without adding dup rules, Android will remove the new
>> > added rules and causing system to soft-reboot.
>> > 
>> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> > Fixes: e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied")
>> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> 
>> Applied.
> 
> Please ensure this gets queued up for stable, as that is where I noticed
> the issue.

It is queued up, thanks for asking.

I'll try to get this propagated as soon as possible.

Thanks again.
