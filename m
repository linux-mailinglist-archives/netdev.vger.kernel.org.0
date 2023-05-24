Return-Path: <netdev+bounces-4863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7559F70ED3D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459C71C20AF0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953061864;
	Wed, 24 May 2023 05:43:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88151185D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:43:40 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4D21AC
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:43:27 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7636c775952so40938639f.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684907006; x=1687499006;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVMaGANBT4FO+M+4WaVWfwLxfnECFcgkDsXKsvAj/u4=;
        b=OLwVV1Cvte/oyV/C7Yq/YX9/WMUHB65pnuHfCjsn6i1bSfU75Hn1DunHXHLNiyQjYl
         H2hRZZIr239agUZD1UtmU3o5iqTfGFBpffDFHK+fboDU17s3BHaYrMWXCJeuoRwRKJ+Q
         ZxUWgl2BLy8DMMfBcGJkfnnDnV6Ckr622UautIoXTnH2hZJ4o0vIZYaHqh0rkzSZnTFE
         CFEyed61YcKbyJQXAR14yNcNSa0qoqkLK4vUi22QIyLi4+fbdQj6gEGP/MfMZDiaGDmN
         J9gxqz1h3zNpaouOQoFyY5b9E5hPZ5Q4/WTQ1O5AvJLhkaGu8CpjYqoo5mOfUOqqroa5
         IIhQ==
X-Gm-Message-State: AC+VfDz82Ow+/Pwj/AVQ+5NnrEPzheOXt2nSR3NKbB1S93NsttGVUVUK
	tFGhiw7vtTrK/rfYeE9aEq9SVT5ydMrvnSvFlo9IZd3g1AnT
X-Google-Smtp-Source: ACHHUZ6E+B0ThBWOffyc/2kjmrvqKXkx5dohzqDxl4C5/YcAggY515Y7n0augbCIg4gJcLhcroaufm/VAh/xlIcI7ey6+zMbI6As
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2585:b0:774:7cc5:6682 with SMTP id
 p5-20020a056602258500b007747cc56682mr2664467ioo.3.1684907006403; Tue, 23 May
 2023 22:43:26 -0700 (PDT)
Date: Tue, 23 May 2023 22:43:26 -0700
In-Reply-To: <000000000000959f6b05ed853d12@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098aa2305fc69fb67@google.com>
Subject: Re: [syzbot] [nfc?] INFO: task hung in nfc_rfkill_set_block
From: syzbot <syzbot+3e3c2f8ca188e30b1427@syzkaller.appspotmail.com>
To: brauner@kernel.org, broonie@kernel.org, catalin.marinas@arm.com, 
	davem@davemloft.net, edumazet@google.com, faenkhauser@gmail.com, 
	hdanton@sina.com, krzysztof.kozlowski@linaro.org, kuba@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-nfc@lists.01.org, luiz.von.dentz@intel.com, 
	madvenka@linux.microsoft.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	scott@os.amperecomputing.com, syzkaller-bugs@googlegroups.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has bisected this issue to:

commit 7ac7267fad5908476b357e7e9813d23516c2b0a1
Author: Fae <faenkhauser@gmail.com>
Date:   Sun Jul 24 18:25:02 2022 +0000

    Bluetooth: Add VID/PID 0489/e0e0 for MediaTek MT7921

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1523596a280000
start commit:   ae8373a5add4 Merge tag 'x86_urgent_for_6.4-rc4' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1723596a280000
console output: https://syzkaller.appspot.com/x/log.txt?x=1323596a280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=927d4df6d674370e
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3c2f8ca188e30b1427
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1099e2c5280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113f66b1280000

Reported-by: syzbot+3e3c2f8ca188e30b1427@syzkaller.appspotmail.com
Fixes: 7ac7267fad59 ("Bluetooth: Add VID/PID 0489/e0e0 for MediaTek MT7921")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

