Return-Path: <netdev+bounces-6566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 708C2716F1F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A823828131E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28744206AC;
	Tue, 30 May 2023 20:52:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFF79474
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:52:48 +0000 (UTC)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887B8107
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:52:46 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7636c775952so305233039f.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685479966; x=1688071966;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SpU2AdVw1Ybwch3/ygMnAAKhKAL/LfwFA3E33B8xEmQ=;
        b=OGufeNjWAIThC4vNZRcy8YnHFkCzJ78QSGVd6EX5pL0HvJc/EWk6ddc2v7bWeA/1R9
         Klr0cJDdFvygY9EVKP8VXt0wLkHgvsJQ82AiblFiypYj5TISDiHJ/Yo6Cv/+nenNvEmj
         b3hAcJMIRJnDwaTCS5Mue8R7iRPEUcmpqAiGQeCf7Dz0BPWs+xxTPkaNOeRD07bHcS1v
         IeeMH3PKfGJInwdvQ+1Hf37Fu+3/WVCwlTiX4hUwzUuxFqwu0rrtY5PYyyGBIyw/QWWk
         2cv3bkXRrZHdo//xW/bfk9mVlpEIq1274Dx8munagil7uv9kkg3BZIpN5yEIeSyACFhF
         KGIg==
X-Gm-Message-State: AC+VfDyuz9QU6OxK9/BmmYev6HmttRJwCNKR8aCG947Z0diH4awudKk1
	5nha4ZuZO2jgQObUWWF4LdvFuw+7jZRZrGlzFgZSrEV8c10P
X-Google-Smtp-Source: ACHHUZ6M+UGrk1fYFZBfPLehgrSibLYaCCEw+QqHcF+SZxmRJvPy8ryJQjyYNAJttYSinTtSDQZ7P1ra+hR5sL+y+hLPlCEtzD7t
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:8669:0:b0:41a:b094:c5b8 with SMTP id
 e96-20020a028669000000b0041ab094c5b8mr1459057jai.2.1685479965893; Tue, 30 May
 2023 13:52:45 -0700 (PDT)
Date: Tue, 30 May 2023 13:52:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4ac4205fcef62b2@google.com>
Subject: [syzbot] Monthly bluetooth report (May 2023)
From: syzbot <syzbot+listf6f400f39b8767bbed14@syzkaller.appspotmail.com>
To: johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luiz.dentz@gmail.com, marcel@holtmann.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello bluetooth maintainers/developers,

This is a 31-day syzbot report for the bluetooth subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/bluetooth

During the period, 3 new issues were detected and 2 were fixed.
In total, 23 issues are still open and 52 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 6474    Yes   possible deadlock in rfcomm_sk_state_change
                  https://syzkaller.appspot.com/bug?extid=d7ce59b06b3eb14fd218
<2> 3382    Yes   WARNING in hci_conn_timeout
                  https://syzkaller.appspot.com/bug?extid=2446dd3cb07277388db6
<3> 639     Yes   possible deadlock in rfcomm_dlc_exists
                  https://syzkaller.appspot.com/bug?extid=b69a625d06e8ece26415
<4> 82      Yes   WARNING in call_timer_fn
                  https://syzkaller.appspot.com/bug?extid=6fb78d577e89e69602f9
<5> 36      Yes   WARNING: ODEBUG bug in put_device
                  https://syzkaller.appspot.com/bug?extid=a9290936c6e87b3dc3c2
<6> 2       No    KASAN: slab-use-after-free Write in sco_chan_del
                  https://syzkaller.appspot.com/bug?extid=cf54c1da6574b6c1b049
<7> 1       No    KASAN: slab-use-after-free Write in hci_conn_drop
                  https://syzkaller.appspot.com/bug?extid=21835970af93643f25a2

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

