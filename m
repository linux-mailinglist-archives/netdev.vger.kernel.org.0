Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E341054F6
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfKUPAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:00:01 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:35419 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfKUPAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:00:01 -0500
Received: by mail-io1-f72.google.com with SMTP id h7so2449805ioh.2
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 07:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ss8b6/361E3xQgXhoZEYKHN2dErL3lbrsVOt2HQ4G28=;
        b=S+AiJ68++VgDiEXPfrEi8mzAEmRvtytOXpw03FR3STz3Eh2t1tXrkin4bA3Yj2DNxx
         iBBq5RrPxv2vUXj58SA+W7hkrOLiw6wGJZFhVpVlmiRs/VTNE63j9+Oh7wxtPWJejzef
         RHirfUYLmTS23kp/cpEUlfcodQVAGe3M0WUN1jUPkDkic6noQ4N0NZTH+ajTtCmRoNFF
         JiLRvOAD+fUg3JnhrLz7wS0pnUJn08ufRB28yXOMVJjFOp1dNi0MHaygS+VGZN+LCE29
         W6f2e5pbjzyqUNKZZ6K7ZUHxtaNKPSRlUUOVW6DECvHgNk/pvQ/EtcmN8scnNYX0TfCB
         kRIA==
X-Gm-Message-State: APjAAAUVNljnTqyMKfEBtGqq4OHX3LVzpu+t24H3M/XWUTVU0Yk+ntKE
        fbf+GA1apkfDXvS7OMFduxAlfwE4D22s1hCtNvgDd3zNcOCE
X-Google-Smtp-Source: APXvYqyCE3fIAS/eC3JiBF7ln0rcJKb0Mpnhw+NSQWlfaE9hNZqCT8kSX8wwCB901bHXK9fjJCwPCRFDQaQ+fjGMJaNsn83Bb8+C
MIME-Version: 1.0
X-Received: by 2002:a02:282:: with SMTP id 124mr9334489jau.6.1574348400631;
 Thu, 21 Nov 2019 07:00:00 -0800 (PST)
Date:   Thu, 21 Nov 2019 07:00:00 -0800
In-Reply-To: <000000000000de3c7705746dcbb7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c243a0597dc8d9d@google.com>
Subject: Re: KASAN: use-after-free Read in ccid_hc_tx_delete
From:   syzbot <syzbot+3967c1caf256f4d5aefe@syzkaller.appspotmail.com>
To:     alsa-devel@alsa-project.org, dan.carpenter@oracle.com,
        davem@davemloft.net, dccp@vger.kernel.org, gerrit@erg.abdn.ac.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        perex@perex.cz, syzkaller-bugs@googlegroups.com, tiwai@suse.com,
        tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit f04684b4d85d6371126f476d3268ebf6a0bd57cf
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu Jun 21 08:07:21 2018 +0000

     ALSA: lx6464es: Missing error code in snd_lx6464es_create()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dd11cae00000
start commit:   eb6cf9f8 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12dd11cae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14dd11cae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
dashboard link: https://syzkaller.appspot.com/bug?extid=3967c1caf256f4d5aefe
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11022ccd400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124581db400000

Reported-by: syzbot+3967c1caf256f4d5aefe@syzkaller.appspotmail.com
Fixes: f04684b4d85d ("ALSA: lx6464es: Missing error code in  
snd_lx6464es_create()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
