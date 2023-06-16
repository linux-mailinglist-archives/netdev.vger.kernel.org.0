Return-Path: <netdev+bounces-11282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42AAD732676
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85B50281684
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C70648;
	Fri, 16 Jun 2023 05:01:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED6E7C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:01:23 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948C626A2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:01:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-77d825fd3bcso26334239f.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686891682; x=1689483682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGnwxdo2DEMIi7tpDl/sj1NsuPf/fjo1eZwFLbHh/oc=;
        b=XXTj97P1JtV9rfsvm/lIssIJC5pGreZmyuwjG803UCy+Rz/+OIas9+bRMXCHeoFof4
         iV72GgaRo7AO1V0yw8KptrY69LcJdOmRM1YKQ2CZeKovqBPcnnm7EHpA8bbJAHD0QiFJ
         UB9gSF3dx3kIim6b8k6ehdjFn2lPuHkTUREzjzDNY+Q38c3p0j9O7bfhh/hHV1Ygg6oY
         xZstbZrXLMp1haDUwQIOJ/zqUyy+rZ4ZGzgWmPZ6ckLIc4hR4id0rEY4JizQf4fxxmWb
         LG/yoPC272B0kJ6nA5JyBnCAjrWYfdFRQsvGrgdymljJ4ddnq72CiZi4/v6je7BYnEWL
         vFCA==
X-Gm-Message-State: AC+VfDxqSiMZ+Q4KLUlZeIFLdaQr754qZ0AEAz7Q5PdZRUgMk0VhQEq8
	yRslgUpaFBmHhc/fpFaYeuLRbV4o6Z1DedUHcy9Mxv1/FV3H
X-Google-Smtp-Source: ACHHUZ6chEzs+H370XGbzmOcYS60hX1wyOhuKQHSGSvTc8wzvYQfpRdk/s8FYqZChd2H1Q8CFppxMqo46ogMdIqov/rMlSBJIyS+
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:3319:0:b0:423:141e:f20b with SMTP id
 c25-20020a023319000000b00423141ef20bmr303599jae.2.1686891681994; Thu, 15 Jun
 2023 22:01:21 -0700 (PDT)
Date: Thu, 15 Jun 2023 22:01:21 -0700
In-Reply-To: <415439.1686877276@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007adf2d05fe38132a@google.com>
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

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=159c4d9b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=13a08c0bf4d212766c3c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16962727280000

Note: testing is done by a robot and is best-effort only.

