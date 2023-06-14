Return-Path: <netdev+bounces-10901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50DEF730ADB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2AFA281492
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4551134B8;
	Wed, 14 Jun 2023 22:42:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA4111A6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:42:38 +0000 (UTC)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACC21FC3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:42:37 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7778eb7966eso790348039f.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686782556; x=1689374556;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WE73eWAx50Q9c0pRDTsurXPQzo7ErFkWRWSNLKelXl8=;
        b=QQaNnYCenfmgkhz+HQvUGvmSjLiUACv5/n9OfLlSxehtECF1tXL2Rxyhp7ZLumrPP6
         RDbrkQzyccTC1weNljYb+u0waowPM1PuilrQew2jorfNx56ywwt237euJjgz/swodsnG
         tyUaXNW5NVJX5GtcIgWwd5KcjYYBaTg97mN23RkZOvmA4CmnnvYjWyS7+ImXKQiCWF7b
         sGbmiFrvwcplNzo3jhDHTP3yrX+8aaAVZRDFZ7tVBNp+YLZ0AdoFgd1t+qS/9pje0wZq
         MRyCKC0PGP/U0yFTd1cJ7G/4MFjMa98kgiowMvsvwE/VJ/jH9eX5MvRsGGgVodN4WErH
         hb5Q==
X-Gm-Message-State: AC+VfDxYPg9DTw4GBMGO+qWNZVIYMxmBj6TVgaCI4722Y05KD0W7X9qc
	vsnVDWXz3VY4ZOK7pzXjR3cGoWgX4SanYmRPF/TtHDnUA1Nt
X-Google-Smtp-Source: ACHHUZ5d+qMhMNOUFWZyzwX1QZfMj8e4pEaKvgbexuUfTL0QemYLd2k78ajcnQjdBEvahD4oj+jPD0jc4iq5zak1PLa3SgeT60kY
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5e:880a:0:b0:76c:7d48:d798 with SMTP id
 l10-20020a5e880a000000b0076c7d48d798mr6300645ioj.0.1686782556283; Wed, 14 Jun
 2023 15:42:36 -0700 (PDT)
Date: Wed, 14 Jun 2023 15:42:36 -0700
In-Reply-To: <1604628.1686754446@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014bf4b05fe1eabfe@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
From: syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=12ae3673280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=172d9e8b280000

Note: testing is done by a robot and is best-effort only.

