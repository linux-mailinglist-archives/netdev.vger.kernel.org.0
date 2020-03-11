Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED63C180F06
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgCKE4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:56:03 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36694 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgCKE4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:56:03 -0400
Received: by mail-io1-f71.google.com with SMTP id s66so660208iod.3
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 21:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PTAmheRb83mqmqcQhDPjsi3Wza5HOxd3cp66btvqBKk=;
        b=LMSZ4B3iP0ZTv/mAlRSgwWwm3b/y5Kh+7MHGoNRKXC1RzF/aVeC9mLawe3uHbOGH37
         8wrwKkNcwUdpcd1zAhQt2mlmsvaNHwR72/+0TnHB+3/IvtlEg7VejsOAg9EqOapYOU4r
         +cg9hG35SpzdDrHT9Afbu5qGn1GO6AYnDNSp28fsy3NHQseGCqFDU/Z+dimbvz1D0q4W
         736fZlzNCgJg6B5byh2ysZ4Q276mGBqev+jSwXGeIxp1u78Ll1fMIvXeumQkbk1Jib5L
         uCK8oUaLGtVhyKuU0CDIwUGlihaj2lJ8KxQVPHL7X0Jmo9RYmDjIYYTM8FcQ8mdiVK04
         6WnQ==
X-Gm-Message-State: ANhLgQ3BMTRohBTfD8YDqdnPW29ErNSnEG3jhMXtUq8qdSedkcJJNAFI
        s7/Oz/6h380yQNR71zEmtmSjWy5P2/2RkHhx8dhhIB1+nxtq
X-Google-Smtp-Source: ADFU+vthrNPKofNyk0KpJ1HImRdkg+YaS9tEx7+ZHPT032pNO/bgZc3l3bt7nz1NMcRU810us7EbYn2aqUapzEc63cfz0gzFeD1t
MIME-Version: 1.0
X-Received: by 2002:a92:c802:: with SMTP id v2mr218215iln.277.1583902562672;
 Tue, 10 Mar 2020 21:56:02 -0700 (PDT)
Date:   Tue, 10 Mar 2020 21:56:02 -0700
In-Reply-To: <CAM_iQpVrasivmeLHfxFpBcTxYr+Er-KCOrdSR0L4Bd7DuzxHhw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b65a605a08d0da7@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in tcindex_set_parms
From:   syzbot <syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com

Tested on:

commit:         2c19e526 net_sched: hold rtnl lock for tcindex_partial_des..
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcbe864577669742
dashboard link: https://syzkaller.appspot.com/bug?extid=c72da7b9ed57cde6fca2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
