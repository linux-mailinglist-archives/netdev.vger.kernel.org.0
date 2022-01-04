Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086C24849DE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiADVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:30:09 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:46616 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiADVaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 16:30:08 -0500
Received: by mail-il1-f200.google.com with SMTP id i9-20020a056e021d0900b002b3e956903dso20375110ila.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 13:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e6I0sXk0inEAmUtslAEVQcGILPxuytb3N8HHWOakOdw=;
        b=xq29XYlDC+/yOy0myG6ilU6QG3IpJ7pDHI7E4brNJsMtAvtV3yGAAlvoGzZFFPj/na
         lFsq0IEWn9Ze1z8ocBde0yfoywjyWrmxLQ8aW+bAVhsJ78jtJjM0QSkKYkd2v75k2kra
         W0nMaDdbWLO1wjZ7n7bVIgr1AwxvoDqI5/UMJg6+ZQJTbv1KRfrYErksf2uc74HuVVah
         C1uHyzpZhaYr5hui3eZwqeuqagm2c6O8xwU9IHp/NDP4fsrVbOsX5eqYF8pAHSAPY74s
         X3/Z4fucYKKbllnihw5zV886nnZUVOZSRJnV9fs4m78+guA290r4DWlShlVrJNHtHbo5
         zT3w==
X-Gm-Message-State: AOAM531c7SfevfMeKJOt3i6jVumIx4V5R113Yernt6nTE19SrJJFm19x
        5clv95tV1xlkMmoItTLs6q0qNY8ShqHL8RGZRLo5c2dH73px
X-Google-Smtp-Source: ABdhPJxHxHS62rmxnySIB7LL5Hkxm0+ir1wzDfJwCxZ28ZsFukFgZ860i+kkpdeJ7KV3ozFNrZMdmc6jxoOkzia9Rlykuj55yTwN
MIME-Version: 1.0
X-Received: by 2002:a02:b603:: with SMTP id h3mr24957080jam.233.1641331808274;
 Tue, 04 Jan 2022 13:30:08 -0800 (PST)
Date:   Tue, 04 Jan 2022 13:30:08 -0800
In-Reply-To: <61d4b9354cf9b_4679220874@john.notmuch>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064109905d4c8577b@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_prog_put
From:   syzbot <syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lmb@cloudflare.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com

Tested on:

commit:         e63a0234 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       bpf-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=29c60dfdc879c48e
dashboard link: https://syzkaller.appspot.com/bug?extid=bb73e71cf4b8fd376a4f
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13c1d0adb00000

Note: testing is done by a robot and is best-effort only.
