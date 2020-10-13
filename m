Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2793A28D632
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgJMVZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 17:25:22 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39390 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbgJMVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 17:25:22 -0400
Received: by mail-il1-f200.google.com with SMTP id r10so926192ilq.6
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 14:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=60+Mxk64iVZf267Dg3ol8mIlWkb77pqGXvVvfjK/8nw=;
        b=Iatl5bKP6aULhqN9z88CCySfYSUV8N8iK+5Ek0MD0cirWwvtxQqmwNXU5I3m0M7vMd
         ZFg8GQysuGwKk+MVRFIh98mpaPhSAEkVUehq8zbgEyFNpH71Jlj35u0gGfQkzItPSXNJ
         Z921G1FbM7ERAZgNREz7QrXTR/+NOoKm7a45Uk1KB3dSh0/WZcRUirjhQj7+rNuxTY3f
         94wTpuzaiD3lpjZDXNAULd+8CElyEglskCayo/zsRZdwxJgdgW8eW92Knq8bw8INbsrc
         mS8setWby4e8rQmL7GyxvoVz5s6v+hmWqM9x1/8AWV1lA6/fdAxZ0ARZ9CK7pXsgtbZt
         fh4A==
X-Gm-Message-State: AOAM531lhwzsRddld5wPpEOk01wZYX0PO7kSyww0hJm0Psh/66sInkAB
        J1QzpWRE6YV2UYtM/jVgRhBWZIbQkqf1adytP+dYWau8Ph5k
X-Google-Smtp-Source: ABdhPJwVhtVDseEa8IeraqGregoatXB0F17k95IZ5AfbScIuet/lSzLcYkP/8yRPqJa5oVjbN8dBctmR1jNS5xjocfQvr1FCD3R/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:ca3:: with SMTP id 3mr1517139ilg.95.1602624321356;
 Tue, 13 Oct 2020 14:25:21 -0700 (PDT)
Date:   Tue, 13 Oct 2020 14:25:21 -0700
In-Reply-To: <000000000000a03f8d05ae7c9371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000620d5805b1940d15@google.com>
Subject: Re: WARNING: can't access registers at asm_sysvec_reschedule_ipi
From:   syzbot <syzbot+853f7009c5c271473926@syzkaller.appspotmail.com>
To:     alexandre.chartre@oracle.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    64a632da net: fec: Fix phy_device lookup for phy_reset_aft..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11580c80500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
dashboard link: https://syzkaller.appspot.com/bug?extid=853f7009c5c271473926
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c1bc6f900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+853f7009c5c271473926@syzkaller.appspotmail.com

WARNING: can't access registers at asm_sysvec_reschedule_ipi+0x12/0x20 arch/x86/include/asm/idtentry.h:586

