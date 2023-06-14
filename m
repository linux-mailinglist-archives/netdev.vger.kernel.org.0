Return-Path: <netdev+bounces-10772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B327303F5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B9641C20D1A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343FC101FC;
	Wed, 14 Jun 2023 15:36:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247382C9C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:36:39 +0000 (UTC)
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B154A1FC2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:36:38 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-340a23a8153so5368375ab.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686756998; x=1689348998;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phQ7TSdnMlVGNbVCPYRQr4PU6UmUaw+34QpLb3+bJI4=;
        b=C3W2FhGPmeBXBNl9uoiadOVu46rfqFf1DzhzX8bztlErfyAH8H9t+xCdRf3pCJSSEQ
         Qfq4DiTYgW8B5LLq/VavFdQd1PQAywfQkaMrWEoegbsp3lWYML//4nuU0WMi/36AGWV6
         SuTA5ZTn11GBPb56MDnCLreQrFaOQj7AWmE4ewhpVJuST0pGPsnw24w3f+CPl4Qz/4iE
         3l9T2RRZI8coB5VOdW2Td2hQtYlh2UjT1MwCdylITLVoMBYpNDne2MQtFC9kHeZmSau4
         GR4yke2RQaith4W+hzHd7RYpLFWI0MzWYnbhgk0aNJLtOE1h90nPz848+g8uIZ7qCiMt
         gsDw==
X-Gm-Message-State: AC+VfDxuWH7Pg8kwky55Ej0IodDe1eT2qgnyd63635WJjIGG6U0hkXW9
	YMSzALZ9LL48wr/ELnIpCIpDlTXAwbdLH5T8etllF+uyWTfO
X-Google-Smtp-Source: ACHHUZ7Mkn9ZMRRLMYl80aZSQLcCbxjmQJ6yFASgFB/JtRpTXHcQNP4UiwWC3PuH4cNNqXMPQQRnYk8btGq1P2PL9D8qzqx2spm+
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d442:0:b0:340:9f52:a982 with SMTP id
 r2-20020a92d442000000b003409f52a982mr646147ilm.6.1686756997948; Wed, 14 Jun
 2023 08:36:37 -0700 (PDT)
Date: Wed, 14 Jun 2023 08:36:37 -0700
In-Reply-To: <1602673.1686753912@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af6e4905fe18b762@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_final
From: syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=17790627280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=13a08c0bf4d212766c3c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14c0019d280000

Note: testing is done by a robot and is best-effort only.

