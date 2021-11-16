Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7B453623
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhKPPop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238589AbhKPPn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF3060EE0;
        Tue, 16 Nov 2021 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637077231;
        bh=WY/fUvla4+0dT7GcjonjtIDUlsJcA57S5H7vggmT+kU=;
        h=Date:From:To:Cc:Subject:From;
        b=J6vWPMBWMZeNZxf8d+irHVTWDSiw0teGb1/RSLkjrm0X+/E0xhT3/2GZySvtA1gcx
         298t+B/Hzzx4eMJCr15pP58ABg7nMXyZH1qWHEwL3HLfozxhk42sfKvRkep2WZoBj+
         SeZ9eCHTZi0c2t7A9dZakPeuWbgj8M5Y2Z3io79tkDO6XcsLgQCN4kQFIwOJDzBEtG
         DACdVKypsjOtfCgpHE4qMHyNf6b//tax9j3U5r96LgQr9evIEm0/pj/oa69vG7U3hw
         npY8FKVx74hb63gp5vn++JSDwusd0n/hbvgY6DBjWQqHqLPuS8kR9uEFQxupC4Sk+X
         jYyZBA4sVDTrw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C644E4088E; Tue, 16 Nov 2021 12:40:27 -0300 (-03)
Date:   Tue, 16 Nov 2021 12:40:27 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] Documentation: Add minimum pahole version
Message-ID: <YZPQ6+u2wTHRfR+W@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A report was made in https://github.com/acmel/dwarves/issues/26 about
pahole not being listed in the process/changes.rst file as being needed
for building the kernel, address that.

Link: https://github.com/acmel/dwarves/issues/26
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/process/changes.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index e35ab74a0f804b04..c45f167a1b6c02a4 100644
--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -35,6 +35,7 @@ GNU make               3.81             make --version
 binutils               2.23             ld -v
 flex                   2.5.35           flex --version
 bison                  2.0              bison --version
+pahole                 1.16             pahole --version
 util-linux             2.10o            fdformat --version
 kmod                   13               depmod -V
 e2fsprogs              1.41.4           e2fsck -V
@@ -108,6 +109,14 @@ Bison
 Since Linux 4.16, the build system generates parsers
 during build.  This requires bison 2.0 or later.
 
+pahole:
+-------
+
+Since Linux 5.2 the build system generates BTF (BPF Type Format) from DWARF in
+vmlinux, a bit later from kernel modules as well, if CONFIG_DEBUG_INFO_BTF is
+selected.  This requires pahole v1.16 or later. It is found in the 'dwarves' or
+'pahole' distro packages or from https://fedorapeople.org/~acme/dwarves/.
+
 Perl
 ----
 
-- 
2.31.1

