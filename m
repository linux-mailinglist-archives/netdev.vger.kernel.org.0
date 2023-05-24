Return-Path: <netdev+bounces-5102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F3970FA85
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C84F28149C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9169219BA4;
	Wed, 24 May 2023 15:34:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B041C75D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:55 +0000 (UTC)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65052135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:34:38 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-76c550fbae9so74539139f.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942467; x=1687534467;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/Qb95V1iOyhOuQYWTFvMei40qKXu9p08DPhqv0BihA=;
        b=ImHSdvtOKsUf5DcrBTHOrJQnhH2DY5UE19WHfBFBayyD8poofcA29Pdcg7cfuZYT7s
         LfFHwXaazrStPGFEfAUB46juFi3Ea9rPMClwUuWA7EHMEFpApob9oTbayUt4Z9fFzky7
         ihsb+Tb2L+JW+Wv8UhxeVSvtBuVGNNeoY+vH8hz3ELKeB5wJpYxUjf/OFMG8Xj1TkzPe
         d0ELcM2b6WLDmWBZKE+sGK0D0aUSc6rJDj+zEToI2fcFch1AilOkmyKUNBZEWPOtycmU
         jHTNYaUmahOh4hdkwIpjSxESwfx1amzqtjp/UGs0YjuC256T/VYIQ3lytyEoZf3j4FPr
         Perw==
X-Gm-Message-State: AC+VfDyvdG1FYS8hvSOSsfrS4XfseU6Vto6I4T4RKcQA9zQC/7Ju3CTH
	WinqX/b08LMfrlwOhD27Nu5KHB0qGytZ+Pm1u6X3SfcR0T5r
X-Google-Smtp-Source: ACHHUZ6q5mO1T8gb2eI3lddVojNyJnQ4DpkZF8v0v5RpIr3dT2WS/6KdBB0hkPjO44QtlWvJMFdZ7X51TbycGEQZ6z10SZfqpLAn
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:91ca:0:b0:772:aa31:db2d with SMTP id
 k10-20020a5d91ca000000b00772aa31db2dmr8623470ior.3.1684942467357; Wed, 24 May
 2023 08:34:27 -0700 (PDT)
Date: Wed, 24 May 2023 08:34:27 -0700
In-Reply-To: <b811578d-bb53-f226-424c-7d2428ffd845@mojatatu.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003bdf7205fc723d47@google.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in mini_qdisc_pair_swap
From: syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com, 
	jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, pctammela@mojatatu.com, 
	syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com

Tested on:

commit:         6078d01d net/sched: qdisc_destroy() old ingress and cl..
git tree:       https://gitlab.com/tammela/net.git peilin-patches
console output: https://syzkaller.appspot.com/x/log.txt?x=111cf24d280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b22b5699e8595bcd
dashboard link: https://syzkaller.appspot.com/bug?extid=b53a9c0d1ea4ad62da8b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

