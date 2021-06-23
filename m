Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A1A3B1E83
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWQV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhFWQVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:21:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12980C061574;
        Wed, 23 Jun 2021 09:19:38 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id f30so5118863lfj.1;
        Wed, 23 Jun 2021 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=/Krbzq37k1sCPaakVsLwyC67OCSSZuxfiSPx6Qi5QzI=;
        b=M86HOfXUVH5O2ebnaL7FrciUwyvUFN27hWfI2LxJxr+s2VCB+vAfueoKTr2aZIxu8p
         LEoUcsoO9/tygtHYwRsAfA6WDe7/fKvEohFVyaQYbrfyDmAmiAag1ZnYJAohUjfdhM2T
         E+WimHdKu4hcGwx1Qv08kZBvNDM85qrzlHCIbhyzmFfUAq4Gi6Hq9XVJbAlRExna7Brb
         fSdyvDURW2nPzRmSFvPsa/xj2AYzIB62VB5yZuk05AEFPcwTdjCLiyJB4rudb0ErPFWQ
         k68f0o/0ikcwCC+kLadGhYVX3FJglXCQgXzyASf4hWKRufneeYMgD/NKpWhlG3TBCxgt
         OB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=/Krbzq37k1sCPaakVsLwyC67OCSSZuxfiSPx6Qi5QzI=;
        b=aH0Tgs/PNAnLmydzZaP1pxa8jPh2IGpr1zyh5oy/zi0QFGq9fwfr5B0hzTc02s2gWj
         0+AT1OQSMD+fWHKXmO7+L1Qfhv8AyyqdaVZJC+UTu0qOMmFPE0mby9pd1tycenJfQ/Zg
         VBkoJhnYUc4Qq+8zRX51/5E8SF6WGrApXGn+k6kGxAt1MoJlNIQqLERMNVN6ZUyUV626
         VoU4MwhAiWU9dBmjwiD0N//siSryRrhipMecCdohN29MZ+5AuEF+7MkvqC3sRpNR1ton
         W5GR9jBYwUONsoj5Eqt7Cnf5wOrwYyaC4BrGWLkFSazQgjtowhbJCxkEwFHkpGaT85UO
         VDqQ==
X-Gm-Message-State: AOAM531/ZGSqqrHmjg1wplbvBXg/42OTx70Wm6yveLGeUZPfqGO7gGH8
        Sji5ue3l8RIBwHvkh7kklz0=
X-Google-Smtp-Source: ABdhPJxPos8WRklKRY4cTHO1X3q1tR2gxIW/5WTxL+4ITuO4LXCxH4mt9tAEYN4uVXLjGfVdVG9Kxg==
X-Received: by 2002:a19:7414:: with SMTP id v20mr294814lfe.203.1624465176302;
        Wed, 23 Jun 2021 09:19:36 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id h24sm42632lfp.60.2021.06.23.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:19:35 -0700 (PDT)
Date:   Wed, 23 Jun 2021 19:19:28 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] WARNING: zero-size vmalloc in corrupted
Message-ID: <20210623191928.69d279d1@gmail.com>
In-Reply-To: <000000000000aa23a205c56b587d@google.com>
References: <000000000000aa23a205c56b587d@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/WS2tHtsc/ybjuavLYXEFySg"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/WS2tHtsc/ybjuavLYXEFySg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 23 Jun 2021 02:15:23 -0700
syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    13311e74 Linux 5.13-rc7
> git tree:       upstream
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=15d01e58300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=42ecca11b759d96c
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=c2f6f09fe907a838effb syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=14bb89e8300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cc51b8300000
> 
> The issue was bisected to:
> 
> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Apr 21 07:51:08 2021 +0000
> 
>     netfilter: arp_tables: pass table pointer via nf_hook_ops
> 
> bisection log:
> https://syzkaller.appspot.com/x/bisect.txt?x=13b88400300000 final
> oops:     https://syzkaller.appspot.com/x/report.txt?x=10788400300000
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=17b88400300000
> 

This one is similar to previous zero-size vmalloc, I guess :)

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master


With regards,
Pavel Skripkin

--MP_/WS2tHtsc/ybjuavLYXEFySg
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-media-dvb-usb-fix-wrong-definition.patch

From b1ed745713bb840e0778c5a13f1f83f535dca044 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Wed, 23 Jun 2021 19:18:09 +0300
Subject: [PATCH] media: dvb-usb: fix wrong definition

/* ..... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 761992ad05e2..7707de7bae7c 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1947,7 +1947,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 
 	.size_of_priv     = sizeof(struct cxusb_state),
 
-	.num_adapters = 2,
+	.num_adapters = 1,
 	.adapter = {
 		{
 		.num_frontends = 1,
-- 
2.32.0


--MP_/WS2tHtsc/ybjuavLYXEFySg--
