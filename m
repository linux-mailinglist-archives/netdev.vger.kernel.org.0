Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8D8E257
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 03:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfHOB0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 21:26:02 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197]:42082 "EHLO
        mail-oi1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfHOB0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 21:26:02 -0400
Received: by mail-oi1-f197.google.com with SMTP id l11so15407oif.9
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 18:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ttLtpKYMG7TZIiRY6rerl+aSlij3EK8LczMw+lIahls=;
        b=F+A6ukmlIuPMRmXekdRJJ30VZo7xwDbKHoivJP8AhYSOaRq5w7A/DIbdXiUz6oG0rr
         1n1rSkrzO9qtMZHqxEyZB6k8Rtvpuw0taTtAHc/N7sz5bgs1PBMVGZFU5iZXWQxEKle5
         RfGWSO+Aza3OwcGp79mEyV73Qesn08xW4+zJSIsc95AvV2gx35QbGcpCBidFWqX/W2od
         m2FRyyrG3u3jk0tff+xoSDVPnq3MW+yqs/ytPcSGD+0BQ2iBvcjhNbwlRO37fC1eYI3T
         Zyl6WUL/9O6JxmUVd46qrkxGrL9T+6j+Vij1icwC9RmXr5T4gs3x8QpVgf/H16Z+c97K
         9EiQ==
X-Gm-Message-State: APjAAAXoKfChqR9EXPli38hZCFnXVJX0rs7PLS9Qf6fHTIWmyqSqAQpA
        vPdprZlknmo/FNNSI87Yos/B/Qg97eM7T/qz5M30EuHJZkxr
X-Google-Smtp-Source: APXvYqytQ/ELGP5+AJ2kRvyfVtkrEdnSzCYc+HmAHVK4EP5we3PzXTOJnMwkWDWnNNMXNALxzIO9aa+V7C7O9SGIfcOtTSnNTuWC
MIME-Version: 1.0
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr2888565ioc.97.1565832361042;
 Wed, 14 Aug 2019 18:26:01 -0700 (PDT)
Date:   Wed, 14 Aug 2019 18:26:01 -0700
In-Reply-To: <000000000000b851cb058f7e637f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a86cf005901dc156@google.com>
Subject: Re: WARNING in cgroup_rstat_updated
From:   syzbot <syzbot+370e4739fa489334a4ef@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, hdanton@sina.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=143286e2600000
start commit:   31cc088a Merge tag 'drm-next-2019-07-19' of git://anongit...
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=163286e2600000
console output: https://syzkaller.appspot.com/x/log.txt?x=123286e2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4dba67bf8b8c9ad7
dashboard link: https://syzkaller.appspot.com/bug?extid=370e4739fa489334a4ef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16dd57dc600000

Reported-by: syzbot+370e4739fa489334a4ef@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
