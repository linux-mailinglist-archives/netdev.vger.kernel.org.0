Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800B3124C27
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLRPuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:50:08 -0500
Received: from condef-07.nifty.com ([202.248.20.72]:46552 "EHLO
        condef-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRPuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:50:08 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 10:50:05 EST
Received: from conuserg-12.nifty.com ([10.126.8.75])by condef-07.nifty.com with ESMTP id xBIFaQbL007955;
        Thu, 19 Dec 2019 00:36:27 +0900
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id xBIFYQjU027260;
        Thu, 19 Dec 2019 00:34:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com xBIFYQjU027260
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1576683268;
        bh=nW7i6JukRHFe3PcDkfjmOEE2/tltKikdJpXFBt0kjIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ2sSRa2vjNArYeZoa9wlOt3KiXnHxEwzOrKYMm8Fzd8qnEfMi9LE0F6f0UQXfMWy
         +1MAEGg/q/NYi0mVi3OL8Qi1CLHpzFu4HlKuKIA3ayO4EXRzwfVzQy2jxg7T1VMRhS
         r9aP8pjqolHJjQqtjYuWBh+UQETYrhBL8a5V9brA9LnOAsOuT3DRKHMfp5ZZZZt1qB
         FkA0drXjGZKp8Q+NAec9N8cBzH9fJS2UTM7qp3ANi/XZLPj+p3ODM/ogxP/XZT6H8w
         TAimIcH+eZ9DOlV8S3hFRrZjK3b8zewT2sk2HZ/pjRgJmk/fYs64sJsEhmQpKoeFzd
         eqMJb0M2yHs7w==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] kbuild: rename header-test- to no-header-test in usr/include/Makefile
