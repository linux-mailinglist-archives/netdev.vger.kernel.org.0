Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C6B271E3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfEVVtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:49:02 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:54459 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbfEVVtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:49:01 -0400
Received: by mail-it1-f200.google.com with SMTP id k8so3396535itd.4
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 14:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TIQGF/z6Uv9dk4W4KZtT8M62kZhnd/SllJeeMECtlHs=;
        b=mtWcpjAS9XivjAiAddmtRXUKVg28f35wACgM2C1g35sL8YzMHCWp23fMbSqwdLmT1r
         JvrQ+MdgJcgNTMok3gopaJHcd7GUKAh7NymLTF6tzLRZn0b+uJHlhseYJbLiGxqkuXdK
         IJEE6JRsMq379HgSum/N4EDUkZ+pms0zTsejBTuNHHgXGHm0RAvUKkzqUS8k5/nJYQRo
         omt1ADj0qgc/lpEoQp+xH6WQh28B7CMs3IGaK0f6xfdLHTzlGJaGzFhLd3buRBqfGL20
         /TlaWU8L4+pUoejl4VeaEYLYpIR2J88UlCgyVHDvHZXHMoilJtjc3lNKUI1i8ZGh9Uf1
         Du5g==
X-Gm-Message-State: APjAAAUngSVrDGE1AEY9+M/+TGWf4Tw57y+N5Ak3BCP1vqkCguE1Yn73
        hCbVz5z2cR0ubTlFY0ujKMFBEkhPLbY55PXuRDYHvZd98qtU
X-Google-Smtp-Source: APXvYqx3pKlCIWImXjwTHYPQ2q7elS7eFooEn3z9joINI2kGSb5fVGpbdl7LNLXsN/Yjq2bq1zV8ffOmpetSZX7ITiCgllSz/ztC
MIME-Version: 1.0
X-Received: by 2002:a24:6292:: with SMTP id d140mr10402926itc.132.1558561740544;
 Wed, 22 May 2019 14:49:00 -0700 (PDT)
Date:   Wed, 22 May 2019 14:49:00 -0700
In-Reply-To: <000000000000fd342e05791cc86f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7e3a5058980ee7b@google.com>
Subject: Re: KASAN: use-after-free Read in sk_psock_unlink
From:   syzbot <syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 48a3c64b4649b5b23a4ca756af93b4ee820ff883
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 29 14:11:03 2018 +0000

     Merge tag 'drm-fixes-2018-06-29' of  
git://anongit.freedesktop.org/drm/drm

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f92d6ca00000
start commit:   f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13f92d6ca00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15f92d6ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=3acd9f67a6a15766686e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adf56ca00000

Reported-by: syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com
Fixes: 48a3c64b4649 ("Merge tag 'drm-fixes-2018-06-29' of  
git://anongit.freedesktop.org/drm/drm")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
