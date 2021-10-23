Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F494381E8
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 06:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhJWEwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 00:52:33 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49092 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhJWEw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 00:52:29 -0400
Received: by mail-io1-f70.google.com with SMTP id c10-20020a5e8f0a000000b005ddce46973cso4639563iok.15
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 21:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=mvePd5L1eky6kii+wlkb5JDOZo/0Hv/Enm522ESKj7E=;
        b=G/lMjlV4AqeXoCLt9c48RRe57QFIpeot8Nl0YuYkHpurXiR3dXZohTADNTmYEUfm2u
         SgV5ITFjn/1luSTH89vPVyJp+R1B6kj3XwE6mhv+M7LULIwcFvO0yT6cRHHXY7U58Xm+
         N2ejR0kIk0QTx0S2hZm4Hfh7K4z6M3JlaIjzcN9jvl0cQ2nZ+M4pcxadGTKpC8kCzPvf
         6HEY83q2pEDyYMJMhAkr4IjEqxdRkMEMWD8TTMuxBjX8lxSpoLCvNIVkrgdZwpUA0zOl
         EKFje1LPVTKzF3kPVMV3hdUuL9borFkEevc+munqNoQfUkWqNL33FSwGJbIPzJ8DT64Y
         Vj7w==
X-Gm-Message-State: AOAM533wUH+hK+sZumBQW5JSHHEtdFd8vuSU97hWjC7awsfbKavKIL1O
        b9qvZfiyZA7cVDPoMi8WCXzu/63aQ1+SbauY7YWcvhJuGuX8
X-Google-Smtp-Source: ABdhPJzRejzoVuLjfxevXfIloGzhEE6WWMlDeOnHot44VK+A6KSR1zzyIrdx+0ZzffS+srM4B1JAZTs2vGvwqF8jcfAbuC1g48SW
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1504:: with SMTP id g4mr2343090iow.133.1634964610411;
 Fri, 22 Oct 2021 21:50:10 -0700 (PDT)
Date:   Fri, 22 Oct 2021 21:50:10 -0700
In-Reply-To: <5e29e63c-d2b5-ae72-0e33-5a22e727be3c@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2f5fa05cefddcf0@google.com>
Subject: Re: [syzbot] WARNING in batadv_nc_mesh_free
From:   syzbot <syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        paskripkin@gmail.com, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com

Tested on:

commit:         9c0c4d24 Merge tag 'block-5.15-2021-10-22' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d95853dad8472c91
dashboard link: https://syzkaller.appspot.com/bug?extid=28b0702ada0bf7381f58
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1553d4c4b00000

Note: testing is done by a robot and is best-effort only.
