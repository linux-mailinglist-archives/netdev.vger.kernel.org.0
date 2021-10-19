Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F2F43313A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhJSInM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 04:43:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:47835 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbhJSInL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:43:11 -0400
Received: by mail-il1-f199.google.com with SMTP id i15-20020a056e021b0f00b002593fb7cd9eso9661852ilv.14
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 01:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc:content-transfer-encoding;
        bh=zmoEaV0HwzX7oDzswsR/tmadU98uVZ2rFKJ//gLFLec=;
        b=6xEDcNsDcPBys49lEgEAYVbVSMow08Bt7imAMm9bSATKImyyfp1mLzMO79FJ4Es68A
         xLCoxPHI3k+y0CGMyr0KR3fFYqYanMEbKr/EzWoMYVLHSBYOruBIFh/usa/G1m61E/nH
         HT80QmaHHNlZgLLQjhX7Nev7jCLHHrsIREhCd2meHjw2OlIflxy2GI0G8D2vbyYY46+3
         PxAczY1Uc0tDsNBA2gyw3zWp9EVwUInr/HE6l9kJMWV2M+P21Nip2DH0BkopRCoEPgL+
         ikvLLketpx5RZtDqkSsXsotlnfwuK/XeM3SZ6LReRegqksTSxkEkw6btAcP9Nbpl60sc
         sKZQ==
X-Gm-Message-State: AOAM531NvS3tfrt+Sh+PfhCk2D2VPTiUVLxmLXZOrie6QjNIEZeZhf3r
        XpHFYH3YUY44Pe5Ovly7dr2ACA1fJKBv6i6tOLAiaYE9Lg+X
X-Google-Smtp-Source: ABdhPJxJiLZQoMLgnK+lCq76ABC1JNwHSYsXZXueokW1agP8zOU7LSqZ97CvfFHXuqHaxTg1WOfjiIcvzD54dN5k2KPtbvRdgz23
MIME-Version: 1.0
X-Received: by 2002:a02:cac6:: with SMTP id f6mr3136897jap.81.1634632858981;
 Tue, 19 Oct 2021 01:40:58 -0700 (PDT)
Date:   Tue, 19 Oct 2021 01:40:58 -0700
In-Reply-To: <649fd15d-4e23-f283-3a58-f294d59305c7@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5d81305ceb09ead@google.com>
Subject: Re: [syzbot] divide error in genelink_tx_fixup
From:   syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On 18.10.21 20:55, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    660a92a59b9e usb: xhci: Enable runtime-pm by default on AM..
>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1506ccf0b00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5016916cdc0a4a84
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a6ec4dd9d38cb9261a77
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11308734b00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f56f68b00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com
>
> #syz test   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf

unknown command "test\u00a0\u00a0"

>
>
>
>
>
>
>
