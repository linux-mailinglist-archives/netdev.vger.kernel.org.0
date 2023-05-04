Return-Path: <netdev+bounces-312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FBE6F702F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59A471C21205
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD96A940;
	Thu,  4 May 2023 16:48:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDCFFC1E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:48:03 +0000 (UTC)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4EA4C37
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 09:47:41 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-760ebd1bc25so45783539f.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 09:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683218849; x=1685810849;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWpjF4Bamr/uAlbk5+thvSEr3uGSTELUNEl8xA/w3zM=;
        b=ElBetEQOr4AWDMJrc5gcewDjeO4eJjWFeE117uqdgfHR8l1YejmPvNE9ubL57gqgsQ
         FbFayyV3EpYJSTL6c+IKjfR19n/CtjPLNNQ6EMxPH5s3dCJVmoQfPBscx/5f0Bbk5d69
         6FQGQEuZM4sNYS8hH+FkVp+bts44Hhxc/67wSRVsyIxf/JunRKUy/TFXu6yfybBFpm9A
         2hZzuDQ+mccsQB8WpB3o1d3BgiRnft6TaJQ4B3AP7p46wAd5ES1XYCLnrmvIp5/Aoc6+
         X82i1FVG33HFbdLT2at7N58f2pvV18SA/1AUzg56I/jvZ5aKnv3yvflrlLIl6tqajK7S
         Sn3g==
X-Gm-Message-State: AC+VfDyXvyUmwEG1mk/6JX/Lj8RvtrqI8iKwvsYfBNeHacur7WJ/xcq4
	6gmXbl4IxRf48eqqFn2rfVf/GGVcX+Xfflp90pWoUT0OQA3n
X-Google-Smtp-Source: ACHHUZ5SZU2SmCOWlboo7Uh+rQCO1f6NOtN2Ip3jDJiWe24VB/gKcB7g4seQWvUIw+UP8Xp7S1XBVelINmQdFvYroY2s3raHckvZ
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:9f4a:0:b0:760:ebc0:c396 with SMTP id
 u10-20020a5d9f4a000000b00760ebc0c396mr118960iot.3.1683218848919; Thu, 04 May
 2023 09:47:28 -0700 (PDT)
Date: Thu, 04 May 2023 09:47:28 -0700
In-Reply-To: <000000000000951c2505d8a0a8e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000091b72905fae0eda2@google.com>
Subject: Re: [syzbot] [can?] WARNING in j1939_session_deactivate_activate_next
From: syzbot <syzbot+3d2eaacbc2b94537c6c5@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, kernel@pengutronix.de, 
	kuba@kernel.org, linux-can@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org, 
	o.rempel@pengutronix.de, pabeni@redhat.com, robin@protonic.nl, 
	socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com, 
	william.xuanziyang@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot suspects this issue was fixed by commit:

commit d0553680f94c49bbe0e39eb50d033ba563b4212d
Author: Ziyang Xuan <william.xuanziyang@huawei.com>
Date:   Mon Sep 6 09:42:00 2021 +0000

    can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10cf0990280000
start commit:   fa182ea26ff0 net: phy: micrel: Fixes FIELD_GET assertion
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
dashboard link: https://syzkaller.appspot.com/bug?extid=3d2eaacbc2b94537c6c5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1455e3b2880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10296e7c880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

