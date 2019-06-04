Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658E334A08
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfFDOSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:18:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfFDOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5pILMQXKeyLYh5ydaNJLoPQY2CsjJ232NGCECQ6ieOU=; b=QLUJW3Xy70Q2w9OUNVuRZY0o4
        yWEYAcj9wsEw/WCH3Ev2mmzFxcX3nSL4HEiIv6hp/loWiN4uF7rzQIqHqcU7ri65t0K8wXd2HAu32
        2qao64KVRLpHeaks4KHMJG0MEhxr4/9evrll3GcDcTV8HO/nsABvymJIdTvw0UDffzz0uUe/RWTxq
        ZK/VHAgrMxMZA/7JVdt8Xq59mnyk5F8VKB64zj6NS8ZVedxbkIR1tg3EaCh7nTghyuOfPODuStkaL
        BMYE86ezcmk7k/DZmlS1YAx9pXLecloginxyygBPabhwPbkn78TFuiL2uXY5h2thVba5HWy/RmD7c
        bFRQzyRtQ==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Rn-U6; Tue, 04 Jun 2019 14:18:02 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002kc-G7; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 00/22] Some documentation fixes
Date:   Tue,  4 Jun 2019 11:17:34 -0300
Message-Id: <cover.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fix several warnings and broken links.

This series was generated against linux-next, but was rebased to be applied at
docs-next. It should apply cleanly on either tree.

There's a git tree with all of them applied on the top of docs/docs-next
at:

https://git.linuxtv.org/mchehab/experimental.git/log/?h=fix_doc_links_v2

-

v2:

- added received acks/reviewed-by tags
- removed patches that got merged at linux-next
- Removed it_IT patches, as a different version was already submitted;
- removed mfd: madera: patch, assuming that it will be merged via
  some other tree;
- Removed the :orphan:  markups for KVM patches, as those are fixed
  at -next;
- zh_CN: use a different approach to fix duplicate references;
- added a patch moving protection-keys.rst to the core-api book;
- added 3 patches fixing new broken stuff:

	docs: isdn: remove hisax references from kernel-parameters.txt
	dt: bindings: fix some broken links from txt->yaml conversion
	docs: fix broken documentation links


