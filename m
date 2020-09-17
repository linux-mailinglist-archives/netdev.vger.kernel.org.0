Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9526D5B6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgIQIH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgIQIGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 04:06:37 -0400
Received: from mail.kernel.org (ip5f5ad5d2.dynamic.kabel-deutschland.de [95.90.213.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC07920707;
        Thu, 17 Sep 2020 08:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600329870;
        bh=2vRvBaqh9EKp9T9C1x2X/Aw5e2zrJra1E4+MhA18gXM=;
        h=From:To:Cc:Subject:Date:From;
        b=JwMinYkF0td1iRhPW6tYFYQK+S7ineNCASogVdgKBrsKxz4mmq+nyP57pilLOicSW
         mW5kv6Dca7sMxfzTudNRr/uKLQuG5PWfYo/j4P+yvMvZ1mcWh0YwiaUHO0ufDxu8OU
         dmMBEW7Mj0h6WR3KhpliVNeoCCyqQDWt7g8/f1ZI=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kIou4-0051LO-6j; Thu, 17 Sep 2020 10:04:28 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alexander Potapenko <glider@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        William Kucharski <william.kucharski@oracle.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org
Subject: [PATCH 0/3] Additional doc warning fixes for issues at next-20200915
Date:   Thu, 17 Sep 2020 10:04:24 +0200
Message-Id: <cover.1600328701.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple of new warnings introduced at linux-next.

This small patch series address them.

The complete series addressing (almost) all doc warnings is at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=doc-fixes

I'll keep rebasing such tree until we get rid of all doc warnings upstream,
hopefully in time for Kernel 5.10.

Mauro Carvalho Chehab (3):
  docs: kasan.rst: add two missing blank lines
  mm: pagemap.h: fix two kernel-doc markups
  docs: bpf: ringbuf.rst: fix a broken cross-reference

 Documentation/bpf/ringbuf.rst     | 2 +-
 Documentation/dev-tools/kasan.rst | 2 ++
 include/linux/pagemap.h           | 8 ++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.26.2


