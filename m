Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3D92F5C17
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbhANIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:06:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbhANIGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 03:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD9323A58;
        Thu, 14 Jan 2021 08:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610611500;
        bh=KzRA72DJ8FelN5FRPnISDXzhJWHYX6V5D7cnrrYqmns=;
        h=From:To:Cc:Subject:Date:From;
        b=nOm4NqCaUWLg4HTBDeJeoBxDK1hE6KD6kwIaS5QUdGE5d95M0LOuBe17UH6ZhtxWj
         2SIokKCq5OrWbc/QTRPFACCsP/28F9IHn5ydVSMGUJC9s2jP+tMN80H9tSZ77bm3FC
         VuJGlQICCzi4qz/Gjt5ZVImWz1CaQcpPOemSSW2UY1plhyCBX0ffc8ZreB8SYwreWG
         a2Wjqa/k8fmoxGbUlaKINA7quVFVGZDOIEdybff/MtPHwEQKCte3px4suSSxEJzxPs
         ZezS17i65C2hxskblSDd8TCCCI/NNP1qdJmjaooHey/QEueJfY+BWtlFyEGbMsiuzC
         o3DjiUV3zELfQ==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kzxcn-00EQ6N-K6; Thu, 14 Jan 2021 09:04:57 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Richard Gong <richard.gong@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Will Drewry <wad@chromium.org>,
        Ying Xue <ying.xue@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH v6 00/16] Fix several bad kernel-doc markups
Date:   Thu, 14 Jan 2021 09:04:36 +0100
Message-Id: <cover.1610610937.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

This series have three parts:

1)  10 remaining fixup patches from the series I sent back on Dec, 1st:

   parport: fix a kernel-doc markup
   rapidio: fix kernel-doc a markup
   fs: fix kernel-doc markups
   pstore/zone: fix a kernel-doc markup
   firmware: stratix10-svc: fix kernel-doc markups
   connector: fix a kernel-doc markup
   lib/crc7: fix a kernel-doc markup
   memblock: fix kernel-doc markups
   w1: fix a kernel-doc markup
   selftests: kselftest_harness.h: partially fix kernel-doc markups

2) The patch adding the new check to ensure that the kernel-doc
   markup will be used for the right declaration;

3) 5 additional patches, produced against next-20210114 with new
   problems detected after the original series: 

 net: tip: fix a couple kernel-doc markups
 net: cfg80211: fix a kerneldoc markup
 reset: core: fix a kernel-doc markup
 drm: drm_crc: fix a kernel-doc markup
 platform/surface: aggregator: fix a kernel-doc markup

It probably makes sense to merge at least the first 11 patches
via the doc tree, as they should apply cleanly there, and
having the last 5 patches merged via each maintainer's tree.

-

Kernel-doc has always be limited to a probably bad documented
rule:

The kernel-doc markups should appear *imediatelly before* the
function or data structure that it documents.

On other words, if a C file would contain something like this:

	/**
	 * foo - function foo
	 * @args: foo args
	 */
	static inline void bar(int args);

	/**
	 * bar - function bar
	 * @args: foo args
	 */
	static inline void foo(void *args);


The output (in ReST format) will be:

	.. c:function:: void bar (int args)

	   function foo

	**Parameters**

	``int args``
	  foo args


	.. c:function:: void foo (void *args)

	   function bar

	**Parameters**

	``void *args``
	  foo args

Which is clearly a wrong result.  Before this changeset, 
not even a warning is produced on such cases.

As placing such markups just before the documented
data is a common practice, on most cases this is fine.

However, as patches touch things, identifiers may be
renamed, and people may forget to update the kernel-doc
markups to follow such changes.

This has been happening for quite a while, as there are
lots of files with kernel-doc problems.

This series address those issues and add a file at the
end that will enforce that the identifier will match the
kernel-doc markup, avoiding this problem from
keep happening as time goes by.

This series is based on current upstream tree.

@maintainers: feel free to pick the patches and
apply them directly on your trees, as all patches on 
this series are independent from the other ones.

--

v6:
  - rebased on the top of next-20210114 and added a few extra fixes

v5:
  - The completion.h patch was replaced by another one which drops
    an obsolete macro;
  - Some typos got fixed and review tags got added;
  - Dropped patches that were already merged at linux-next.

v4:

  - Patches got rebased and got some acks.

Mauro Carvalho Chehab (16):
  parport: fix a kernel-doc markup
  rapidio: fix kernel-doc a markup
  fs: fix kernel-doc markups
  pstore/zone: fix a kernel-doc markup
  firmware: stratix10-svc: fix kernel-doc markups
  connector: fix a kernel-doc markup
  lib/crc7: fix a kernel-doc markup
  memblock: fix kernel-doc markups
  w1: fix a kernel-doc markup
  selftests: kselftest_harness.h: partially fix kernel-doc markups
  scripts: kernel-doc: validate kernel-doc markup with the actual names
  net: tip: fix a couple kernel-doc markups
  net: cfg80211: fix a kerneldoc markup
  reset: core: fix a kernel-doc markup
  drm: drm_crc: fix a kernel-doc markup
  platform/surface: aggregator: fix a kernel-doc markup

 drivers/parport/share.c                       |  2 +-
 .../surface/aggregator/ssh_request_layer.c    |  2 +-
 drivers/rapidio/rio.c                         |  2 +-
 drivers/reset/core.c                          |  4 +-
 fs/dcache.c                                   | 73 ++++++++++---------
 fs/inode.c                                    |  4 +-
 fs/pstore/zone.c                              |  2 +-
 fs/seq_file.c                                 |  5 +-
 fs/super.c                                    | 12 +--
 include/drm/drm_crtc.h                        |  2 +-
 include/linux/connector.h                     |  2 +-
 .../firmware/intel/stratix10-svc-client.h     | 10 +--
 include/linux/memblock.h                      |  4 +-
 include/linux/parport.h                       | 31 ++++++++
 include/linux/w1.h                            |  2 +-
 include/net/cfg80211.h                        |  2 +-
 lib/crc7.c                                    |  2 +-
 net/tipc/link.c                               |  2 +-
 net/tipc/node.c                               |  2 +-
 scripts/kernel-doc                            | 62 ++++++++++++----
 tools/testing/selftests/kselftest_harness.h   | 26 ++++---
 21 files changed, 160 insertions(+), 93 deletions(-)

-- 
2.29.2


