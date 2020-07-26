Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3FA22E272
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 22:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgGZULF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 16:11:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34627 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgGZULF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 16:11:05 -0400
Received: by mail-io1-f71.google.com with SMTP id 127so10099783iou.1
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 13:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dudMlHrGLdKPFIb0BzzoKkVe79aQGzC9+73fmHoxPl4=;
        b=n7S8pTn41L4dY2qhDewRkYKTqiRlxOj47Dy8qD5y3leWyEDyEZlcGCpOjtk22/fM+U
         yCaYKq4zLOFSrgP301CSx21YJ6bxxYB2YDe/PcUR1ZarUDtjkm9MIlI3SSV23g+Jx4pm
         EARqMZM96uRa3IAhv6fMABIX6c1cg7W4eqiZ8taB5EKusjgjAzri27QScdkJCFqIITog
         DH7C6pGasezl4o7anF3ydNSRzT70IqJypwSIy7+34LKpte1dzd1T+jyq99fvNAoiXekp
         ehzhizBUGEfDFJs24WUssfhaeLlqS0oY+HbUOSE3buGy4MFyp72MPHB/dJoCrjz5unKi
         MDUQ==
X-Gm-Message-State: AOAM533wu7JUj1rm7fCL1tyvnfxJ5ioExYQGeLj0Md+Oqm6UmsQmdIsc
        zAk3yh/Z0Jh7AzixCh12MoNIzdHZQPI5WoAd8wovU8ZOPMGd
X-Google-Smtp-Source: ABdhPJxlhsn+KetcpoEYX6E8Sqw4cArXJbnl+vGX1w1VtK02FAsTySNjK8rKWmrP7TpfzXn4wYZbP8u14pwiNS94yoEOKeUVblSa
MIME-Version: 1.0
X-Received: by 2002:a92:4983:: with SMTP id k3mr20209144ilg.56.1595794264312;
 Sun, 26 Jul 2020 13:11:04 -0700 (PDT)
Date:   Sun, 26 Jul 2020 13:11:04 -0700
In-Reply-To: <001a11405628bb07410565279f4a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004251b005ab5dce75@google.com>
Subject: Re: WARNING in xfrm_policy_insert
From:   syzbot <syzbot+5cfc132a76d844973259@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit ed17b8d377eaf6b4a01d46942b4c647378a79bdd
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon May 25 05:53:37 2020 +0000

    xfrm: fix a warning in xfrm_policy_insert_list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1774b9df100000
start commit:   6c677750 mlxsw: spectrum: Use NL_SET_ERR_MSG_MOD
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=82a189bf69e089b5
dashboard link: https://syzkaller.appspot.com/bug?extid=5cfc132a76d844973259
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f8821d800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec3c63800000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfrm: fix a warning in xfrm_policy_insert_list

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
