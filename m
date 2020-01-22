Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E68144A57
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAVDUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:20:01 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47435 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgAVDUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:20:01 -0500
Received: by mail-il1-f197.google.com with SMTP id x69so3777821ill.14
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 19:20:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Q+V6MdfziKIz0rbDvk/UXGQIlbKYZGAYXmvHdG0XHko=;
        b=pPgprCl1uIi1aGtDEyqg0twlVU/mdDqewTOeE/sCv7+aZndNDGcTW5vgtAqehFvhY1
         UQfRbPlXqnFiwZ2//jx4oYhMbkAPTH57W6IYcQ9sraFeVxTHlYOpw5/mzizM2zJTnqCN
         bilJXkwPHUlPCi/DB5BEhnDgsloINsjNo7cKtYmzDMMue4GqOwUxvbaTAVrCkt9BSr/0
         6QtNuVHMcSG/G88ADQDtcksNUeUDRWCC7xbcX/NMeT0NLnd3L405fT3dkIUOcGCai9ar
         APuzmr8z5zsuSTbXUiF8cBjWj0+q5NcDGSzwlBIa/7pn1IHCivknutU1RgvV4ykZrriu
         Sfcg==
X-Gm-Message-State: APjAAAXqYpNptYCQY4PRteCc5ZClQZScYFpvqQjP9/EanKK67ROSm/9Q
        wh37O1zB8s9sIMF1fHxwKLvYHzdYeKKDxXxYI/gSnDf4R/Lb
X-Google-Smtp-Source: APXvYqy+uydHS2wj8B3br4rKAZaNttmqlZ2vOJL3KADXaffFC3CoRkqx64UrmHbPL/Z+BdkU6gah06YpVkq7VIafjd3pXuRhagi3
MIME-Version: 1.0
X-Received: by 2002:a92:860f:: with SMTP id g15mr6227655ild.297.1579663201195;
 Tue, 21 Jan 2020 19:20:01 -0800 (PST)
Date:   Tue, 21 Jan 2020 19:20:01 -0800
In-Reply-To: <000000000000310afa059cabd024@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8dfac059cb1ff9b@google.com>
Subject: Re: WARNING in cbq_destroy_class
From:   syzbot <syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, echaudro@redhat.com, ivecera@redhat.com,
        jhs@mojatatu.com, jiri@mellanox.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit d51aae68b142f48232257e96ce317db25445418d
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Mon Nov 27 17:37:21 2017 +0000

    net: sched: cbq: create block for q->link.block

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12efb80de00000
start commit:   80892772 hsr: Fix a compilation error
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11efb80de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16efb80de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=0a0596220218fcb603a8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f107d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12114335e00000

Reported-by: syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com
Fixes: d51aae68b142 ("net: sched: cbq: create block for q->link.block")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
