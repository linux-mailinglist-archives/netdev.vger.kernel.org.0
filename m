Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1821903AE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 03:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgCXCrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 22:47:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35108 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgCXCrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 22:47:06 -0400
Received: by mail-io1-f72.google.com with SMTP id c10so7121864ioc.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 19:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LOv2WyxOQNJMMiel1AjLpQJL3nLG4+bZfZZebAkOi9k=;
        b=NoGVzbSKUM8KdOFbW8UnClOF7Rnjz7XIM9sO/YCYe9qDC4s5QQynR65bP1aDZ2cCWJ
         j79Ec7H8NxLt7xBRlGUPYx1G12u4zUH1Q11/42mCAVJYXxhzObPLtFOTcimhkj5qVTDw
         ENRKJNOm1UxvB4S3L9RD3Z9+Rd6CFFeScKKEuBGcRYmFhJLhbbelEayxw2H2M+5EvFjl
         AyXfFDfzbSdFXFiNnco4ejqQH0lPFepZTvI5CX5kZC8ssFFKV3VXy/KWGnETmVXHveta
         UBCCLDES9O2d4wrCfOATJ+RBHu36y5HLCmi/+6cNru3n+DRpwISO372gfUhtLVLa967j
         k5VA==
X-Gm-Message-State: ANhLgQ165MC4ZbhcZVewM0EpjJt/n9DrRy3LdDzkL8hT0dX6trgaTnQ5
        qWDAhtjnGhAQWOZAElYk6UqDM7gMhYbClZ4AiEtPCY7lBX3V
X-Google-Smtp-Source: ADFU+vstiI7NkY8P0sLiaAwA1tlgY+DAUVfkvxxrtQc1GUcIriiMD4ZAGZsTUHBhY7pwHk2p3ulODfmE2r7ZpymGWtd3GqW4WeUB
MIME-Version: 1.0
X-Received: by 2002:a02:6cd5:: with SMTP id w204mr22866930jab.43.1585018023533;
 Mon, 23 Mar 2020 19:47:03 -0700 (PDT)
Date:   Mon, 23 Mar 2020 19:47:03 -0700
In-Reply-To: <000000000000a6f2030598bbe38c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004162e805a190c456@google.com>
Subject: Re: WARNING in wp_page_copy
From:   syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andriin@fb.com, ast@kernel.org,
        bjorn.topel@intel.com, bpf@vger.kernel.org,
        catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com, jmoyer@redhat.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com,
        justin.he@arm.com, kafai@fb.com, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit c3e5ea6ee574ae5e845a40ac8198de1fb63bb3ab
Author: Kirill A. Shutemov <kirill@shutemov.name>
Date:   Fri Mar 6 06:28:32 2020 +0000

    mm: avoid data corruption on CoW fault into PFN-mapped VMA

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1170c813e00000
start commit:   e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fd9fb1e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: mm: avoid data corruption on CoW fault into PFN-mapped VMA

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
