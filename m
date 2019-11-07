Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33F5F302E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbfKGNnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:43:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42462 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389041AbfKGNmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:07 -0500
Received: by mail-io1-f72.google.com with SMTP id w1so1863751ioj.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vnRsz0/rOqX31qWVqa+jCcqeQTYMdPmUZHcF8We9FRA=;
        b=EFRfID+rQUy3vHH7MnH2eYZJeX20k2uFki0o3J3NUZaZinEf8Mft2GVLIAAmlkHdVy
         ckixKun8R/bauNG7Y06BtznPNmNGasLMi6/9FQro+glM8I62SUCNZr8/pRPDd0ZpvHEf
         MdgjvZE2TTJ1O4ZVR/RcGFmhEFDrS+s0EkJSPHxyz5EpP479VRdWEZ8mbrsDUHNVbIX/
         5G/Qjfc46a7M3+52J5V6AqJv2TGRYOgod6s6Kwt1XNFIdkkxXo7sli16sqALtNO116eC
         wyMYayGigwzziRRSlkXscYDI4pLxPTFjy1X+Bb9z2/ftRDqYJS231St8VV4HHN+qrJUB
         ldKA==
X-Gm-Message-State: APjAAAWs5mWNLEw0YsKZkc1o5NJaVhmL4SoqjDFWWXHI2Wpc/OsMKgDZ
        PsbxkhrDuj6KHcQcDw2czdENrU0LImM+oG9eFW4fSY6iZRbo
X-Google-Smtp-Source: APXvYqxag6ODkk8Wbv8Wdp6mU+iNDO/+EsH5xk9k1x/wiqR1dAXliax/9/yHrkDCGJ9jCF/t7qMAyUhTeT+GGlYdhmUlfnYJ7pvc
MIME-Version: 1.0
X-Received: by 2002:a6b:8b02:: with SMTP id n2mr3600626iod.66.1573134126640;
 Thu, 07 Nov 2019 05:42:06 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:06 -0800
In-Reply-To: <0000000000008d5a360575368e31@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cd76fb0596c1d41c@google.com>
Subject: Re: KASAN: use-after-free Read in _decode_session6
From:   syzbot <syzbot+e8c1d30881266e47eb33@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com,
        herbert@gondor.apana.org.au, johannes.berg@intel.com, kafai@fb.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, posk@google.com, songliubraving@fb.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, willemb@google.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit e7c87bd6cc4ec7b0ac1ed0a88a58f8206c577488
Author: Willem de Bruijn <willemb@google.com>
Date:   Wed Jan 16 01:19:22 2019 +0000

     bpf: in __bpf_redirect_no_mac pull mac only if present

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1736f974600000
start commit:   b36fdc68 Merge tag 'gpio-v4.19-2' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c7e83258d6e0156
dashboard link: https://syzkaller.appspot.com/bug?extid=e8c1d30881266e47eb33
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d42021400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d09f1e400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: bpf: in __bpf_redirect_no_mac pull mac only if present

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
