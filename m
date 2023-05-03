Return-Path: <netdev+bounces-226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D4B6F6239
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AECE01C21061
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 23:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAA1F512;
	Wed,  3 May 2023 23:51:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103B87484
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 23:51:24 +0000 (UTC)
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11AC8A57
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:51:21 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3294f07346aso39102535ab.0
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 16:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157881; x=1685749881;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcZ85UohRTnIlpcVoJh324dST1aeKdAB/UA/Qi32hS0=;
        b=CE002+vLxUX0Jz2mmeEZuZm+0IvDvft8FKxK+GZKi9BSVv8D2SBv4zRAybZPSQPMzJ
         CW+A/RULPkGD5dTGx1PH9SKvYaQOxeeYYoZAnCzp+JUixgMsJnNhgto1UnRdmK6FTX8v
         l5Qx0n8ww42L7VPCGJwSG1wa0J72I9YgpFr5CjUXvV9NfDYvwdI4M4FdYz9PZPJnDNWF
         VJDe1j0wlX4KBFr3S0XHyLPuyples1mKBOA9JGkDktTCkfxUFBOfSjWNeW4o2M4TtScp
         b8n+XgEJ5KxDHHfw+fMplWizIFKRlo8ATqKBvnVOHPaj6jkMGrhc+bBkY0XPd+D6eMcE
         vxOQ==
X-Gm-Message-State: AC+VfDxzD/Z+7bAkxd1CHA4o8HYjy9Y/ycP3e/vICgKXptQJxX2ZrigX
	sxN0nhbHELS14X3XY6pjbKM8ZptyXj2KZV40L2AwxFZmsEP7
X-Google-Smtp-Source: ACHHUZ7Bf2UNPAy6HXsUp7lRc0mXPoN88gh/boNNoZyrLkLf7rtC9mZT8aNT0c9J8Qez6j0MPSy/gM8e2N9XAxh1nMIZgRQwIOzs
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:3306:0:b0:40f:8b6d:c549 with SMTP id
 c6-20020a023306000000b0040f8b6dc549mr11170398jae.2.1683157880999; Wed, 03 May
 2023 16:51:20 -0700 (PDT)
Date: Wed, 03 May 2023 16:51:20 -0700
In-Reply-To: <00000000000065fe6705cad8850e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000991adc05fad2bb84@google.com>
Subject: Re: [syzbot] [can?] WARNING in j1939_session_deactivate
From: syzbot <syzbot+535e5aae63c0d0433473@syzkaller.appspotmail.com>
To: davem@davemloft.net, idosch@nvidia.com, jacob.e.keller@intel.com, 
	jiri@nvidia.com, kernel@pengutronix.de, kuba@kernel.org, 
	linux-can@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org, 
	pabeni@redhat.com, robin@protonic.nl, socketcan@hartkopp.net, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot suspects this issue was fixed by commit:

commit b20b8aec6ffc07bb547966b356780cd344f20f5b
Author: Ido Schimmel <idosch@nvidia.com>
Date:   Wed Feb 15 07:31:39 2023 +0000

    devlink: Fix netdev notifier chain corruption

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=120779c4280000
start commit:   7cd8b1542a7b ptp_pch: Load module automatically if ID matc..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
dashboard link: https://syzkaller.appspot.com/bug?extid=535e5aae63c0d0433473
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1488b8e0b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14eabe3f300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: devlink: Fix netdev notifier chain corruption

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

