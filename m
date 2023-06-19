Return-Path: <netdev+bounces-12060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB77735D82
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23443280A0D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBF912B70;
	Mon, 19 Jun 2023 18:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E3EA8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:39:30 +0000 (UTC)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6416618D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:39:29 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77e23d23eccso194611339f.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687199968; x=1689791968;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yovt+NBs+zN88mKTFmMiBGRNaqNl1IAEsWQ9bmrlOts=;
        b=Sk23pv4q4nXDBJYRo3d2twU+eyWWKBJym9/7aONiuXPxzpLVWx/p0eloF0evVvKnKj
         cQQKtS4JW+olPS+l4LY37r/j9QVkZx9Z5tpDHCTukDixhJF6NS2levQa5TUR67FtNJG5
         c89xhcXUK6uVNapGgzTwUDWKpvG2Na2rI9dKYD8F4mg4xd00AtlEAJaE3KN1HimM9xBB
         RxtjBTGGuZG/L6V+ReTO2u4mV3xmTliMm/rIV+iVGbfWj1FpNAR9CQHHeTlhCR2cmcfz
         laGJ/9VS08I7R5T5mOgb1umQsXUIEtnPsqXRas/OnrGbd95tjOOx08cqu+hq6UBDEtyd
         OQEg==
X-Gm-Message-State: AC+VfDzsqwEOsvonTylli5esLH2AvLUryZtYGjegF8A2JPjly2Fc3doR
	2HwZQhgYh1VZIqXSmLn2Uy+r/CLZv8KAXGfma1FvQ1QEshI3
X-Google-Smtp-Source: ACHHUZ6Zu1qOfU3n1nK17F8mRHVcVw++7U+FWtv+g1pIs1eCeFRAessPwU2LszmlMeaaiY97WhjTMdQEA9nxqde2iw2xAZuCWbTM
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a6b:3b8b:0:b0:777:b0ee:a512 with SMTP id
 i133-20020a6b3b8b000000b00777b0eea512mr3574163ioa.2.1687199968282; Mon, 19
 Jun 2023 11:39:28 -0700 (PDT)
Date: Mon, 19 Jun 2023 11:39:28 -0700
In-Reply-To: <000000000000ada87505fe7cf809@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6527105fe7fdab8@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
From: syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has bisected this issue to:

commit c662b043cdca89bf0f03fc37251000ac69a3a548
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 13:08:56 2023 +0000

    crypto: af_alg/hash: Support MSG_SPLICE_PAGES

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a7cbcf280000
start commit:   9a94d764e9bc Merge tag 'mlx5-updates-2023-06-16' of git://..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a7cbcf280000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a7cbcf280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1152c4ff280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1307cbcf280000

Reported-by: syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

