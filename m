Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF03C673737
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjASLoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjASLnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:43:49 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5233583
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:43:25 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so1381193iln.21
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBMTs/oqxa+U3Pif+UT/UzsIBETfbLQftOGnVuK+yeI=;
        b=m1mOwE1vt+jLUZRuyzK7khkovBxv2RJglTOccvkDa57ALFLZMF665joETxY7v65lwz
         whBr6noDv65m9oADK66Sov8s787z0tWCs3ZhB9fLX1Pu6BLIlu6hvcwHLPznW3Ond0a6
         klfKjJDnqYzN1j8c/z5+Hg7d16Gz/GmowTJd2tcBLOKv9Pep+CYgL7/4uyEP/zcBKunR
         2aMZ+uIYo5HU8F9/q0XVekApAVm/q80SmFlWiV7o1pxIBKqezUV8w65LhnPysBcJ1NGb
         S9Mufk95VZBBJ6O+EOtNl1qAWdPSe9u/to+lNV4CjjIkBZU0fTsxSmQWB8CUREEyP4Dt
         dsDA==
X-Gm-Message-State: AFqh2kqk58XjFiB1EcqlHyBKbEPwOaPXsvd7UlZ8RmVwH+peao2VSwmf
        cmW3ws3kqavwPx5P7arlqqlnUMmGW5w0k2Sp/gCh3nOpgjOS
X-Google-Smtp-Source: AMrXdXsXcFCp3vMPCpScL6USflrKQhOJ3FkDwUfiVyUWhU3rcEoq4fhbMsvs86VuWB6w648itUPNF4JjAkFewVI9weGat98yR27/
MIME-Version: 1.0
X-Received: by 2002:a6b:8f89:0:b0:6e2:fb39:a5d4 with SMTP id
 r131-20020a6b8f89000000b006e2fb39a5d4mr842130iod.45.1674128605288; Thu, 19
 Jan 2023 03:43:25 -0800 (PST)
Date:   Thu, 19 Jan 2023 03:43:25 -0800
In-Reply-To: <b29bd572-cd43-7d68-e4bb-4858551981f3@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3a00705f29c70b6@google.com>
Subject: Re: [syzbot] kernel BUG in ip_frag_next
From:   syzbot <syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, jbrouer@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, saeed@kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com

Tested on:

commit:         9ffb07a3 Merge branch 'enetc-bd-ring-cleanup'
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1641e6a9480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39c7bc65b36ccf9d
dashboard link: https://syzkaller.appspot.com/bug?extid=c8a2e66e37eee553c4fd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=135c7f0e480000

Note: testing is done by a robot and is best-effort only.
