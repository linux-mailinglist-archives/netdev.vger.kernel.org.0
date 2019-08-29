Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1410BA2B00
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfH2Xhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:37:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfH2Xhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:37:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EC30153BE269;
        Thu, 29 Aug 2019 16:37:45 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:37:42 -0700 (PDT)
Message-Id: <20190829.163742.2109211377942652910.davem@davemloft.net>
To:     lkp@intel.com
Cc:     wang.yi59@zte.com.cn, kbuild-all@01.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, cheng.lin130@zte.com.cn
Subject: Re: [PATCH] ipv6: Not to probe neighbourless routes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <201908300657.DY647BSw%lkp@intel.com>
References: <1566896907-5121-1-git-send-email-wang.yi59@zte.com.cn>
        <201908300657.DY647BSw%lkp@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:37:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


So yeah, this is one instance where the kbuild test robot's report is
making more rather than less work for us.

We identified the build problem within hours of this patch being
posted and the updated version was posted more than 24 hours ago.

The kbuild robot should really have a way to either:

1) Report build problems faster, humans find the obvious cases like
   this one within a day or less.

2) Notice that a new version of the patch was posted or that a human
   responded to the patch pointing out the build problem.

Otherwise we get postings like this which is just more noise to
delete.

Thanks.
