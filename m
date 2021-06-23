Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C799E3B1EA9
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFWQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhFWQbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:31:02 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E16C061574;
        Wed, 23 Jun 2021 09:28:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id h15so5019987lfv.12;
        Wed, 23 Jun 2021 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aQYx6/QAcfArzE491XaNEH/4wY3r/GDrqLZ2pZaDuuc=;
        b=GZ5qMCQUf/WbB4tAFKOZMDUsCc7PPUS1JB71l0CZDNF+WzhwjSzoCJVbj0GDf+nP24
         y9M9CdmAUTjHZiEnE5nkgjIUIick4SUbWEtmD5gA1tfNnD3xu38TLcfLbwD+FwFty8/a
         eZWi5XPZJVNk0Lqy2fTwl06EqD5UI0CleG+Vq2QlqkoOZW51Ptwsmv7LgFDywnHqBgLf
         YUNQy6ce+FLFbBMZUNwbMCa610pqZOaYB7U7hyN24oksYFjllePY0VONSWTVdp00xs+z
         4lPQfQLgBNEdkOd2C2itCHAq8SDJCZzua0uT1BOneKIUPNeQjj/uuExXWjQzelxApKYf
         m4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQYx6/QAcfArzE491XaNEH/4wY3r/GDrqLZ2pZaDuuc=;
        b=QmZN5+xAKETMspZ7tsfcsVlXHCptGO2lUIV60AT+HsS4ybgkNXYHRnUfa2nP/bENHJ
         DHMMz8d9+sd1yT5cFCLdfQbT6NWlALnuiKMz9dBHbkX6GMjW1a2sP7MyUtDc60byvJ9t
         mQuoZhtC7GUB8HP/YBjjzzKEoTxX3N03VYpgftVaiBTLTugL9fDlcSRS+j0kQEQYT1Cv
         67xxq+BEHOHIsmg60UMSNoM+hHt6HpWjWnNInWjcqPWsnchf1G40m0DGR3Be9RE1X23b
         9dgTYVxWzhrzDtl91JPCYq8sqSJsNRjRExhSMEfM2QlXx4bYjSIiTlV1F6KtAy/bjQOh
         Antg==
X-Gm-Message-State: AOAM532hMPRECTK3jBiIVTEUO30pAaensSXpcG99Sp+W3aryP1vpCgYj
        7ficaXP//sxHWax+0CO385E=
X-Google-Smtp-Source: ABdhPJyNw4Yr5Nx3Tutq4IkH/aWZtPJX5guJzack7Gi2qasNFnLYtTWYtBt2VO9cCcNfZ7cVzBlmIw==
X-Received: by 2002:a05:6512:50b:: with SMTP id o11mr322997lfb.257.1624465722369;
        Wed, 23 Jun 2021 09:28:42 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id c5sm40897lfv.117.2021.06.23.09.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:28:42 -0700 (PDT)
Date:   Wed, 23 Jun 2021 19:28:37 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] WARNING: zero-size vmalloc in corrupted
Message-ID: <20210623192837.13792eae@gmail.com>
In-Reply-To: <20210623191928.69d279d1@gmail.com>
References: <000000000000aa23a205c56b587d@google.com>
        <20210623191928.69d279d1@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 19:19:28 +0300
Pavel Skripkin <paskripkin@gmail.com> wrote:

> On Wed, 23 Jun 2021 02:15:23 -0700
> syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    13311e74 Linux 5.13-rc7
> > git tree:       upstream
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=15d01e58300000 kernel
> > config:  https://syzkaller.appspot.com/x/.config?x=42ecca11b759d96c
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=c2f6f09fe907a838effb syz
> > repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=14bb89e8300000 C
> > reproducer:
> > https://syzkaller.appspot.com/x/repro.c?x=17cc51b8300000
> > 
> > The issue was bisected to:
> > 
> > commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Wed Apr 21 07:51:08 2021 +0000
> > 
> >     netfilter: arp_tables: pass table pointer via nf_hook_ops
> > 
> > bisection log:
> > https://syzkaller.appspot.com/x/bisect.txt?x=13b88400300000 final
> > oops:
> > https://syzkaller.appspot.com/x/report.txt?x=10788400300000 console
> > output: https://syzkaller.appspot.com/x/log.txt?x=17b88400300000
> > 
> 
> This one is similar to previous zero-size vmalloc, I guess :)
> 
> #syz test
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> master
> 
> 

Hah, I didn't notice that this one is already fixed by me. But the
patch is in the media tree, it's not upstreamed yet:  

https://git.linuxtv.org/media_tree.git/commit/?id=c680ed46e418e9c785d76cf44eb33bfd1e8cf3f6

So, 

#syz dup: WARNING: zero-size vmalloc in dvb_dmx_init

With regards,
Pavel Skripkin
