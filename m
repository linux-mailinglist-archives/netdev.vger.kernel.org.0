Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EB31236DA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 21:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfLQUQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 15:16:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:37869 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfLQUQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 15:16:02 -0500
Received: by mail-il1-f197.google.com with SMTP id t19so10364732ila.4
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 12:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Zl7jDCng4WsJS3fDlSVM0kBHR2q0XfgZ7N4MzVpx9q0=;
        b=E03wW+dszkghSOxFmZ9UAdfaNXLbEyFk/o1kQXETCgcRW3p965plSi5Cj3XPj4Qiwz
         KndTiZnUUYbsM2cPTF6rSzDp/c4np7H1ElJIbUm3hwtTRWP2EgVoigE1PMSTcWv+fGGj
         fi0hA1J32UCL/2qduREbi0/Yq4Qphzi6QwptKSAB4vP9GvxJAf4IWSQJ9IWuiz5zKpGz
         PB8waE/cuRQn0h8W4BqBGOnZZZE/cYt9ED0GEW+9NmoMtlh5Q5E+RS7+SxkWyvdlAJmQ
         SAC/NnIvVdyPhPEOl2whDwuS1nmVqSmrjp2HHGzfR4Y21EveQYgmvcZSDxyaqOfeI0Mj
         SX6A==
X-Gm-Message-State: APjAAAWlMj8lHMQfKOeRRUgvwPxmVSNp+8afrna/RsMiDdAPWBCyVi7z
        5L/h2DZmPOuyow7WOM/E0h8W7ioDPjJOlkY7ULNlHfUi/ziD
X-Google-Smtp-Source: APXvYqzICrG8Yo/ALydErrhDqX93YfSSAQ85FdUg4jalGroBJiT3BB12c6HUe2ZyNSlzlRnSA4l2+EVqSg+tk5rH2iwmoObAicm0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:25cb:: with SMTP id d11mr3095867iop.263.1576613761732;
 Tue, 17 Dec 2019 12:16:01 -0800 (PST)
Date:   Tue, 17 Dec 2019 12:16:01 -0800
In-Reply-To: <000000000000a6f2030598bbe38c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037571c0599ebff87@google.com>
Subject: Re: WARNING in wp_page_copy
From:   syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bjorn.topel@intel.com,
        bpf@vger.kernel.org, catalin.marinas@arm.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com,
        justin.he@arm.com, kafai@fb.com, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        magnus.karlsson@gmail.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 83d116c53058d505ddef051e90ab27f57015b025
Author: Jia He <justin.he@arm.com>
Date:   Fri Oct 11 14:09:39 2019 +0000

     mm: fix double page fault on arm64 if PTE_AF is cleared

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1378f5b6e00000
start commit:   e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10f8f5b6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1778f5b6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fd9fb1e00000

Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com
Fixes: 83d116c53058 ("mm: fix double page fault on arm64 if PTE_AF is  
cleared")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
