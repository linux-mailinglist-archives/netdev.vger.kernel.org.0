Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2A22B94B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGWWU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:20:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:35839 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgGWWU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 18:20:26 -0400
IronPort-SDR: t4OO8tqPfFYciiZuw1MIksYkpFU3i/ZXYf7aRuTzcPjCCZBjZFpf0q3aMF8WO2oHxiid77Tyeg
 sAb4nUaV0+kQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235507883"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235507883"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 15:20:25 -0700
IronPort-SDR: yU7OE+rmgHw4khpoV1uJpTIgloiygbWArkgqlvE0P1BFb7MbmA2T43gtMfduXZR7tMZMrZHO2d
 S0nJLK4emQ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="327149689"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2020 15:20:22 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jyjZd-003i9Q-IK; Fri, 24 Jul 2020 01:20:21 +0300
Date:   Fri, 24 Jul 2020 01:20:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     syzbot <syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com>
Cc:     andy@greyhouse.net, andy@infradead.org, arnd@arndb.de,
        davem@davemloft.net, dvhart@infradead.org,
        gregkh@linuxfoundation.org, j.vosburgh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, platform-driver-x86@vger.kernel.org,
        skunberg.kelsey@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vfalico@gmail.com
Subject: Re: kernel BUG at net/core/dev.c:LINE! (3)
Message-ID: <20200723222021.GY3703480@smile.fi.intel.com>
References: <000000000000ba65ba05a2fd48d9@google.com>
 <000000000000467ece05ab223d81@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000467ece05ab223d81@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 02:07:08PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 5a707af10da95a53a55011a612e69063491020d4
> Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date:   Fri Apr 21 13:36:06 2017 +0000
> 
>     platform/x86: wmi: Describe function parameters

Seems like random commit for known problem.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a9ad40900000
> start commit:   994e99a9 Merge tag 'platform-drivers-x86-v5.8-2' of git://..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a9ad40900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a9ad40900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e944500a36bc4d55
> dashboard link: https://syzkaller.appspot.com/bug?extid=af23e7f3e0a7e10c8b67
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ea63cf100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14afdb9f100000
> 
> Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com
> Fixes: 5a707af10da9 ("platform/x86: wmi: Describe function parameters")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

-- 
With Best Regards,
Andy Shevchenko


