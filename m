Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903A83FFF55
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348737AbhICLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:43:08 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:46882 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhICLnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 07:43:07 -0400
Received: by mail-il1-f200.google.com with SMTP id w15-20020a056e021a6f00b0022b284d1de4so3282634ilv.13
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 04:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e+HyKsU19yRq9dTTGzaiihO1RDbY/pEio/YxB+y4wlQ=;
        b=C/sWJi1m3i5a1vOB7vRkVozEHjKqZaO0Bod/xEubY1W8qTqqVNKz2oTyA1F1zz3TQE
         oteOI0IAFCxfle19Z/HfA9WNXQa6Fp8yaSdh1Q4t7Q8TF0VUHgmOH6+bwUpC77XDTsJr
         7QofeTCXHPrZdnVW8hsiSbqlIBDMT+gXfOt7I5LqqgHyrTneNIAZKnC8A45eLYsSG+Xb
         zmxdI4j455/03vAZh9sNXvU3geDz+6zIDznqP71yU+Vj+0PRKpdA9gY465BBDBdhE+FK
         7qqKp3Incm90irBbszYqz9oXYkKnYkfkLHAxDlxqaRW4W+hHDLSSSKX6LVdU2PrG7FAa
         bLXA==
X-Gm-Message-State: AOAM532TnyDU7rkiFbeoB1ppZvRA5i7Hbglyike3BCl8GOR3fxLuDxwU
        nu6W0orc0peW3QfskDMD6Fir34jWR+/w+Dky/Km595ScOIte
X-Google-Smtp-Source: ABdhPJyVGKWtZ/XNFnPfV1DJyHrVWvrUw1gcWV/6Ek254iAr3SZHr33nQjI3GFtlrzCzJ1/87getEFBZvKiyVflC5YPCMch6/ZSX
MIME-Version: 1.0
X-Received: by 2002:a02:93aa:: with SMTP id z39mr2241987jah.29.1630669327150;
 Fri, 03 Sep 2021 04:42:07 -0700 (PDT)
Date:   Fri, 03 Sep 2021 04:42:07 -0700
In-Reply-To: <10b89a9f-443c-98d1-ca01-add5f6dd3355@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fdb19d05cb15c938@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in add_del_if
From:   syzbot <syzbot+24b98616278c31afc800@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nikolay@nvidia.com, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+24b98616278c31afc800@syzkaller.appspotmail.com

Tested on:

commit:         d15040a3 Merge branch 'bridge-ioctl-fixes'
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
dashboard link: https://syzkaller.appspot.com/bug?extid=24b98616278c31afc800
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
