Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71995A468B
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 01:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfHaX2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 19:28:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56071 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHaX2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 19:28:02 -0400
Received: by mail-io1-f71.google.com with SMTP id i2so8080887iof.22
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 16:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DF0M02XSKSG9Ky5Dz+j/9n/5tv2umgn8yDW6MUegt08=;
        b=gomVG2MnzP7eDR0CsC6xp7mV+toYFUYY6ZOq9yMR1lLzeQfNvMtWZ1r35ZCddmTu3N
         EzkKJxf162QNz5FPXiNVA13YKJZq8oD3GQuE9D56CJWrkwJ4F9BidjjFjCj3TBdRaDM3
         gkfHUrJXD+df+jFAknHDFfpgUtGhFh3gX9Zf5wD+LFFJxZ3X8JJYQvIlgABYlL4Awgdg
         LkM7HwMQVkudQ41Ctm6xqMlOHXw0rbuzi59hz5QLRoxolhv0I9e7xe4Pgu2bxwlVsdf5
         TiZLp0CuJt5psZUPCSQJ3WBWFY6mGl0HA5YERcy96RiY6kfePz0I/2HhfWZrlKE6Ocju
         zGSw==
X-Gm-Message-State: APjAAAVHficu+TtTjYteiyZ8W70thAgQyFlaJlj10UozdvNtKomNgQ3X
        J9CzEzB0ZmPHnPL6+0I+CMf3VTOLNmKLgRocTbHGrXmzmR/y
X-Google-Smtp-Source: APXvYqxE+/QPd0YyE0CRJ7ZUYgbX8l8AKlELMS2qzspSJoXFaK8yVey/1Bn7C0LONcGhXNF7+6dkbIAQ/o2msjszjCFAtAcBAouU
MIME-Version: 1.0
X-Received: by 2002:a5e:c914:: with SMTP id z20mr6545534iol.272.1567294081178;
 Sat, 31 Aug 2019 16:28:01 -0700 (PDT)
Date:   Sat, 31 Aug 2019 16:28:01 -0700
In-Reply-To: <21753.1567081045@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f7a0b3059172166c@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_put_peer
From:   syzbot <syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com

Tested on:

commit:         48b9e92a rxrpc: Fix lack of conn cleanup when local endpoi..
git tree:        
git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=230542aa16bfc4b0
dashboard link: https://syzkaller.appspot.com/bug?extid=b9be979c55f2bea8ed30
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
