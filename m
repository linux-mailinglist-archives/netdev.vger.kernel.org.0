Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51FA4C7D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfIAWsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 18:48:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37715 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfIAWsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 18:48:07 -0400
Received: by mail-io1-f69.google.com with SMTP id f24so8131596ion.4
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 15:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oZ7PvWIwxMv1/cng7QdJTXniFprQdIabY+CLNCeHUIU=;
        b=i+mxbY7zniumBSj989WMZ+Q0R/Vvun9XIDyLLy4pxDz6+wvYPqUk6Ux0tt1uzvHdOH
         tUkyP3BFukQKBScB6RR6MsR3XBIqJWEozWMY+K9HGhqe49tAGH5H9Sl32RFZ4Rq+WQYk
         +6szxs23V5fy1yZzl8tu3E72FM/kr0ijBoGxpF2x0W9bNxV1A/+jQz8Acd2JnRz9DOUO
         c5/pVnriivXeOD7QrUxafaRD6dhanz7TE3xJe8Ne7YkXhDiglzNFTFOaHMFNDbjL51Km
         5HjxEYYUNASx0R89lvmjrJ2UaSYmFPWwDgm0j5npWo9B7rbGZHUxHaJF70mBepTM3mtP
         hTUA==
X-Gm-Message-State: APjAAAUxAeCUJUs7hgUQElZMXgKvDCxLXtwkVLPczjYTvuJ3YI4ZJEOu
        mFkZuXEQ07ICVEICSbjYE8lBTehOz8NiiTto1QKLtV+0vZkI
X-Google-Smtp-Source: APXvYqxkOy9L/u3bMqXmgBaNVgEPTyYoJ1rsnAf2MDiw2d4CjHtOj2tKqoco+5DF2ypE6mSFR8x5mj40pTs1NqPNpKaYBkhbyw9g
MIME-Version: 1.0
X-Received: by 2002:a6b:d006:: with SMTP id x6mr30154654ioa.218.1567378086214;
 Sun, 01 Sep 2019 15:48:06 -0700 (PDT)
Date:   Sun, 01 Sep 2019 15:48:06 -0700
In-Reply-To: <0000000000009b3b80058af452ae@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ec274059185a63e@google.com>
Subject: Re: kernel panic: stack is corrupted in __lock_acquire (4)
From:   syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    38320f69 Merge branch 'Minor-cleanup-in-devlink'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d74356600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1bbf70b6300045af
dashboard link: https://syzkaller.appspot.com/bug?extid=83979935eb6304f8cd46
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1008b232600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:  
__lock_acquire+0x36fa/0x4c30 kernel/locking/lockdep.c:3907
CPU: 0 PID: 8662 Comm: syz-executor.4 Not tainted 5.3.0-rc6+ #153
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
Kernel Offset: disabled
Rebooting in 86400 seconds..

