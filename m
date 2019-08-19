Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5980C94FCA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfHSVV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:21:29 -0400
Received: from lekensteyn.nl ([178.21.112.251]:54743 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfHSVV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 17:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=SMCM1/Omy5aZ6jb+znsoIkaQU1iSr5QK5Mh7zfQA9ek=;
        b=Xh9d4nDMWnin3Fu9BR+N5VFYahiJ6norxCVbwQp0rftp3fce4eZfmaZyp7EGwXEsQz3ZHTD/PU4xQ5l4dGiyDPtAH8BYlTqk8LDhL5CY3Kr1CCBAYXMZhepEUOcvmyA01UV/RC8q4havaXHnGZcoOC4bBzTpDjyZCQ5cgyoBRARanXXrfng0LWzEX5rSjYtdP6PzB8Z7CqmOSxCvo8ieS9yknv9sh98bOnLK6nJ/gpDYVC6jFtIuE47JSNQBIl6ogOSQRBlsRzdx+u3M5Pp46yFDLCIbHrhkRCFxvpNpZAxlZpbR1gLirblAMo3zKA7ES9xxG4HacfMwH5FAu3RaoA==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hzp5g-0005T6-6Z; Mon, 19 Aug 2019 23:21:24 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 0/2] Small BPF documentation fixes
Date:   Mon, 19 Aug 2019 22:21:20 +0100
Message-Id: <20190819212122.10286-1-peter@lekensteyn.nl>
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

Some fixes for doc issues I ran into while playing with BPF and uprobes.

Kind regards,
Peter

Peter Wu (2):
  bpf: fix 'struct pt_reg' typo in documentation
  bpf: clarify description for CONFIG_BPF_EVENTS

 include/uapi/linux/bpf.h       | 6 +++---
 kernel/trace/Kconfig           | 3 ++-
 tools/include/uapi/linux/bpf.h | 6 +++---
 3 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.22.0

