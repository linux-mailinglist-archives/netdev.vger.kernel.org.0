Return-Path: <netdev+bounces-4470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F3970D0EB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFDB281011
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7471FAB;
	Tue, 23 May 2023 02:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25554C89
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:13:28 +0000 (UTC)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B877102
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:13:25 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7606e3c6c8aso268613939f.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684808005; x=1687400005;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ld4BfU0VLxl5x6yDFqKhqit5WImG/Bc0Y+8M10OgY8w=;
        b=IxeP6WMnqWz3ULiXpRe3r4AJHPodxp8jhmAiqaeFXjQleYk/SB/DrahITXPDEUPg4p
         Lb5n0M01EulWqw46nlx9qycxavrXXhcU8onU13Jfqa8ewcuWK3vxuZNkoRKIYyA3QOjv
         ifUesxG/ZKLDxZ7C8kW1eujpB4seHPi5f0zqqMjtUA04IxKlvOWVnJiQSuwdi4vJYZOD
         j0cz59e21HC/JAEHRBStuoev/SAz0TEADHR5QYWdds49Rmdsv6FOoFO6/EWPKUfbJOOE
         W6kq/+7rBqgm8DVNmvTpRhsfm/gP0m6GgxCh84RUdYl/yYnEgfaS9FcvGvqAgVSN9x0+
         ESRw==
X-Gm-Message-State: AC+VfDzQABm4mwfcV5Kb3020AnLkbvXY0a87tRFr6NY4ZtXmKPaw8i2b
	2XnRbplv940LDRTfI8bzBsQ8FCnJa8sL8Z0KShaji/hTgcfy
X-Google-Smtp-Source: ACHHUZ6i6qzx3KdoUGB7zeJblsyBnPyyqo41SA9bhWFsK3Nb5NGsyRpwbwbw1HfPzqgiRMrvMwUxicSR/e1VGxCVLUwruyVS/iNd
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:85cb:0:b0:3c5:1971:1b7f with SMTP id
 d69-20020a0285cb000000b003c519711b7fmr6203433jai.6.1684808004894; Mon, 22 May
 2023 19:13:24 -0700 (PDT)
Date: Mon, 22 May 2023 19:13:24 -0700
In-Reply-To: <0f3f5941-0a95-723e-11e1-6fad8e2133b0@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a589d005fc52ee2d@google.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
From: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>
To: guoqing.jiang@linux.dev, jgg@ziepe.ca, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/infiniband/sw/rxe/rxe_qp.c
patch: **** unexpected end of file in patch



Tested on:

commit:         56518a60 RDMA/hns: Modify the value of long message lo..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-rc
dashboard link: https://syzkaller.appspot.com/bug?extid=eba589d8f49c73d356da
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=132bea5a280000


