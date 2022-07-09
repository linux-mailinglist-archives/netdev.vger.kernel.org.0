Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E83256C8C7
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiGIKHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 06:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGIKHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 06:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509CF4B4B8;
        Sat,  9 Jul 2022 03:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E898E60E84;
        Sat,  9 Jul 2022 10:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAE2C341C7;
        Sat,  9 Jul 2022 10:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657361259;
        bh=KJtmXylkYfBUCP9nKw3ANSOdLovVVTpFPXktiDmYhX8=;
        h=From:To:Cc:Subject:Date:From;
        b=LnWbmh+eLrmzEUuOUtwt1Zk7RPhAHxviv/xN1zz17DDCm7ZZ2jcjIeAUW4KTxMXed
         KM6hlnyvwgcE/ucoKBLNi3lTI0HLQorkZBQKDriJ83QapG5TazYrBSO0s5jpBgI518
         zjHSfekRlLlgNoH4pC8Bvx7SWcUhuyyANeCxHX9hJfkXhijte2QxQFmBhEqOt4NAki
         WRxJiBGp9FbjYtPunI+ANm5ybjHbUrO7XEI2HfTHJrTDCbiOpxKJM0muKF/npo2L8i
         8btVRvA0c3zQa7eBwzLXG2Hotce3pbtGp96wKaC+VQwn/aYfgAwZb7CnJrfDBP08B6
         LAxmYYMrturXw==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oA7N9-004EGQ-BD;
        Sat, 09 Jul 2022 11:07:35 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Alex Shi <alexs@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marco Elver <elver@google.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Max Staudt <max@enpas.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Leach <mike.leach@linaro.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Yanteng Si <siyanteng@loongson.cn>, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-cachefs@redhat.com,
        linux-can@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linux-pci@vger.kernel.org,
        linux-sgx@vger.kernel.org, netdev@vger.kernel.org, x86@kernel.org
Subject: [PATCH v3 00/21] Update Documentation/ cross references and fix issues
Date:   Sat,  9 Jul 2022 11:07:13 +0100
Message-Id: <cover.1657360984.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fix almost all fixable issues when building the html docs at
linux-next (next-20220608):

- Address some broken cross-references;
- Fix kernel-doc warnings;
- Fix bad tags on ReST files.

With this series applied, plus other pending patches that should hopefully
be merged in time for the next merge window, htmldocs build will produce
just 4 warnings with Sphinx 2.4.4.

Sphinx >=3 will produce some extra false-positive warnings due to conflicts
between structs and functions sharing the same name. Hopefully this will
be fixed either on a new Sphinx 5.x version or Sphinx 6.0.

Mauro Carvalho Chehab (21):
  docs: networking: update netdevices.rst reference
  docs: update vmalloced-kernel-stacks.rst reference
  docs: update vmemmap_dedup.rst reference
  docs: zh_CN: page_migration: fix reference to mm index.rst
  dt-bindings: arm: update arm,coresight-cpu-debug.yaml reference
  x86/sgx: fix kernel-doc markups
  fscache: fix kernel-doc documentation
  fs: namei: address some kernel-doc issues
  drm/scheduler: fix a kernel-doc warning
  drm/scheduler: add a missing kernel-doc parameter
  kfence: fix a kernel-doc parameter
  genalloc: add a description for start_addr parameter
  textsearch: document list inside struct ts_ops
  dcache: fix a kernel-doc warning
  docs: ext4: blockmap.rst: fix a broken table
  docs: PCI: pci-vntb-function.rst: Properly include ascii artwork
  docs: PCI: pci-vntb-howto.rst: fix a title markup
  docs: virt: kvm: fix a title markup at api.rst
  docs: ABI: sysfs-bus-nvdimm
  docs: leds: index.rst: add leds-qcom-lpg to it
  Documentation: coresight: fix binding wildcards

 Documentation/ABI/testing/sysfs-bus-nvdimm             |  2 ++
 Documentation/PCI/endpoint/pci-vntb-function.rst       |  2 +-
 Documentation/PCI/endpoint/pci-vntb-howto.rst          |  2 +-
 Documentation/filesystems/ext4/blockmap.rst            |  2 +-
 Documentation/leds/index.rst                           |  1 +
 Documentation/trace/coresight/coresight-cpu-debug.rst  |  2 +-
 Documentation/trace/coresight/coresight.rst            |  2 +-
 Documentation/translations/zh_CN/mm/page_migration.rst |  2 +-
 .../translations/zh_CN/mm/vmalloced-kernel-stacks.rst  |  2 +-
 Documentation/virt/kvm/api.rst                         |  6 +++---
 arch/x86/include/uapi/asm/sgx.h                        | 10 ++++++++--
 drivers/gpu/drm/scheduler/sched_main.c                 |  1 +
 drivers/net/can/can327.c                               |  2 +-
 fs/namei.c                                             |  3 +++
 include/drm/gpu_scheduler.h                            |  1 +
 include/linux/dcache.h                                 |  2 +-
 include/linux/fscache.h                                |  4 ++--
 include/linux/genalloc.h                               |  1 +
 include/linux/kfence.h                                 |  1 +
 include/linux/textsearch.h                             |  1 +
 mm/hugetlb_vmemmap.h                                   |  2 +-
 21 files changed, 34 insertions(+), 17 deletions(-)

-- 
2.36.1


