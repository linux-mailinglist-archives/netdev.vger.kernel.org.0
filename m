Return-Path: <netdev+bounces-11847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A862734D50
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 958EC280F62
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819F96FCA;
	Mon, 19 Jun 2023 08:14:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FB76ADF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:14:39 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80889A8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:14:34 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f904dcc1e2so20094075e9.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687162473; x=1689754473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ax91G0/XOaurWggOagZUW9d+gzSuYbqAMviaKgvftv8=;
        b=ZAuBrZYpvzGHo0My7GqFuUJVwH948L9FGyVQYnhc/kbRzKBvIIiVLCIqgxC+NrHt36
         BhwVVHbnK1bDKTaS2CWLH2Y4CFEiwo9cG2GTt385zL8JR2gIA/BV94iEueOD036U3Px3
         1we8G3AO/ihaPNwdPpZRU8Px/6eOHuH8Wt0HUxwumlyKWxU5QTXBMcLBK/6ypUKLqbbN
         /SSUNQEPcrzLO248vNVzkGa8MAWAGicnNjC9Swpf4Ix5oom6u20BblrjWzvC78e1SSJL
         kViWQE0sf0+pXibWM8oKYVNTP2/p+BxlUXkdWgi15Bj7XBkoMhy1ArNXJb1y1DkkDsqC
         iDgQ==
X-Gm-Message-State: AC+VfDwhNcw+4Z5KQ/m4p/PfBMcZeg53rpsorEJ+XcoVmXfDVQAUXfuv
	UhbDPPzTyctOdKXa+riJ5tM=
X-Google-Smtp-Source: ACHHUZ5pqJfR2633UV8ABpTU1YM4wcftCToBFUHG9QIBAmIcP9VxYM9QjA6lifjjoUhMtD1/+OmuZA==
X-Received: by 2002:a05:600c:250:b0:3f7:f5a4:1f96 with SMTP id 16-20020a05600c025000b003f7f5a41f96mr7301502wmj.22.1687162472688;
        Mon, 19 Jun 2023 01:14:32 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-021.fbsv.net. [2a03:2880:31ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c365300b003f74eb308fasm9733155wmq.48.2023.06.19.01.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:14:32 -0700 (PDT)
Date: Mon, 19 Jun 2023 01:14:30 -0700
From: Breno Leitao <leitao@debian.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	syzbot <syzkaller@googlegroups.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] ipv6: fix a typo in ip6mr_sk_ioctl()
Message-ID: <ZJAOZhSf0fAaf6Lg@gmail.com>
References: <20230619072740.464528-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619072740.464528-1-edumazet@google.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 07:27:40AM +0000, Eric Dumazet wrote:
> SIOCGETSGCNT_IN6 uses a "struct sioc_sg_req6 buffer".
> 
> Unfortunately the blamed commit made hard to ensure type safety.
> 
> syzbot reported:
> 
> BUG: KASAN: stack-out-of-bounds in ip6mr_ioctl+0xba3/0xcb0 net/ipv6/ip6mr.c:1917
> Read of size 16 at addr ffffc900039afb68 by task syz-executor937/5008
> 
> CPU: 1 PID: 5008 Comm: syz-executor937 Not tainted 6.4.0-rc6-syzkaller-01304-gc08afcdcf952 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
> print_report mm/kasan/report.c:462 [inline]
> kasan_report+0x11c/0x130 mm/kasan/report.c:572
> ip6mr_ioctl+0xba3/0xcb0 net/ipv6/ip6mr.c:1917
> rawv6_ioctl+0x4e/0x1e0 net/ipv6/raw.c:1143
> sock_ioctl_out net/core/sock.c:4186 [inline]
> sk_ioctl+0x151/0x440 net/core/sock.c:4214
> inet6_ioctl+0x1b8/0x290 net/ipv6/af_inet6.c:582
> sock_do_ioctl+0xcc/0x230 net/socket.c:1189
> sock_ioctl+0x1f8/0x680 net/socket.c:1306
> vfs_ioctl fs/ioctl.c:51 [inline]
> __do_sys_ioctl fs/ioctl.c:870 [inline]
> __se_sys_ioctl fs/ioctl.c:856 [inline]
> __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f255849bad9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd06792778 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f255849bad9
> RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
> RBP: 00007f255845fc80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f255845fd10
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> </TASK>
> 
> The buggy address belongs to stack of task syz-executor937/5008
> and is located at offset 40 in frame:
> sk_ioctl+0x0/0x440 net/core/sock.c:4172
> 
> This frame has 2 objects:
> [32, 36) 'karg'
> [48, 88) 'buffer'
> 
> Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl callbacks")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Breno Leitao <leitao@debian.org>

