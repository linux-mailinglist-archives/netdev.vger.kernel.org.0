Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DDA8F2C9
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732536AbfHOSGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:06:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44791 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbfHOSGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:06:01 -0400
Received: by mail-io1-f71.google.com with SMTP id s9so421875iob.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 11:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6O8fj8Cxesz95GcJ9dIMRrMkW2S+HMSqZq3eO7hi+58=;
        b=DN3K1+6ho00v4Yof3dSxJ4bz/wxfuMriW8mF4GnoA9MaNuB2nHs3/pamfj4UJ62Z0d
         nJKH1jLWHkCghKk0MTZKFanCBZTxB208D7V/rz8B+lQ4Oxm5VDTnZ9udQq9eYXXXHfxe
         3TLTfTU+IwSq0ue9QUZ2/3F4nDDK6aFAKmbmMXKQvp399P3pAQjgweQ1Y0ZsSELfUCUe
         p+/VxoMGBhwt5HN8kbnk5tQaJCyJyiXXB2ZVcSAcMKM1hHWsKSfipNoY+4nYJ6eeAtjS
         0vS/0zkghf3OMF86vkVNn/JAnBAwv0r9YpjHCOIGBTY+dorjfD6iXJZEx+Cn9TVHmLaY
         jGnw==
X-Gm-Message-State: APjAAAVUcFgdG4+j7j0wgicBb6TnsfaELBZbt/e427ua3v97JOH//sea
        IAvuktqBynXsewF8pqwQ79Sp2+ktB1o8cVOH5f+1JRZ/SAay
X-Google-Smtp-Source: APXvYqy5AXhfLngIaYgaBxvvQokDgu6mxb5nb/n1uzcS934nnva7+99gALTUcVp1YZPMTW8pM5S3MBUS6LmViOkPPydAWfs2qe0V
MIME-Version: 1.0
X-Received: by 2002:a5e:8209:: with SMTP id l9mr3454621iom.303.1565892360493;
 Thu, 15 Aug 2019 11:06:00 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:06:00 -0700
In-Reply-To: <000000000000523ea3059025b11d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e75f1805902bb919@google.com>
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
From:   syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, hdanton@sina.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 130b392c6cd6b2aed1b7eb32253d4920babb4891
Author: Dave Watson <davejwatson@fb.com>
Date:   Wed Jan 30 21:58:31 2019 +0000

     net: tls: Add tls 1.3 support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118e8dee600000
start commit:   6d5afe20 sctp: fix memleak in sctp_send_reset_streams
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=138e8dee600000
console output: https://syzkaller.appspot.com/x/log.txt?x=158e8dee600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=6a9ff159672dfbb41c95
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cb0502600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5dc22600000

Reported-by: syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com
Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
