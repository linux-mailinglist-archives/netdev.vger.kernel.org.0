Return-Path: <netdev+bounces-4488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BAF70D1D1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B841C20C20
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0101E5383;
	Tue, 23 May 2023 02:55:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96AF1108
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:55:29 +0000 (UTC)
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC0ACA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:55:28 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-338280a9459so5408385ab.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810528; x=1687402528;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RzBf17vg6dtaNKaRDsG+PPT0AxYkn2WCnZwmKI0a8Ww=;
        b=FTDyQDiqXEgV9VsX/ZHZvFgQZf76+TLJWsDUkaW4Uaf9Uo4CIkC/0YHNToZp6jChJs
         xljMYY3RIsOXzrVzxB92lTAVIpmQsIBuZE35vP7O8jdliAO/IUO1kf5gFiCzKLiFsAxF
         RuF81FY+uuXgOA8YZDheRF7/jsvU4w6KfprdRcc+HAEcHIA4qGFWeVrWWiS0pWGGEZF4
         LPypobQztmKB0a8fmwYYIRE7Oh8yz+6oymklvP2UHgep9pe7acgcfOtXd2zur3x+uzWC
         c9FJUhvT/+gqi3ewOgY41XbdzWqZez54CL+AJZI8w76GEP62t9sCz1Ja1Fp6Cx7a8lJ+
         mUlA==
X-Gm-Message-State: AC+VfDxAnT6GRLCF7CsG3HimIaIHP04aDbSaXbij4NEDN6tnPaShaRzU
	hNF+n7Oth7ibDDObmHAFzPzcVAi3+m0wTpKRVJssBdZW5Ny2
X-Google-Smtp-Source: ACHHUZ4HxvGKSx7a74k5XOIS6AmhgczH+9mrK4yfFo1fiil6sOeYFY/5MiHA8viaAEXwgj6gVzYrKXIY/Zydbs9WwAro4Q3CY+4a
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:da0a:0:b0:333:760c:8650 with SMTP id
 z10-20020a92da0a000000b00333760c8650mr7006782ilm.6.1684810528147; Mon, 22 May
 2023 19:55:28 -0700 (PDT)
Date: Mon, 22 May 2023 19:55:28 -0700
In-Reply-To: <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b54ae05fc538543@google.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
From: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>
To: guoqing.jiang@linux.dev, jgg@ziepe.ca, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com

Tested on:

commit:         56518a60 RDMA/hns: Modify the value of long message lo..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-rc
console output: https://syzkaller.appspot.com/x/log.txt?x=1100bb5e280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bc832f563d8bf38
dashboard link: https://syzkaller.appspot.com/bug?extid=eba589d8f49c73d356da
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10847e2e280000

Note: testing is done by a robot and is best-effort only.

