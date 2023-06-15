Return-Path: <netdev+bounces-11180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5383A731DD9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EA46280C7E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2367B18B0B;
	Thu, 15 Jun 2023 16:29:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171AF156C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:29:34 +0000 (UTC)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F0D273E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:29:32 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76c6c1b16d2so941068139f.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686846572; x=1689438572;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFlp6dTsaA6DhlunBCFuGZl4rO+rbbI1YI66BI+ayy0=;
        b=MQ6q6ObSC+57jRAiulDqU4wHZaxmvge45iFQqR7hA50k1X5DQHpRuGguMG4YEbrGfR
         biRWfv4PLFqqiUbYCQmn0aFn7QagTGh7ooS/eYWymPnxNJmPU/VaUcVeQCbdFBCMeYCW
         d+JEb6nMlylceF2ehNwIyNQgVhl0wdCxSDTMGlSrXPibT7UAFEFGmg3KbBnj1jLwCJ+Y
         YP+r4eIbYvNoHoe7ro4Lrg/tWUw/M0BKNeqUKM8jpZ4Lgp8en8OgJJdQy9dHUGZfpE/H
         FMEX9wQ6ltv7IIGSJ3rJGoy+AVLF1c9iwVGqiT+Wv/SJq03F7i+oikhO+gmTeSaWprr5
         yp/A==
X-Gm-Message-State: AC+VfDzFnYGqw+f3mndeXdY5jvosK03pStPMzXJ8xzbakjuUbLvN/hkl
	2Gt83rHb2cI0rlvAraTNc1aK/WoD+NBo6o6Mbl+rYEqb43Lb
X-Google-Smtp-Source: ACHHUZ6BC1oLFaizK+dPrbWHixBXw11XLiRKPCBpLu1/NFHfMT6V5NocQP4Kg1nqUcfAa7Xz2d73qx3Bzsyo96gJOv+WQdcRn/nP
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:7318:0:b0:423:19cd:69b8 with SMTP id
 y24-20020a027318000000b0042319cd69b8mr510226jab.0.1686846572347; Thu, 15 Jun
 2023 09:29:32 -0700 (PDT)
Date: Thu, 15 Jun 2023 09:29:32 -0700
In-Reply-To: <256755.1686844894@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc6a1705fe2d92c1@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	kuba@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com

Tested on:

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=1258baf7280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12c65e17280000

Note: testing is done by a robot and is best-effort only.

