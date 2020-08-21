Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4374324CD44
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 07:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgHUF22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 01:28:28 -0400
Received: from foss.arm.com ([217.140.110.172]:54176 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUF22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 01:28:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFE8F31B;
        Thu, 20 Aug 2020 22:28:26 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A42E63F6CF;
        Thu, 20 Aug 2020 22:28:23 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Song.Zhu@arm.com,
        Jianlin.Lv@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next] docs: correct subject prefix and update LLVM info
Date:   Fri, 21 Aug 2020 13:28:17 +0800
Message-Id: <20200821052817.46887-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_devel_QA.rst:152 The subject prefix information is not accurate, it
should be 'PATCH bpf-next v2'

Also update LLVM version info and add information about
‘-DLLVM_TARGETS_TO_BUILD’ to prompt the developer to build the desired
target.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 Documentation/bpf/bpf_devel_QA.rst | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index a26aa1b9b259..75a0dca5f295 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -149,7 +149,7 @@ In case the patch or patch series has to be reworked and sent out
 again in a second or later revision, it is also required to add a
 version number (``v2``, ``v3``, ...) into the subject prefix::
 
-  git format-patch --subject-prefix='PATCH net-next v2' start..finish
+  git format-patch --subject-prefix='PATCH bpf-next v2' start..finish
 
 When changes have been requested to the patch series, always send the
 whole patch series again with the feedback incorporated (never send
@@ -479,17 +479,18 @@ LLVM's static compiler lists the supported targets through
 
      $ llc --version
      LLVM (http://llvm.org/):
-       LLVM version 6.0.0svn
+       LLVM version 10.0.0
        Optimized build.
        Default target: x86_64-unknown-linux-gnu
        Host CPU: skylake
 
        Registered Targets:
-         bpf    - BPF (host endian)
-         bpfeb  - BPF (big endian)
-         bpfel  - BPF (little endian)
-         x86    - 32-bit X86: Pentium-Pro and above
-         x86-64 - 64-bit X86: EM64T and AMD64
+         aarch64    - AArch64 (little endian)
+         bpf        - BPF (host endian)
+         bpfeb      - BPF (big endian)
+         bpfel      - BPF (little endian)
+         x86        - 32-bit X86: Pentium-Pro and above
+         x86-64     - 64-bit X86: EM64T and AMD64
 
 For developers in order to utilize the latest features added to LLVM's
 BPF back end, it is advisable to run the latest LLVM releases. Support
@@ -517,6 +518,10 @@ from the git repositories::
 The built binaries can then be found in the build/bin/ directory, where
 you can point the PATH variable to.
 
+Set ``-DLLVM_TARGETS_TO_BUILD`` equal to the target you wish to build, you
+will find a full list of targets within the llvm-project/llvm/lib/Target
+directory.
+
 Q: Reporting LLVM BPF issues
 ----------------------------
 Q: Should I notify BPF kernel maintainers about issues in LLVM's BPF code
-- 
2.17.1

