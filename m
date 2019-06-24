Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C1504AB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfFXIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:39:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:42278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfFXIjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 04:39:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 01:39:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,411,1557212400"; 
   d="scan'208";a="151887908"
Received: from um.fi.intel.com (HELO localhost) ([10.237.72.63])
  by orsmga007.jf.intel.com with ESMTP; 24 Jun 2019 01:39:01 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     syzbot <syzbot+37100ea87beb0cac28f4@syzkaller.appspotmail.com>,
        acme@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jolsa@redhat.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        namhyung@kernel.org, netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com
Subject: Re: KASAN: use-after-free Read in _free_event
In-Reply-To: <000000000000dea828058c0d815d@google.com>
References: <000000000000dea828058c0d815d@google.com>
Date:   Mon, 24 Jun 2019 11:39:00 +0300
Message-ID: <87pnn3v0m3.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+37100ea87beb0cac28f4@syzkaller.appspotmail.com> writes:

> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+37100ea87beb0cac28f4@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in atomic_read  
> include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: use-after-free in refcount_sub_and_test_checked+0x87/0x200  
> lib/refcount.c:182
> Read of size 4 at addr ffff88804e9f06e0 by task syz-executor.5/13046

Looks exactly like [1]. There's a proposed fix there, too.

[1] https://marc.info/?l=linux-kernel&m=153111554522295

Regards,
--
Alex
