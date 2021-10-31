Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708C6441041
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 19:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhJaSvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 14:51:45 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33570 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhJaSvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 14:51:44 -0400
Received: by mail-il1-f197.google.com with SMTP id m7-20020a056e021c2700b00259bf1e38b1so8815512ilh.0
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 11:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EDfj5ne47rqVe1CydX+aYgYdcHr5k4W7I1Ib2hSVKPQ=;
        b=jUQgUd4HRVvwc0FGpLjgIkR8gK1fDtZ0LnMbbmkWjLYbvqfWkdbwXxs+3DJG+IN2SB
         nGWKr5XOqba6b24mdduYmh4Kzpf67dB+7YSy5MAo9fh8TuCp1XbA3rOp0yNM+ei9DJL5
         1NXa+X5aR2ska1gWeEJuWFzvZJ6zjWzddV40lJnnnDx5cHjoyYbihXlbkXPvU2Tr4AEA
         72/5x4J+Kx9YmUiVEE2T9LSKu6EUwrb4Q6JIaJuhD5JdKxETaC1siiBgrMCFBkN7TAk/
         dueo/GtdwBLKOP2HV3VQksWTojZM53JDs10m4rec2t9NdSnGhcvApoRRn0M5g8HtejYk
         sdiw==
X-Gm-Message-State: AOAM530xuvledSL4FsbT5fAeaNdTSHDGqcfE/Ws/yCpt0lgneujTk6o9
        iuUW0N+dMlqxYxKzAWQPW3Wen1+ttIBakUijpCBVie11iaz/
X-Google-Smtp-Source: ABdhPJyOG+lTecw5XF3nfkAPSpnl6M8hQQ/dDGVasqzB2YT8aLiWoViqcJHVGaVKr5kPojVr1ebi8CChphSOdx01Y5mQi4o/Pg9s
MIME-Version: 1.0
X-Received: by 2002:a6b:650f:: with SMTP id z15mr11810710iob.27.1635706152392;
 Sun, 31 Oct 2021 11:49:12 -0700 (PDT)
Date:   Sun, 31 Oct 2021 11:49:12 -0700
In-Reply-To: <dd579644-7ef9-f005-0275-b7384ca731a5@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ba17d05cfaa8446@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in hci_le_meta_evt (2)
From:   syzbot <syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com

Tested on:

commit:         180eca54 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=6362530af157355b
dashboard link: https://syzkaller.appspot.com/bug?extid=e3fcb9c4f3c2a931dc40
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1295a186b00000

Note: testing is done by a robot and is best-effort only.
