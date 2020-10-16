Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18322906C0
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408477AbgJPOCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:02:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35429 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408471AbgJPOCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:02:06 -0400
Received: by mail-io1-f72.google.com with SMTP id w16so1639659ioa.2
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+8FRC9A/2r22wNctHEmIcxNIQfOiXTrDIO/Luy9E2As=;
        b=W/jkCI6GR+LQP5Rts8PwdcDrseCKXueoH+geWW+oAYNSyrlLab49IM94vutd5uI0uf
         FB9LagITGy8uXtRSjeUqpZ4+aZfKCddxmnV2C/kdKjn6a9J6hSShCwySpAlo92dD/GR2
         w2a+X+JWXQ16VOuJ1/VbX6i26o7xqLvStEf0OOmXW3Exve0vSwfLjjd3THNlFZhl7jSK
         x+ZGWu10huIxVx+idkk7acGmwajWAId4rpGgjDilz1AZhhIKt+3wUeFLtiZf1VP0ooKD
         J1G4cj5EPim67zrTxiH5l+6yTxkDQro6SsGMZhR1Oix1XVV0+Jre1CQ0Sf7y1n4/Prxj
         Kojg==
X-Gm-Message-State: AOAM532viPIxj+r9oRqrNc78/033BufxQP2N5S2JtFQ/dJVpZiVdBO9B
        MeOEcWWqkYA69kUwStJGqiqzRjY+kgh8/L1siEOoazlKpE7+
X-Google-Smtp-Source: ABdhPJzXx/UVlTNoX1P8zLcBnPNnAJAFocb3mI1+eNW4a73QQ+iZimlYfwfH7BMbzj9L4ezavZmc8yaJI33lozl/F0xz+c0NWFsn
MIME-Version: 1.0
X-Received: by 2002:a92:98c5:: with SMTP id a66mr2916184ill.50.1602856925126;
 Fri, 16 Oct 2020 07:02:05 -0700 (PDT)
Date:   Fri, 16 Oct 2020 07:02:05 -0700
In-Reply-To: <1423871.1602855728@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5ea6905b1ca3572@google.com>
Subject: Re: WARNING: proc registration bug in afs_manage_cell
From:   syzbot <syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        hchunhui@mail.ustc.edu.cn, ja@ssi.bg, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com

Tested on:

commit:         7530d3eb afs: Don't assert on unpurgeable server records
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=302928762dfb5528
dashboard link: https://syzkaller.appspot.com/bug?extid=b994ecf2b023f14832c1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
