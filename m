Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C767B3F8017
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhHZBzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:55:20 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41401 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236054AbhHZBzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:55:19 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3APcJ9O6EuGuDjaXxapLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.84,352,1620662400"; 
   d="scan'208";a="113479370"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Aug 2021 09:54:25 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id DDD494D0D9D5;
        Thu, 26 Aug 2021 09:54:24 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 26 Aug 2021 09:54:21 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 26 Aug 2021 09:54:19 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 26 Aug 2021 09:54:17 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>
CC:     <philip.li@intel.com>, <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        kernel test robot <lkp@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        <wireguard@lists.zx2c4.com>, <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v2 0/3] kselftests: clean configs
Date:   Thu, 26 Aug 2021 09:58:44 +0800
Message-ID: <20210826015847.7416-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: DDD494D0D9D5.A2F2B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0Day will check if all configs listing under selftests are able to be enabled properly.

For the missing configs, it will report something like:
LKP WARN miss config CONFIG_SYNC= of sync/config

CC: kernel test robot <lkp@intel.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>
CC: Nick Desaulniers <ndesaulniers@google.com>
CC: Masahiro Yamada <masahiroy@kernel.org>
CC: wireguard@lists.zx2c4.com
CC: netdev@vger.kernel.org

CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>
CC: linux-pm@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>

Li Zhijian (3):
  selftests/sync: Remove the deprecated config SYNC
  selftests/cpufreq: Rename DEBUG_PI_LIST to DEBUG_PLIST
  selftests/wireguard: Rename DEBUG_PI_LIST to DEBUG_PLIST

 tools/testing/selftests/cpufreq/config              | 2 +-
 tools/testing/selftests/sync/config                 | 1 -
 tools/testing/selftests/wireguard/qemu/debug.config | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.31.1



