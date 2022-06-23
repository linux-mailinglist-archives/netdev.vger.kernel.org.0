Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1037557589
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiFWIdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFWIdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:33:11 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E35DEB5;
        Thu, 23 Jun 2022 01:33:10 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0VHAoIhL_1655973184;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHAoIhL_1655973184)
          by smtp.aliyun-inc.com;
          Thu, 23 Jun 2022 16:33:05 +0800
Message-ID: <1655972550.3746855-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage (5)
Date:   Thu, 23 Jun 2022 16:22:30 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com>
Cc:     alobakin@pm.me, bp@alien8.de, daniel@iogearbox.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <000000000000b9edeb05e1aca987@google.com>
 <0000000000008b8cd205e2187ea2@google.com>
In-Reply-To: <0000000000008b8cd205e2187ea2@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 00:35:13 -0700, syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com> wrote:
> syzbot has bisected this issue to:
>
> commit c2ff53d8049f30098153cd2d1299a44d7b124c57
> Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date:   Thu Feb 18 20:50:02 2021 +0000
>
>     net: Add priv_flags for allow tx skb without linear
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11596838080000
> start commit:   a5b00f5b78b7 Merge branch 'hns3-fixres'
> git tree:       net
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13596838080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15596838080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=9cbc6bed3a22f1d37395
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b22abf00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125194eff00000
>
> Reported-by: syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com
> Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")


I think it's unlikely that my patch is causing the problem, because my patch is
very simple and doesn't have any effect on the kernel. I don't know if there is
something wrong.

I used the above config (make olddefconfig) to compile this commit, and it
crashed directly after starting it in qemu.

Thanks.


>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
