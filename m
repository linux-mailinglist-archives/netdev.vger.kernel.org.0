Return-Path: <netdev+bounces-10782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8672D7304A6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88D71C20D42
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943B71118D;
	Wed, 14 Jun 2023 16:13:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885B910965
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:13:26 +0000 (UTC)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CEC1FFA
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:13:24 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-770222340cfso836014139f.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686759204; x=1689351204;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeyhKQmQJgmGwX9czunjxyhPF6/Uyh0HJoA+1LIdqE8=;
        b=J01ndPRaev0pvUARuTMselNQfvGgP1tw2BssG1654UtYF86RoSNt50A2dw6kF7FWnS
         82bUCUPZ/5uhC0xDmlbSwBsAqqENG8YJQngupu8T1xysmL/K+gxtcpAtTtcxewkm5PEr
         zR7vLqemmEnP30Y2tQDKBQFsBRSozVZPKtw0i6MkOpR9TTr5Qe5RbR2Sz8w1g+AipOEe
         odyU+t54x51W1ERimerSqwIUyyfwgr/h70UdliQRl5DPw/A0xIoPWl7r1SRXcuzStdsd
         c4U16X+Je8uq/cXFF07wMkZ0gUzlHvFlr2wgHLU6boplDftMjDTFoTaOmz0+Ij6R32ny
         ARqQ==
X-Gm-Message-State: AC+VfDzpws21ixgJaY6+miPbpkRFEHFSUrFScMb4G4UOoPbk7j9YwbwL
	joPqBCyoynqUJ2MWR+glEFHMiP0sI+bS4DKkdF5GBdaGp+c6
X-Google-Smtp-Source: ACHHUZ4r58bUvl9LoPAOXo+B6/ljIZcwyo9JK7UM90Yqibs/UTgX1tiUUXTcfd0jBjqB48XmrgyKXZl5c+T2EAc/pq3qX0C1IjMx
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5e:da05:0:b0:775:4f90:a4ce with SMTP id
 x5-20020a5eda05000000b007754f90a4cemr6194252ioj.0.1686759203788; Wed, 14 Jun
 2023 09:13:23 -0700 (PDT)
Date: Wed, 14 Jun 2023 09:13:23 -0700
In-Reply-To: <1604533.1686754299@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029dd9c05fe193bf3@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in crypto_shash_final
From: syzbot <syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com

Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=13b86427280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=14234ccf6d0ef629ec1a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15bf213b280000

Note: testing is done by a robot and is best-effort only.

