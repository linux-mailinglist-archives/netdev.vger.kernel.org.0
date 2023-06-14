Return-Path: <netdev+bounces-10911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CD1730B25
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FE21280E3D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899BD15499;
	Wed, 14 Jun 2023 23:04:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CABF14A97
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:04:39 +0000 (UTC)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B62688
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:04:38 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-341c6ac3bf7so87635ab.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686783877; x=1689375877;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FvgsNZbMshDfWtJb8Ii39l/0H93uFx36WrvlKiAiTY=;
        b=XoANXpMVlWTof1bjL3NeOqs1dphAQuKLztNpQtOQPhbWfmvR1YujOJYB8ZQSuDxuQt
         G01RpwKBfTP0azCPG9rjkGSer0hW2U8uzZV2m4FfrNOLINTc9jk7cF2NHyiDD60Zz79m
         kPXHWeQZO6ey13QCdR+pijXEUdnJOr0twXyEjTMifpE6mjYcDmqQextGRw3+uG0H4HT+
         yYvR30oNDFHM/yp9dMkN/DCsQBoBJHW1xZKsQ/XDZyX53eMD69BePcQotHhZSYmosGGV
         Yhw5B8n6hRBzuszFEKStdUDbt26Wfhwr8GVfkSkKOGzmuRzQIhrvlvXeFUPmr2k/E8WM
         CUxg==
X-Gm-Message-State: AC+VfDyP6WM920uYzmZskHZHMprqdIFxE0N0ByrJtsth4TX3rKaPNh48
	ZhQK2BPDp6sJ/oEZXYmhaMmt4JVk9czf5YSOjGyx2QQsetJo
X-Google-Smtp-Source: ACHHUZ5ythZ0Axbf1hC7Gjy6i3ZBawNjy0uyb3Fi9JiOPPifmsSE16NxhTszqGRP/oFDB8ZLyVWcQMYnLmTHD3TUcqhitl24el+B
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d4d1:0:b0:33b:f9b5:d6c2 with SMTP id
 o17-20020a92d4d1000000b0033bf9b5d6c2mr7195369ilm.5.1686783877405; Wed, 14 Jun
 2023 16:04:37 -0700 (PDT)
Date: Wed, 14 Jun 2023 16:04:37 -0700
In-Reply-To: <1634372.1686755343@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3650205fe1ef98f@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_export
From: syzbot <syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=149b6617280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=472626bb5e7c59fb768f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=154a41fd280000

Note: testing is done by a robot and is best-effort only.

