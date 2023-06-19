Return-Path: <netdev+bounces-12091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 374B1735FBF
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 00:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4ACC280FC1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F67514ABF;
	Mon, 19 Jun 2023 22:09:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200F75234
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 22:09:38 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870EAE4A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:09:37 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-77b25d256aaso389624239f.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687212576; x=1689804576;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18wIF3rKinLoRpSkehNKDsiNhig12DTTerhF0r5bB/A=;
        b=Rt2eRCC9iWY0FabXMJDCin18yO3O6pwygCbO36o9jT6lq3FhvogIAzT3f0a0ZLWAMK
         pYEknlUUh8UXKUYw+/J/xaTf0WsNI+lfjfWlEXYM9Ftppo+palax7eAd+u5HFueW/VrF
         sf2YDgYS4xVHaAG2eah2Klu21MDmhLBw8sSuTI+9n4ftInWw678u5X3CijWN+i+NUDGs
         eXkjT8iH1YMYUbXvwoATijaTaSL+P3wLVQmnh+JKx22GXjd8zO+y7H2fCf/7gcqC04zN
         5VX0jeuVPB5e8cE8QbFI/fDWy8S+lm8Q98qI5xDnpVaxR+ai0FKtkHOzM0+VpurMHsNm
         YF1Q==
X-Gm-Message-State: AC+VfDzgDpyRz0luXwFj3l5JaAtDjM3/dVw/f61i81mNKsrBu0FCctUE
	RDWm21E53GczjSrBXpl1agDmaZ9857rVX48iIubDgGL0tutV
X-Google-Smtp-Source: ACHHUZ47JiJ7D6zbVcTND2HYnJ/ijfBs9OfkopT5ILSUxZMfqmcxVgGVigX37KA31taxlGmZ9fCoz0oSgn1EnM5BowFoIAwwT2yh
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:93a7:0:b0:426:29a2:9d24 with SMTP id
 z36-20020a0293a7000000b0042629a29d24mr3087319jah.2.1687212576774; Mon, 19 Jun
 2023 15:09:36 -0700 (PDT)
Date: Mon, 19 Jun 2023 15:09:36 -0700
In-Reply-To: <1167416.1687211141@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ca4ee05fe82cae7@google.com>
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com

Tested on:

commit:         49310624 Merge branch 'ipv6-random-cleanup-for-extensi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=178ba75b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11352c83280000

Note: testing is done by a robot and is best-effort only.

