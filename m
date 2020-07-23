Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009A122B851
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGWVHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:07:09 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40115 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgGWVHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:07:09 -0400
Received: by mail-il1-f198.google.com with SMTP id z16so4354512ill.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xSJ7/AO/6lFKOpWNdlJkZ7IuUzYOAbFTfGyilIxrJTA=;
        b=bABCFiijSO2WjBZObsChlfwZC980+XhIEuESldQsUi5tb7k/HXQjrMmgbhWYO6qCPB
         LBCWPDU7X9rCgjtMAewEYka/t0Y76pZdE4mH3eH05Xyj03a0Dyez5egFNm/NSdU1qbci
         L2i9f6ACEQAirPMSZimAc8ZRdU44+O1oyHTEuLQ/3+F73hCUGutNPpU19ZnukF0ri7mm
         OTn3LClqSI5FJkrNJE/fqpsr9ynhDI1H6NH9LH4pSKJ3JFnD1iNGh3rv0DvC89V4+Iif
         MAuFtj/R8PCvg0Dp3C10YxqeVIHUnBaLbE8HH0GyZg8qDAJ7XDu/Cu/oRq//Ia6W0NoX
         4UHA==
X-Gm-Message-State: AOAM533r43kXwT2M6mPOBL8hILl87S8byCmWqQ42ysAkhLQ1t0vjiaAR
        F3l0TKHujTksgkC+QWi8gaDtI/ncXsEBERlm+UuHw0qIUFt/
X-Google-Smtp-Source: ABdhPJxYUTSFYLbJirO5SmxzloqaeYADQ3DxhbFAabRldIzWkPHkVFQjpT7AWxxHG1jFZHTks11qkmQ3pLU2rwcKL+yfzctTrFuc
MIME-Version: 1.0
X-Received: by 2002:a6b:4f19:: with SMTP id d25mr219660iob.190.1595538428817;
 Thu, 23 Jul 2020 14:07:08 -0700 (PDT)
Date:   Thu, 23 Jul 2020 14:07:08 -0700
In-Reply-To: <000000000000ba65ba05a2fd48d9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000467ece05ab223d81@google.com>
Subject: Re: kernel BUG at net/core/dev.c:LINE! (3)
From:   syzbot <syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com>
To:     andriy.shevchenko@linux.intel.com, andy@greyhouse.net,
        andy@infradead.org, arnd@arndb.de, davem@davemloft.net,
        dvhart@infradead.org, gregkh@linuxfoundation.org,
        j.vosburgh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, platform-driver-x86@vger.kernel.org,
        skunberg.kelsey@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5a707af10da95a53a55011a612e69063491020d4
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Fri Apr 21 13:36:06 2017 +0000

    platform/x86: wmi: Describe function parameters

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a9ad40900000
start commit:   994e99a9 Merge tag 'platform-drivers-x86-v5.8-2' of git://..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a9ad40900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a9ad40900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e944500a36bc4d55
dashboard link: https://syzkaller.appspot.com/bug?extid=af23e7f3e0a7e10c8b67
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ea63cf100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14afdb9f100000

Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com
Fixes: 5a707af10da9 ("platform/x86: wmi: Describe function parameters")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
