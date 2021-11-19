Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B714576CD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbhKSS7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhKSS7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:59:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB1F611C7;
        Fri, 19 Nov 2021 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637348166;
        bh=bk3bOl+JxohpimwyPU9xloHokPYDmepyPhm6tU/gNb4=;
        h=Date:From:To:Cc:Subject:From;
        b=DrbJhRHVMUiX9JG6tIrPcd9ay9wD46wpv2yeA64bKZd8Sd5pz9KstuOFbSBzjx7C5
         XVbKruAI7DhcxuZXEhTFy21quDNHkC2X4R6CPBRuV4nKVMfz3E9yhmpMMotJiePPbm
         Ib+Y0+i4318LXp2N4sGohL6NyRW7hkuRNsLZIXk4A31+w9I5zH8UxECBOe8ny/LjZk
         NNnQFWViAs/j9anoNkVmEDX6gZnD5bowBONFJwqfELNGykREvtbeyPkk6wtYIswYQY
         KaL0idG8IVo2Vk4aIzLW8jxZW5sHViMiesa4+9Bc6/XB/lCtiXPFlzCt/HZdqz9wnY
         EED4iDftf+zXg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1273B40002; Fri, 19 Nov 2021 15:56:03 -0300 (-03)
Date:   Fri, 19 Nov 2021 15:56:03 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 v2] Documentation: Add minimum pahole version
Message-ID: <YZfzQ0DvHD5o26Bt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A report was made in https://github.com/acmel/dwarves/issues/26 about
pahole not being listed in the process/changes.rst file as being needed
for building the kernel, address that.

Link: https://github.com/acmel/dwarves/issues/26
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/YZPQ6+u2wTHRfR+W@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/process/changes.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index e35ab74a0f804b04..572465db0db19e8f 100644
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
@@ -108,6 +109,16 @@ Bison
 Since Linux 4.16, the build system generates parsers
 during build.  This requires bison 2.0 or later.
 
+pahole:
+-------
+
+Since Linux 5.2, if CONFIG_DEBUG_INFO_BTF is selected, the build system
+generates BTF (BPF Type Format) from DWARF in vmlinux, a bit later from kernel
+modules as well.  This requires pahole v1.16 or later.
+
+It is found in the 'dwarves' or 'pahole' distro packages or from
+https://fedorapeople.org/~acme/dwarves/.
+
 Perl
 ----
 
-- 
2.31.1

