Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739CB28318C
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgJEIKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:10:07 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:50652 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgJEIKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:10:06 -0400
Received: by mail-io1-f79.google.com with SMTP id b16so4276647iod.17
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 01:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wVHJQXmamaTzNpIjudJa+tJEi3PnCwIpctdvTdQM7gU=;
        b=JyAfEyaJQ+VCKkVYaLPW0cd9ICrQ+NrYxqaPbn2XF/UmhlEMMQkFb0gw44wsjZ7MLK
         E8ZWzuOTKSWEaG35BRcXFP+EY3VM6Nr8VWwlawbGK2QCO15u16hDmGM3w3FIFAwlPZwX
         dbiTMGWZFw807t6x/3uj6d4GV4BYidCKzPe3cUJlz5lNuqnOltmrnBP1hoeU+ni7PZ07
         Z++chZee4cdV2DkrQfKG5nV3aplhhtPlL77jjuN/e5FcT4gbF/vbSSHZ057aR+VTNtux
         NLvuTyJOC3OQjI27jY9z9r0Va/iKElepdnLbCvH/8Ax7SGMiYVOnZ7W6ghfasTkXaflI
         ifiQ==
X-Gm-Message-State: AOAM532F2Fb1vkozLPVpzn4MkQXo6pr6LI+m7VZ87uXrpjpOTFZm3PXr
        2EfpZ6+Gs1Kx9QUAZ/WEljze/1JoWLTSZIViAIeuAvDuaDUc
X-Google-Smtp-Source: ABdhPJwLFvux9XYUgBTicBVZllZd+7+bLCC5QFjPKgmFSYx/o/20y7IdqANtYLl/dIXDmonWHbc42u2/up4MKxAISa6o88CQ0kNC
MIME-Version: 1.0
X-Received: by 2002:a02:887:: with SMTP id 129mr12505574jac.130.1601885405765;
 Mon, 05 Oct 2020 01:10:05 -0700 (PDT)
Date:   Mon, 05 Oct 2020 01:10:05 -0700
In-Reply-To: <000000000000b3d57105b05ab856@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000094e3c805b0e802a8@google.com>
Subject: Re: BUG: unable to handle kernel paging request in tcf_action_dump_terse
From:   syzbot <syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 0fedc63fadf0404a729e73a35349481c8009c02f
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Sep 23 03:56:24 2020 +0000

    net_sched: commit action insertions together

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c20657900000
start commit:   2172e358 Add linux-next specific files for 20201002
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c20657900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c20657900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70698f530a7e856f
dashboard link: https://syzkaller.appspot.com/bug?extid=5f66662adc70969940fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142fd4af900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ffcdeb900000

Reported-by: syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
