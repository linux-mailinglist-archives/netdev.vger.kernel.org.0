Return-Path: <netdev+bounces-10903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0317F730AFC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DCA6280DC6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCE413AC0;
	Wed, 14 Jun 2023 22:51:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C3C125A2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:51:34 +0000 (UTC)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B41B1FE2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:51:33 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3406661e649so22900015ab.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686783092; x=1689375092;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvWGvGEYVDY0zHX9FKywaaz8rQNIa9z0Aga8elPLqso=;
        b=N4p/ZDw34Oq5mcJzfvBA3UP87lb+Z2QvTGk9XlNPakJ5F+ilis3TcvtMlEr416ATQQ
         JliHILLPz0dIjAsjZ2996tDYJxkLOKG4HHf+ReMPW4tovK2QQIsNSqyoKuprwxrYfSWI
         uM10izFY0q9jzWdfS3lJF/Hm580TMa6Yz716v/O7NTjcmNA5aSP/NShksSqOLB5xBPhO
         SDyUzH8vWLQ/B4QskqahdIY5g1mpg0DsiUFOfTTsTKgdBB6Z3zTDh5ocjKTeExKuKaQ+
         +YUwoRHWDj0+BYq+agdconm8bwBBx/CX2M2JQtmSsx/jYKHv7t0bJmYZ+u1rv5tHHTd0
         K4qA==
X-Gm-Message-State: AC+VfDyF3BlCOmiJv8lI0VQVoU06hLlMtdhHiEYHf8qf9fA6wWdZgIMt
	/E5FV5iGJP8o6lHB2AvA6IlZTvlBOnaARebeqgO7v/2/2Jk5
X-Google-Smtp-Source: ACHHUZ5CrMxjJAzysjfmyxYmSDBMC3q+sumWtPMCJn5LhHxYTj4gZWD8HH/6ppLUpOaHirncbQikaPSGA+Jf2kxBMEr1Tlxy+AnU
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:dc0e:0:b0:329:4c5e:15d8 with SMTP id
 t14-20020a92dc0e000000b003294c5e15d8mr7285347iln.2.1686783092577; Wed, 14 Jun
 2023 15:51:32 -0700 (PDT)
Date: Wed, 14 Jun 2023 15:51:32 -0700
In-Reply-To: <1604551.1686754324@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000bdc3a05fe1ecb0a@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in crypto_shash_finup
From: syzbot <syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=129a0837280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=4e2e47f32607d0f72d43
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14cfedfd280000

Note: testing is done by a robot and is best-effort only.

