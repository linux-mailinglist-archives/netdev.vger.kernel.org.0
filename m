Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D917A56A0F6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiGGLQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiGGLQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:16:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A940C2C11C;
        Thu,  7 Jul 2022 04:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657192587; x=1688728587;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zmi1tG5A3DfxdI7+UpDcTPKfeu/7/g4OyJ7Ae5ZGFuU=;
  b=gO2pTlANwY7owLn4qf44uW0FsA7KxMgV+3ev32OctJxYI3ycy3hqvLa7
   AF998Xyr4zdUQvt+yOEXtk7NjjlTjCtlpltIXkM64LiIlkcZMM9vigd99
   VCYoRaESlf30/vrZvsuwK2LCeVQ/RiwsbwDWv01qMC64fIafo9f6T+8K5
   YaaKwMHh0xSo2DOy0/j/7iu2sTF9rLMfghWRncNnDtJ65WYhxdn+/zqDV
   JvawJfkiYR1yE3MSa+EGMwgPoLzDkg3BIbJKdGV/0/4NpftWAq1Qb+lVd
   UWekd4W+UWEZqoAOcKthmuskyaqL8qyTMuTqUXco1r+r0C4NaHjsdkhbM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="309556174"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="309556174"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 04:16:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="543788223"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 07 Jul 2022 04:16:16 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/2] xsk: cover AF_XDP test app in MAINTAINERS
Date:   Thu,  7 Jul 2022 13:16:11 +0200
Message-Id: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAINTAINERS needs adjustment after file moves/deletions.
First commit does s/xdpxceiver/xskxceiver while second adjust the
MAINTAINERS.

Thanks,
Maciej

Maciej Fijalkowski (2):
  selftests: xsk: rename AF_XDP testing app
  MAINTAINERS: add entry for AF_XDP selftests files

 MAINTAINERS                                                | 1 +
 tools/testing/selftests/bpf/.gitignore                     | 2 +-
 tools/testing/selftests/bpf/Makefile                       | 4 ++--
 tools/testing/selftests/bpf/test_xsk.sh                    | 6 +++---
 tools/testing/selftests/bpf/xsk_prereqs.sh                 | 4 ++--
 tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} | 4 ++--
 tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} | 6 +++---
 7 files changed, 14 insertions(+), 13 deletions(-)
 rename tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} (99%)
 rename tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} (98%)

-- 
2.27.0

