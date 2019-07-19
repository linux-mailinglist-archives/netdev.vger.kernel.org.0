Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A996E76D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfGSOeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 10:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbfGSOeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 10:34:20 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8936120873;
        Fri, 19 Jul 2019 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563546860;
        bh=tPjDSWbg+gh4E6JTk+VjmFG/HZmbcKxjGtHOPOqQZbE=;
        h=From:To:Cc:Subject:Date:From;
        b=GUuxD+ojrcH47bblQleT6Tfm88nHUidz46c+sJc9wArewT/KRILFvuduM4ZFpE8ko
         Prn5jSkp0s0VOz7axfCm+K6Td9FDqwpnM5gkRXmWl27cc2IKqhM9FUY7M40Pd9+Qtc
         f8Fj0bAzMfKaX0lqkcbpXhYFT94GRAGdD0AGmVzI=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [GIT PULL 0/2] libbpf build fixes
Date:   Fri, 19 Jul 2019 11:34:05 -0300
Message-Id: <20190719143407.20847-1-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

	Please consider pulling or applying from the patches, if someone
has any issues, please holler,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  libbpf: Fix endianness macro usage for some compilers
  libbpf: Avoid designated initializers for unnamed union members

 tools/lib/bpf/btf.c    |  5 +++--
 tools/lib/bpf/libbpf.c | 19 ++++++++++---------
 2 files changed, 13 insertions(+), 11 deletions(-)

-- 
2.21.0

The following changes since commit 9b3d15e6b05e0b916be5fbd915f90300a403098b:

  bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips. (2019-07-18 16:33:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git libbpf

for you to fetch changes up to 5443fc23eb80e7cd03f9111fb16fb9aaa76fedc9:

  libbpf: Avoid designated initializers for unnamed union members (2019-07-19 11:21:33 -0300)

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      libbpf: Fix endianness macro usage for some compilers
      libbpf: Avoid designated initializers for unnamed union members

 tools/lib/bpf/btf.c    |  5 +++--
 tools/lib/bpf/libbpf.c | 19 ++++++++++---------
 2 files changed, 13 insertions(+), 11 deletions(-)
