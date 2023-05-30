Return-Path: <netdev+bounces-6328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 703D3715C55
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 169C41C20BCA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FAB154B4;
	Tue, 30 May 2023 10:56:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA18B134A5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:56:58 +0000 (UTC)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECEC102
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:56:56 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-76c27782e30so254136039f.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444216; x=1688036216;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B2MXCgTNPKfxKRGLHYFjMw3S62/mrODmRY8sffg8JIM=;
        b=GUFMo2zN3DQrnlbWxaDqLGc4TkKDzTMShHIg1i1oGuzHU8heHlB2I78MtpjmoFQsDY
         yY1TtxI5azTMFBx6bTrHLD7zpuaYCXXw5zOYA2/dtjJ683sNwzajPcSrt1/4CstDrKjS
         KynLldEa1MOs4mNNfmvDgc++794gBNYL02tvgAok926fzA/HUkAyjgq3VNpkSSYNKBMd
         gTJYydYKTc5+02doDeZEttp3myGAVtLG5AkdZqYg5rXlZmdKq0oVEeKYo1Qnvi8tK4hj
         fnMZnIbd1gqfx6bOvNKkMCzwDLw3mSjd1U96GG881ZZQdlQsa6Xd2SGv5aqRHtZbk1O+
         znLg==
X-Gm-Message-State: AC+VfDwLKCst7WIDQjwnT0Gh2hCx6wofXRjEgsh4i6mbSbwjNN6jqM3E
	K4bnCTNkRXHfCYUNyGDG0CcToF5DQuKRaFF9PBh+Sb4+SzfD
X-Google-Smtp-Source: ACHHUZ77XvY3N2+clQmovB0BYpuU6b6Mt4VnhEXOgMa9EA7Y4eFygYpSareAQxBLgDU7450lBoRAHKY6+p0bpaVoTvBZ3Eny92ZO
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cc43:0:b0:335:908b:8fb with SMTP id
 t3-20020a92cc43000000b00335908b08fbmr925354ilq.1.1685444216237; Tue, 30 May
 2023 03:56:56 -0700 (PDT)
Date: Tue, 30 May 2023 03:56:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc339905fce70fee@google.com>
Subject: [syzbot] Monthly net report (May 2023)
From: syzbot <syzbot+list0c78593482015785d68d@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
	FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello net maintainers/developers,

This is a 31-day syzbot report for the net subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/net

During the period, 6 new issues were detected and 7 were fixed.
In total, 75 issues are still open and 1261 have been fixed so far.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  6348    Yes   WARNING in dev_watchdog (2)
                   https://syzkaller.appspot.com/bug?extid=d55372214aff0faa1f1f
<2>  3665    Yes   KMSAN: uninit-value in eth_type_trans (2)
                   https://syzkaller.appspot.com/bug?extid=0901d0cc75c3d716a3a3
<3>  820     Yes   INFO: task hung in switchdev_deferred_process_work (2)
                   https://syzkaller.appspot.com/bug?extid=8ecc009e206a956ab317
<4>  442     Yes   INFO: task hung in rtnetlink_rcv_msg
                   https://syzkaller.appspot.com/bug?extid=8218a8a0ff60c19b8eae
<5>  380     Yes   KMSAN: uninit-value in IP6_ECN_decapsulate
                   https://syzkaller.appspot.com/bug?extid=bf7e6250c7ce248f3ec9
<6>  322     Yes   WARNING in kcm_write_msgs
                   https://syzkaller.appspot.com/bug?extid=52624bdfbf2746d37d70
<7>  310     No    KMSAN: uninit-value in __hw_addr_add_ex
                   https://syzkaller.appspot.com/bug?extid=cec7816c907e0923fdcc
<8>  258     No    BUG: stack guard page was hit in rtnl_newlink
                   https://syzkaller.appspot.com/bug?extid=399cbcbb7917bd2f96ee
<9>  240     Yes   KASAN: slab-out-of-bounds Read in decode_session6
                   https://syzkaller.appspot.com/bug?extid=2bcc71839223ec82f056
<10> 215     Yes   KMSAN: uninit-value in xfrm_state_find
                   https://syzkaller.appspot.com/bug?extid=131cd4c6d21724b99a26

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

