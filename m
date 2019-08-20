Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE396CF0
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfHTXJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:09:10 -0400
Received: from lekensteyn.nl ([178.21.112.251]:34323 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHTXJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 19:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=4HwCBJFfSBkXZe8xYmCQoO/bOakWt6wrHLfSFTA8ino=;
        b=DqHIfd6f8UIzx3Bsa35j8eDbh7AAhwSm9FPc9wXLKvqtE5T2rGjgfAlHg5YzwuKI1ujcJ4a0nrnx1FTlSk/6iJZi5DsySs0MX4zWNk/3LhjQQ4pC17NL0UV+BKLk5VRIsUM3NyL+4HSF2TTBlhPIB1Bg2+53eJYJY0U4yQV6va6vD8dZevdxKDhzlMMrFqZ127aS02S/FvOnFiDXjPoC4yYRjy9Sw8R0ADjkIrMjjD4aSyTLUtqgBlEhV/Hst0o1ukeOZHUshks8p5/uOC9+CKBDc5MEKRs+TMINC+3AuT0hQh7zJRHVYpgWzznbRIhDQlgSuyA+luAmZq85ompJNQ==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1i0DFO-00055S-9k; Wed, 21 Aug 2019 01:09:03 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 0/4] BPF-related documentation fixes
Date:   Wed, 21 Aug 2019 00:08:56 +0100
Message-Id: <20190820230900.23445-1-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here are some small doc updates that should hopefully save the next
eBPF/uprobe user some time. Based on v5.3-rc2, but net-next appears to
have no conflicts.

Changes since the v1[1]:
- Split bpf.h patch for kernel and userspace tools (requested by Alexei)
- Add new 'bpf: clarify when bpf_trace_printk discards lines' patch.

Kind regards,
Peter

 [1]: https://lkml.kernel.org/r/20190819212122.10286-1-peter@lekensteyn.nl

Peter Wu (4):
  bpf: clarify description for CONFIG_BPF_EVENTS
  bpf: fix 'struct pt_reg' typo in documentation
  bpf: clarify when bpf_trace_printk discards lines
  bpf: sync bpf.h to tools/

 include/uapi/linux/bpf.h       | 8 +++++---
 kernel/trace/Kconfig           | 3 ++-
 tools/include/uapi/linux/bpf.h | 8 +++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
2.22.0