Mauro Carvalho Chehab (22):
  ABI: sysfs-devices-system-cpu: point to the right docs
  isdn: mISDN: remove a bogus reference to a non-existing doc
  docs: zh_CN: get rid of basic_profiling.txt
  docs: mm: numaperf.rst: get rid of a build warning
  docs: bpf: get rid of two warnings
  docs: mark orphan documents as such
  docs: amd-memory-encryption.rst get rid of warnings
  gpu: i915.rst: Fix references to renamed files
  docs: zh_CN: avoid duplicate citation references
  docs: vm: hmm.rst: fix some warnings
  docs: it: license-rules.rst: get rid of warnings
  docs: gpio: driver.rst: fix a bad tag
  docs: soundwire: locking: fix tags for a code-block
  docs: security: trusted-encrypted.rst: fix code-block tag
  docs: security: core.rst: Fix several warnings
  docs: net: dpio-driver.rst: fix two codeblock warnings
  docs: net: sja1105.rst: fix table format
  docs: move protection-keys.rst to the core-api book
  docs: fix broken documentation links
  dt: bindings: fix some broken links from txt->yaml conversion
  docs: isdn: remove hisax references from kernel-parameters.txt
  docs: Kbuild/Makefile: allow check for missing docs at build time

 .../ABI/testing/sysfs-devices-system-cpu      |  3 +-
 Documentation/Kconfig                         | 13 ++++
 Documentation/Makefile                        |  5 ++
 Documentation/accelerators/ocxl.rst           |  2 +
 Documentation/acpi/dsd/leds.txt               |  2 +-
 .../admin-guide/kernel-parameters.rst         |  6 +-
 .../admin-guide/kernel-parameters.txt         | 19 +++--
 Documentation/admin-guide/mm/numaperf.rst     |  5 +-
 Documentation/admin-guide/ras.rst             |  2 +-
 Documentation/arm/stm32/overview.rst          |  2 +
 .../arm/stm32/stm32f429-overview.rst          |  2 +
 .../arm/stm32/stm32f746-overview.rst          |  2 +
 .../arm/stm32/stm32f769-overview.rst          |  2 +
 .../arm/stm32/stm32h743-overview.rst          |  2 +
 .../arm/stm32/stm32mp157-overview.rst         |  2 +
 Documentation/bpf/btf.rst                     |  2 +
 Documentation/core-api/index.rst              |  1 +
 .../{x86 => core-api}/protection-keys.rst     |  0
 .../bindings/media/st,stm32-dcmi.txt          |  2 +-
 .../devicetree/bindings/net/fsl-enetc.txt     |  7 +-
 .../bindings/pci/amlogic,meson-pcie.txt       |  2 +-
 .../regulator/qcom,rpmh-regulator.txt         |  2 +-
 .../bindings/sound/st,stm32-i2s.txt           |  2 +-
 .../bindings/sound/st,stm32-sai.txt           |  2 +-
 .../devicetree/booting-without-of.txt         |  2 +-
 Documentation/driver-api/gpio/board.rst       |  2 +-
 Documentation/driver-api/gpio/consumer.rst    |  2 +-
 Documentation/driver-api/gpio/driver.rst      |  2 +-
 .../driver-api/soundwire/locking.rst          |  4 +-
 .../firmware-guide/acpi/enumeration.rst       |  2 +-
 .../firmware-guide/acpi/method-tracing.rst    |  2 +-
 Documentation/gpu/i915.rst                    |  6 +-
 Documentation/gpu/msm-crash-dump.rst          |  2 +
 Documentation/i2c/instantiating-devices       |  2 +-
 Documentation/interconnect/interconnect.rst   |  2 +
 Documentation/laptops/lg-laptop.rst           |  2 +
 .../freescale/dpaa2/dpio-driver.rst           |  4 +-
 Documentation/networking/dsa/sja1105.rst      |  6 +-
 Documentation/powerpc/isa-versions.rst        |  2 +
 Documentation/security/keys/core.rst          | 16 +++--
 .../security/keys/trusted-encrypted.rst       |  4 +-
 Documentation/sysctl/kernel.txt               |  4 +-
 .../it_IT/process/license-rules.rst           | 28 ++++----
 .../translations/zh_CN/basic_profiling.txt    | 71 -------------------
 .../translations/zh_CN/process/4.Coding.rst   |  2 +-
 .../zh_CN/process/management-style.rst        |  4 +-
 .../zh_CN/process/programming-language.rst    | 59 +++++++++++----
 .../virtual/kvm/amd-memory-encryption.rst     |  3 +
 Documentation/vm/hmm.rst                      |  3 +-
 Documentation/x86/index.rst                   |  1 -
 Documentation/x86/x86_64/5level-paging.rst    |  2 +-
 Documentation/x86/x86_64/boot-options.rst     |  4 +-
 .../x86/x86_64/fake-numa-for-cpusets.rst      |  2 +-
 Kconfig                                       |  2 +
 MAINTAINERS                                   |  6 +-
 arch/arm/Kconfig                              |  2 +-
 arch/arm64/kernel/kexec_image.c               |  2 +-
 arch/powerpc/Kconfig                          |  2 +-
 arch/x86/Kconfig                              | 16 ++---
 arch/x86/Kconfig.debug                        |  2 +-
 arch/x86/boot/header.S                        |  2 +-
 arch/x86/entry/entry_64.S                     |  2 +-
 arch/x86/include/asm/bootparam_utils.h        |  2 +-
 arch/x86/include/asm/page_64_types.h          |  2 +-
 arch/x86/include/asm/pgtable_64_types.h       |  2 +-
 arch/x86/kernel/cpu/microcode/amd.c           |  2 +-
 arch/x86/kernel/kexec-bzimage64.c             |  2 +-
 arch/x86/kernel/pci-dma.c                     |  2 +-
 arch/x86/mm/tlb.c                             |  2 +-
 arch/x86/platform/pvh/enlighten.c             |  2 +-
 drivers/acpi/Kconfig                          | 10 +--
 drivers/isdn/mISDN/dsp_core.c                 |  2 -
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 .../fieldbus/Documentation/fieldbus_dev.txt   |  4 +-
 drivers/vhost/vhost.c                         |  2 +-
 include/acpi/acpi_drivers.h                   |  2 +-
 include/linux/fs_context.h                    |  2 +-
 include/linux/lsm_hooks.h                     |  2 +-
 mm/Kconfig                                    |  2 +-
 scripts/documentation-file-ref-check          |  9 +++
 security/Kconfig                              |  2 +-
 tools/include/linux/err.h                     |  2 +-
 .../Documentation/stack-validation.txt        |  4 +-
 tools/testing/selftests/x86/protection_keys.c |  2 +-
 84 files changed, 227 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/Kconfig
 rename Documentation/{x86 => core-api}/protection-keys.rst (100%)
 delete mode 100644 Documentation/translations/zh_CN/basic_profiling.txt

-- 
2.21.0


