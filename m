Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11F38862B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240487AbhESEw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:52:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3027 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhESEw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:52:28 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlL43322yzmWpj;
        Wed, 19 May 2021 12:48:51 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 12:51:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 12:51:06 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Steffen Klassert <klassert@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "Rasesh Mody" <rmody@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniele Venzano <venza@brownhat.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Shannon Nelson <snelson@pensando.io>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Lee Jones <lee.jones@linaro.org>,
        Weihang Li <liweihang@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jeremy Kerr" <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Lucy Yan <lucyyan@google.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Edward Cree <ecree@solarflare.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Zheng Yongjun" <zhengyongjun3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Andrew Lunn" <andrew@lunn.ch>, Wang Hai <wanghai38@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Allen Pais" <apais@linux.microsoft.com>,
        Qiushi Wu <wu000273@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Gaurav Singh" <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 00/20] net: ethernet: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:25 +0800
Message-ID: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

        $ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
        $ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Hui Tang (20):
  net: 3com: remove leading spaces before tabs
  net: alteon: remove leading spaces before tabs
  net: amd: remove leading spaces before tabs
  net: apple: remove leading spaces before tabs
  net: broadcom: remove leading spaces before tabs
  net: chelsio: remove leading spaces before tabs
  net: dec: remove leading spaces before tabs
  net: dlink: remove leading spaces before tabs
  net: ibm: remove leading spaces before tabs
  net: marvell: remove leading spaces before tabs
  net: natsemi: remove leading spaces before tabs
  net: realtek: remove leading spaces before tabs
  net: seeq: remove leading spaces before tabs
  net: sis: remove leading spaces before tabs
  net: smsc: remove leading spaces before tabs
  net: sun: remove leading spaces before tabs
  net: fealnx: remove leading spaces before tabs
  net: xircom: remove leading spaces before tabs
  net: 8390: remove leading spaces before tabs
  net: fujitsu: remove leading spaces before tabs

 drivers/net/ethernet/3com/3c59x.c            |  2 +-
 drivers/net/ethernet/8390/axnet_cs.c         | 14 +++++-----
 drivers/net/ethernet/8390/pcnet_cs.c         |  2 +-
 drivers/net/ethernet/8390/smc-ultra.c        |  6 ++--
 drivers/net/ethernet/8390/stnic.c            |  2 +-
 drivers/net/ethernet/alteon/acenic.c         | 26 ++++++++---------
 drivers/net/ethernet/amd/amd8111e.c          |  4 +--
 drivers/net/ethernet/amd/amd8111e.h          |  6 ++--
 drivers/net/ethernet/amd/atarilance.c        |  2 +-
 drivers/net/ethernet/amd/declance.c          |  2 +-
 drivers/net/ethernet/amd/lance.c             |  4 +--
 drivers/net/ethernet/amd/ni65.c              | 12 ++++----
 drivers/net/ethernet/amd/nmclan_cs.c         | 12 ++++----
 drivers/net/ethernet/amd/sun3lance.c         | 12 ++++----
 drivers/net/ethernet/apple/bmac.c            | 30 ++++++++++----------
 drivers/net/ethernet/apple/mace.c            |  8 +++---
 drivers/net/ethernet/broadcom/b44.c          | 20 ++++++-------
 drivers/net/ethernet/broadcom/bnx2.c         |  6 ++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c     |  2 +-
 drivers/net/ethernet/dec/tulip/de2104x.c     |  4 +--
 drivers/net/ethernet/dec/tulip/de4x5.c       |  6 ++--
 drivers/net/ethernet/dec/tulip/dmfe.c        | 18 ++++++------
 drivers/net/ethernet/dec/tulip/pnic2.c       |  4 +--
 drivers/net/ethernet/dec/tulip/uli526x.c     | 10 +++----
 drivers/net/ethernet/dec/tulip/winbond-840.c |  4 +--
 drivers/net/ethernet/dlink/sundance.c        | 12 ++++----
 drivers/net/ethernet/fealnx.c                |  2 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c    |  6 ++--
 drivers/net/ethernet/ibm/emac/emac.h         |  2 +-
 drivers/net/ethernet/marvell/skge.h          |  2 +-
 drivers/net/ethernet/marvell/sky2.c          | 30 ++++++++++----------
 drivers/net/ethernet/marvell/sky2.h          |  8 +++---
 drivers/net/ethernet/natsemi/natsemi.c       |  6 ++--
 drivers/net/ethernet/realtek/8139cp.c        |  6 ++--
 drivers/net/ethernet/realtek/8139too.c       |  6 ++--
 drivers/net/ethernet/realtek/atp.c           |  4 +--
 drivers/net/ethernet/seeq/ether3.c           | 10 +++----
 drivers/net/ethernet/sis/sis900.c            | 22 +++++++--------
 drivers/net/ethernet/smsc/smc9194.c          | 42 ++++++++++++++--------------
 drivers/net/ethernet/smsc/smc91x.c           | 14 +++++-----
 drivers/net/ethernet/sun/cassini.c           |  2 +-
 drivers/net/ethernet/sun/sungem.c            | 20 ++++++-------
 drivers/net/ethernet/sun/sunhme.c            |  6 ++--
 drivers/net/ethernet/xircom/xirc2ps_cs.c     |  2 +-
 44 files changed, 210 insertions(+), 210 deletions(-)

--
2.8.1

