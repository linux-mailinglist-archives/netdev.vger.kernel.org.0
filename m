Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E14AA3C4
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358621AbiBDW6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:58:30 -0500
Received: from mout.perfora.net ([74.208.4.194]:44975 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358303AbiBDW6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:58:20 -0500
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MU0AR-1mpTor0C4v-00Qfkx;
 Fri, 04 Feb 2022 23:57:48 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Song Liu <songliubraving@fb.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>, Will Deacon <will@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 06/12] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Fri,  4 Feb 2022 23:57:00 +0100
Message-Id: <20220204225706.1539818-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220204225706.1539818-1-marcel@ziswiler.com>
References: <20220204225706.1539818-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:kFkz1tuDGKgCmRQ8VMyzBmIGg2GLrG/LHFH3FRZfa1NcI8bbkqn
 RYQdzlQ9qRCegvAA0aT4N3aMrOKVGuQdQOqPZHhm0gszO1/d+3SfSr2gEKo/doZeIJIlXWc
 Ki82wSAcu76QJXkPpqw8KFIhB/DmKL7+KTF+WKuqLTaPm9T9boeeWtfvwbtZ3hb1E+YsavM
 DlNptzGHYziTpvkYIkeXg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9EkdvJbUnKM=:BaAWlmA/99knQ7NcJl0isg
 n33hHWUjr3Y0jwFBusw9sz/3WScgFip0L/jONrFiPOsv/UfLkZeJcuJmPodNgVwDZO6uHshd/
 MrNugB4WxI0I+LI7rVQIT/wYKp3gkgIhMKPImzcrhVGE2j+Rlad+bc7SexKAMhm39uFqGEzGr
 disVIcH4w6gOK17d+zUpc4+IDBbHv6qtM05dDOP9uZEsb78ut7j9lMxfaAxdZBzpq2prbXFn0
 3YE+WTP580YIUPhxLcwZy/rOjOEHerURislEa0NcPS4LtKiz731lF2usnI+HS4gFplSTCOwKw
 SU45y8X031sdbTSYGdF4gEgeivgY9S/VKD5UD0wpb6//mvBAHE0mfNhgpzooGVDNxY4D4xWU2
 IA4PGZho1rEX9eHa7gdayqWrbQK5aXyuBDMC5pt4+hWf2H5OxVsjLKmJbKuVNYBegvwyxBwAY
 dwoZPe/gfhxHe2952XqHLqYymBFtsdQxv0zqjpqMCqda5hGJRA8A0lpXimoeZc7e4MNGCXpel
 znejXWnc975BfYAb1hgTZVvOw5mZPlDrBJqYRssu4dxgrkvXFna+mnnMViaipEYYcQ5GMGpWq
 ty1j6B4rie0QBfAUEHHLpUE+X3C6H/xlQiBrNZATT20OyNRoJ5qUeR+9XuuJX+u6e7rcv4i/N
 +kRzZ14X+j0B0qeVh2ir5L2oVDk+9TF75sIjIlnui0ABUK/2i8KCPZV3/RiMMAF8kmuRnRjrp
 XisjfdhB3lRrAPbl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

This avoids the following systemd warning:

[    2.618538] systemd[1]: system-getty.slice: unit configures an IP
 firewall, but the local system does not support BPF/cgroup firewalling.
[    2.630916] systemd[1]: (This warning is only shown for the first
 unit using IP firewalling.)

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

(no changes since v3)

Changes in v3:
- Add Krzysztof's reviewed-by tag.

Changes in v2:
- Add Song's acked-by tag.

 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 530ad076b5cb..444fec9ec73a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -3,6 +3,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_AUDIT=y
 CONFIG_NO_HZ_IDLE=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BPF_SYSCALL=y
 CONFIG_BPF_JIT=y
 CONFIG_PREEMPT=y
 CONFIG_IRQ_TIME_ACCOUNTING=y
@@ -22,6 +23,7 @@ CONFIG_CPUSETS=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_PERF=y
+CONFIG_CGROUP_BPF=y
 CONFIG_USER_NS=y
 CONFIG_SCHED_AUTOGROUP=y
 CONFIG_BLK_DEV_INITRD=y
-- 
2.33.1