Date:   Thu, 19 Dec 2019 00:34:22 +0900
Message-Id: <20191218153422.14557-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218153422.14557-1-masahiroy@kernel.org>
References: <20191218153422.14557-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit d2a99dbdade4 ("kbuild: update compile-test header list for
v5.5-rc1"), this does not depend on any CONFIG option.

no-header-test is clearer.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 usr/include/Makefile | 106 +++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/usr/include/Makefile b/usr/include/Makefile
index e90f5f7903bb..a339ef325aa5 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -16,80 +16,80 @@ override c_flags = $(UAPI_CFLAGS) -Wp,-MD,$(depfile) -I$(objtree)/usr/include
 # Please consider to fix the header first.
 #
 # Sorted alphabetically.
-header-test- += asm/shmbuf.h
-header-test- += asm/signal.h
-header-test- += asm/ucontext.h
-header-test- += drm/vmwgfx_drm.h
-header-test- += linux/am437x-vpfe.h
-header-test- += linux/android/binder.h
-header-test- += linux/android/binderfs.h
-header-test- += linux/coda.h
-header-test- += linux/elfcore.h
-header-test- += linux/errqueue.h
-header-test- += linux/fsmap.h
-header-test- += linux/hdlc/ioctl.h
-header-test- += linux/ivtv.h
-header-test- += linux/kexec.h
-header-test- += linux/matroxfb.h
-header-test- += linux/nfc.h
-header-test- += linux/omap3isp.h
-header-test- += linux/omapfb.h
-header-test- += linux/patchkey.h
-header-test- += linux/phonet.h
-header-test- += linux/reiserfs_xattr.h
-header-test- += linux/sctp.h
-header-test- += linux/signal.h
-header-test- += linux/sysctl.h
-header-test- += linux/usb/audio.h
-header-test- += linux/v4l2-mediabus.h
-header-test- += linux/v4l2-subdev.h
-header-test- += linux/videodev2.h
-header-test- += linux/vm_sockets.h
-header-test- += sound/asequencer.h
-header-test- += sound/asoc.h
-header-test- += sound/asound.h
-header-test- += sound/compress_offload.h
-header-test- += sound/emu10k1.h
-header-test- += sound/sfnt_info.h
-header-test- += xen/evtchn.h
-header-test- += xen/gntdev.h
-header-test- += xen/privcmd.h
+no-header-test += asm/shmbuf.h
+no-header-test += asm/signal.h
+no-header-test += asm/ucontext.h
+no-header-test += drm/vmwgfx_drm.h
+no-header-test += linux/am437x-vpfe.h
+no-header-test += linux/android/binder.h
+no-header-test += linux/android/binderfs.h
+no-header-test += linux/coda.h
+no-header-test += linux/elfcore.h
+no-header-test += linux/errqueue.h
+no-header-test += linux/fsmap.h
+no-header-test += linux/hdlc/ioctl.h
+no-header-test += linux/ivtv.h
+no-header-test += linux/kexec.h
+no-header-test += linux/matroxfb.h
+no-header-test += linux/nfc.h
+no-header-test += linux/omap3isp.h
+no-header-test += linux/omapfb.h
+no-header-test += linux/patchkey.h
+no-header-test += linux/phonet.h
+no-header-test += linux/reiserfs_xattr.h
+no-header-test += linux/sctp.h
+no-header-test += linux/signal.h
+no-header-test += linux/sysctl.h
+no-header-test += linux/usb/audio.h
+no-header-test += linux/v4l2-mediabus.h
+no-header-test += linux/v4l2-subdev.h
+no-header-test += linux/videodev2.h
+no-header-test += linux/vm_sockets.h
+no-header-test += sound/asequencer.h
+no-header-test += sound/asoc.h
+no-header-test += sound/asound.h
+no-header-test += sound/compress_offload.h
+no-header-test += sound/emu10k1.h
+no-header-test += sound/sfnt_info.h
+no-header-test += xen/evtchn.h
+no-header-test += xen/gntdev.h
+no-header-test += xen/privcmd.h
 
 # More headers are broken in some architectures
 
 ifeq ($(SRCARCH),arc)
-header-test- += linux/bpf_perf_event.h
+no-header-test += linux/bpf_perf_event.h
 endif
 
 ifeq ($(SRCARCH),ia64)
-header-test- += asm/setup.h
-header-test- += asm/sigcontext.h
-header-test- += asm/perfmon.h
-header-test- += asm/perfmon_default_smpl.h
-header-test- += linux/if_bonding.h
+no-header-test += asm/setup.h
+no-header-test += asm/sigcontext.h
+no-header-test += asm/perfmon.h
+no-header-test += asm/perfmon_default_smpl.h
+no-header-test += linux/if_bonding.h
 endif
 
 ifeq ($(SRCARCH),mips)
-header-test- += asm/stat.h
+no-header-test += asm/stat.h
 endif
 
 ifeq ($(SRCARCH),powerpc)
-header-test- += asm/stat.h
-header-test- += linux/bpf_perf_event.h
+no-header-test += asm/stat.h
+no-header-test += linux/bpf_perf_event.h
 endif
 
 ifeq ($(SRCARCH),riscv)
-header-test- += linux/bpf_perf_event.h
+no-header-test += linux/bpf_perf_event.h
 endif
 
 ifeq ($(SRCARCH),sparc)
-header-test- += asm/stat.h
-header-test- += asm/uctx.h
-header-test- += asm/fbio.h
+no-header-test += asm/stat.h
+no-header-test += asm/uctx.h
+no-header-test += asm/fbio.h
 endif
 
 # asm-generic/*.h is used by asm/*.h, and should not be included directly
-header-test- += asm-generic/%
+no-header-test += asm-generic/%
 
 extra-y := $(patsubst $(obj)/%.h,%.hdrtest, $(shell find $(obj) -name '*.h' 2>/dev/null))
 
@@ -97,7 +97,7 @@ extra-y := $(patsubst $(obj)/%.h,%.hdrtest, $(shell find $(obj) -name '*.h' 2>/d
 quiet_cmd_hdrtest = HDRTEST $<
       cmd_hdrtest = \
 		$(CC) $(c_flags) -S -o /dev/null -x c /dev/null \
-			$(if $(filter-out $(header-test-), $*.h), -include $< -include $<); \
+			$(if $(filter-out $(no-header-test), $*.h), -include $< -include $<); \
 		$(PERL) $(srctree)/scripts/headers_check.pl $(obj) $(SRCARCH) $<; \
 		touch $@
 
-- 
2.17.1

