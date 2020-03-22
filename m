Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ECD18EB4D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCVSCE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 22 Mar 2020 14:02:04 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:33276 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgCVSCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:02:04 -0400
Received: by mail-io1-f69.google.com with SMTP id w25so323177iom.0
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=gKaSt4ZxxQs34ChfXVL8Hym0FPD2YC0tVneuWnb771k=;
        b=b6JpwT+bn8bOxonswYPef5o6KAdqqWdwJOtUlhjz1IPRK+gsJioAREMLV26OPPFSGg
         ENQrCwXbNgbOIYm7Wbyqaus4KuGhmM62HaYKtP43m8/i99XndtdtO4zMGPhUJCPArmse
         F6eGzITtzAefTl9widzhZpAyQNRuSX24bqe1cGDktbWc47hDTIp3OiFKx3m77R+/P44i
         zxSjIwoSWtXXtDYUMU+SnzTOuvN4+7ZqYHkTIz6Hxu6vy/IQVn7W51QwIfNv1mueT8rm
         w8zScAyNLyPYZYiiuvZWVt+oexzskJ09Uf3QaN+1nVCPtpfCdoVjpplgW/UHi1NOCGmJ
         3d/g==
X-Gm-Message-State: ANhLgQ3nuLRcO47qfe7jcBCnCOlTw8wNdHqFz35lXsfZ+A6konCUw/fZ
        7RJf4Fa7fI28l1fj95r/tAkJSOBUyitzySI8Ug5CdITVSovp
X-Google-Smtp-Source: ADFU+vsE6MYXnGyJNqw2vLGTU0rbWrO9cnQWa5eMVntpxhMHOkrc8SQ0+ppZ6IOnLHjd2xBOscF9K+YA+EakNro3nJqvZIEq+m22
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4c6:: with SMTP id f6mr17550477ils.272.1584900123891;
 Sun, 22 Mar 2020 11:02:03 -0700 (PDT)
Date:   Sun, 22 Mar 2020 11:02:03 -0700
In-Reply-To: <000000000000dd68d0059c74a1db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e39e1b05a1755045@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
From:   syzbot <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, allison@lohutok.net,
        aryabinin@virtuozzo.com, coreteam@netfilter.org,
        davem@davemloft.net, elver@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c6cb73e00000
start commit:   244dc268 Merge tag 'drm-fixes-2020-01-19' of git://anongit..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1104c495e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
