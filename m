Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6557828F7C4
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgJORqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgJORqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:46:48 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42185C0613D3
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 10:46:48 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id y9so1526244qvk.1
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 10:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vn/3wmu1nVfg3AkxOlooAaCuVGuawnb9aPIzYLLzFo=;
        b=Zc/4Fh4+5RLTMpTxQdA2BcERTLFHrCNkOKWF0MMGHu1pfYyfsE+RvOqcqqiTykzWfq
         zPpHYghOP87vS4mC/iEq3PC/lvIEtjY6ZtTRpzSjw+6fNrbx1iQndoQmhb51EOJuVjkO
         efFHSo2X2qsyVZTqJl0R8w54ogcT3AXZILoJI/y5sibWnoz8AAH388DZzSmV34fmG44c
         qYOtlwO9wH3iorqIOlprFaUwEcWee8fIEgPiOoocQj0TxSo19bJWqCuxusbjO64NO9KB
         29yK7Blmw1wzijp90S+LWJUbwx6Rf8O6jwQYf6295KZ6eXNLX0w+h6XEcCroZtlDcxkR
         5a7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vn/3wmu1nVfg3AkxOlooAaCuVGuawnb9aPIzYLLzFo=;
        b=bimgzd/1ieFJM7G6J+IdQ5RXvzC3PdfeJcXxvThuX2VvxUOf+gqwYnD7c8UsLpbL+B
         5+3fmKyoSxEIguvpi/RzSxNSdHsTkeQLASm/MjvXac5BiFrQdKX1pgLN9lhDwMMnHSsu
         g65qN9jznTM6zYhWqgxbJwAgHUNHITmrYfqzrRu7jLU+wV7Ahql7ZrY1CFE/a5jMxWbA
         ycOUGoUW0PjZo2wZdpmU2JngQySU/I1YmY7rAoePCSAka5M89kX52zcnltGmku4V+Efc
         zvpkh1E+tqwq2+/RhEqjB/YsZausjmhblp5bMj01pYvv37GNQTYAgT/05v7bFxNoFQue
         XsqQ==
X-Gm-Message-State: AOAM531o8Bm8fZqcp34txBLecWULRwXDzPWEqaqlNlY0HbP3LwhpID0q
        KX4SN9Ki96xVMjVq1FW2ycZ2Zs9tZijqLvtIRRzRH0mIwTo=
X-Google-Smtp-Source: ABdhPJzrnMSzTrlNSYjNlDNzbC7PRckgIJ4U5tiDieaxJK3U0vcNl8unoAx3DXkxEZL2iGCNxwzjvGc0ZMFJ/8Kp0Zw=
X-Received: by 2002:a05:6214:a0f:: with SMTP id dw15mr5670392qvb.44.1602784007017;
 Thu, 15 Oct 2020 10:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000376ecf05b1b92848@google.com>
In-Reply-To: <000000000000376ecf05b1b92848@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 15 Oct 2020 19:46:35 +0200
Message-ID: <CACT4Y+aTPCPRtJ2wJ5P58DijtG2pxXtZm6w=C838YKLKCEdSfw@mail.gmail.com>
Subject: Re: bpf-next test error: BUG: program execution failed: executor 0:
 exit status 67
To:     syzbot <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 7:41 PM syzbot
<syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    e688c3db bpf: Fix register equivalence tracking.
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d3c678500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ea7dc57e899da16d
> dashboard link: https://syzkaller.appspot.com/bug?extid=5609d37b3a926aad75b7
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com
>
> executing program
> 2020/10/15 14:32:51 BUG: program execution failed: executor 0: exit status 67
> iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> loop exited with status 67
>
> iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> loop exited with status 67

+netfilter maintainers

It seems one of these recent commits broke netfiler.
Since syzkaller uses netfiler for sandboxing, syzbot is currently down
on bpf-next and linux-next. Other trees will follow once they merge
the breakage.

$ git log --format="%h %cd %s"  net/netfilter/ller
d483842df20a7 Thu Oct 15 13:12:59 2020 +1100 Merge remote-tracking
branch 'net-next/master' into master
a307b1b214d05 Thu Oct 15 09:21:35 2020 +1100 Merge remote-tracking
branch 'wireless-drivers/master' into master
0d9826bc18ce3 Wed Oct 14 01:25:14 2020 +0200 netfilter: nf_log:
missing vlan offload tag and proto
98a381a7d4892 Mon Oct 12 16:54:30 2020 +0200 netfilter: nftables:
extend error reporting for chain updates
7980d2eabde82 Mon Oct 12 01:59:41 2020 +0200 ipvs: clear skb->tstamp
in forwarding path
793d5d6124269 Mon Oct 12 01:58:10 2020 +0200 netfilter: flowtable:
reduce calls to pskb_may_pull()
d3519cb89f6d5 Mon Oct 12 01:57:34 2020 +0200 netfilter: nf_tables: add
inet ingress support
60a3815da702f Mon Oct 12 01:57:34 2020 +0200 netfilter: add inet ingress support
ddcfa710d40b3 Mon Oct 12 01:57:34 2020 +0200 netfilter: add
nf_ingress_hook() helper function
afd9024cd1fcf Mon Oct 12 01:57:34 2020 +0200 netfilter: add
nf_static_key_{inc,dec}
073b04e76be6d Mon Oct 12 01:57:34 2020 +0200 ipvs: inspect reply
packets from DR/TUN real servers
321e921daa05d Sun Oct 4 14:35:53 2020 -0700 Merge
git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
10fdd6d80e4c2 Sun Oct 4 21:08:33 2020 +0200 netfilter: nf_tables:
Implement fast bitwise expression
5f48846daf332 Sun Oct 4 21:08:32 2020 +0200 netfilter: nf_tables:
Enable fast nft_cmp for inverted matches
ab6c41eefd46b Sun Oct 4 21:08:32 2020 +0200 netfilter: nfnetlink:
place subsys mutexes in distinct lockdep classes
9446ab34ace25 Sun Oct 4 21:08:25 2020 +0200 netfilter: ipset: enable
memory accounting for ipset allocations
82ec6630f9fcd Sun Oct 4 21:07:55 2020 +0200 netfilter:
nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK
66a9b9287d244 Fri Oct 2 19:11:11 2020 -0700 genetlink: move to smaller
ops wherever possible




> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000376ecf05b1b92848%40google.com.
