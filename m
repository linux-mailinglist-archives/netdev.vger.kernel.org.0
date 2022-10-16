Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C95FFCAA
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 02:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJPACT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 20:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJPACS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 20:02:18 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B97A3C175
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 17:02:17 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id x21-20020a5d9455000000b006bc1172e639so5139332ior.18
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 17:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTFzBgJgSwbr/DQpi6/QIbsaM9yQ3pzzrj34mApYPQw=;
        b=pF4dlqbONZQ8jjHCm7jy54BCzERk7cJzfttUpkIeTkIej/5xuXi4CQ8ZQsB+CMCWdr
         6mRLgcp56ylz2/xdwGcqsNjXsPONtVBIRdJTZr1M14L3Jx6ViQSTk1WVokzsgxpAqJTT
         tHy00O0AkY2JdM6+TQmcWR8OH/1VR2ZgNVQGSssdMmFPCFUkjM8goTQvx08LzBm6Xj/0
         gBm5LFtGXC56UcetDvv/HiVSWbDREhQ/BOd8GK/Pk1DmcEBdgK3ugx/1vmxqpFgCiepA
         NF1Y64ABNxZoiy4cAQfwrtADHxlGBVDZX+fVJ3m+4Ata0zt34CxOYqsfE1IV05mCmAQ1
         o/iQ==
X-Gm-Message-State: ACrzQf0nF2Miv54/DGgUli6goBucHMbhbcvc7UHtoylV7mvEF6qAIdlX
        le992ee/qvZ5p3BJbWNH+EEsjxoYZG3l4GCuE4oBp2ZjbXc0
X-Google-Smtp-Source: AMsMyM6Zj/1VDtsfAI7vf6E11njjEZCpcpnwTaDHGXoEqMPGQ2pTpRN9x8Xl2gE/Ha9COQXlqe7IQsgI9FXk8ScmsYZX0Mle4c28
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d0d:b0:363:e6b8:2bd6 with SMTP id
 q13-20020a0566380d0d00b00363e6b82bd6mr2359971jaj.296.1665878536908; Sat, 15
 Oct 2022 17:02:16 -0700 (PDT)
Date:   Sat, 15 Oct 2022 17:02:16 -0700
In-Reply-To: <20221015154817-mutt-send-email-mst@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006e720f05eb1b929e@google.com>
Subject: Re: [syzbot] net boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+4d0c5794bff07852726c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/net: failed to run ["git" "fetch" "--force" "5c96e23a32a280262291fe5d31d8f7dc6f666b47" "net"]: exit status 128
fatal: couldn't find remote ref net



Tested on:

commit:         [unknown 
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git net
dashboard link: https://syzkaller.appspot.com/bug?extid=4d0c5794bff07852726c
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=176372c2880000

