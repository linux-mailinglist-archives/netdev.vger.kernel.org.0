Return-Path: <netdev+bounces-12129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 093DD7365C3
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15BF728107D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEE78471;
	Tue, 20 Jun 2023 08:09:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3323C4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:09:22 +0000 (UTC)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F7CE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:09:19 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77a1d6d2f7fso417934539f.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687248558; x=1689840558;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPOmXK+JJS4XSvlfMU0a0e+c0GK1JCtS0fKF/mMBn1s=;
        b=BP7nEko2UWlcMY0+6AKA3xX6ERnJHKJGBClOxPotPoG8V9CqKB0Us4LGY7S2rVj7Vf
         dyxyrZTT6zU8W6alQp6LvsvHyun8ZzIuE3LiLwVUeBgEMWCwxkGbWMrV9AgZhyVJNIdi
         1tf+FXZdvP5wJPgu/VUKUTk1Js20bf6PXUyxp05wkvS8WCQa6guprxH5C+2PBylfILjY
         TaNytYcGIqzdGdYaYsiBOg8x/zl8+kWrsYde+88gPth/IHs8oUdg8stO2/FrmnPN1aIl
         6FMOyvI9nB0KmlU7yVlk10bsnb3StjaR0F302yHcARP8FwEH0re3HFCcfAWGppNE0rOs
         Hbag==
X-Gm-Message-State: AC+VfDxMVdNoXdh9CnZm5glQXS/4hthgVND0b1t6yr1gSe7n3I97zMvJ
	VflI4FRH+5lraqdAk41V2YoFsyi23UUhPwXI7LuMiBZkfzYu
X-Google-Smtp-Source: ACHHUZ47imoHu3Jlv7gSHJneCOAcUD5Sx26XyRsq93AybmIdKnUTNEssmEu5sY2CCI52QcBpBYoNLifZf2DdT28IgIIcEVk/2WfB
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:9e58:0:b0:766:6741:8856 with SMTP id
 i24-20020a5d9e58000000b0076667418856mr3886774ioi.4.1687248558828; Tue, 20 Jun
 2023 01:09:18 -0700 (PDT)
Date: Tue, 20 Jun 2023 01:09:18 -0700
In-Reply-To: <1221049.1687246988@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff364905fe8b2a25@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
From: syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com

Tested on:

commit:         49310624 Merge branch 'ipv6-random-cleanup-for-extensi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=141473e3280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13365e5b280000

Note: testing is done by a robot and is best-effort only.

