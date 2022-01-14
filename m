Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB3D48EB70
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241536AbiANOQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:16:24 -0500
Received: from mout.perfora.net ([74.208.4.194]:60377 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241548AbiANOQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 09:16:15 -0500
Received: from localhost.localdomain ([81.221.144.115]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0LyWpM-1mEoHH3IRy-015mqE;
 Fri, 14 Jan 2022 15:15:46 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Song Liu <songliubraving@fb.com>,
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
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>, Will Deacon <will@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 06/11] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Fri, 14 Jan 2022 15:15:02 +0100
Message-Id: <20220114141507.395271-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220114141507.395271-1-marcel@ziswiler.com>
References: <20220114141507.395271-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Ofqg1wotuIbE57yNqABxTBVgSmAfSFJy90qUd1xVrN841r+puQX
 vrbkeyjqLCscelGuMEk15e1JokwEPb6dgmJ9Bl49ObQ2jRXtKwvbI84VM66TWRg4O9YVV3m
 qPpDLWkHcDTe1APWezMlcSfolV0l7nLOW8+GIjT0k+9RNmrJl5Ux3otKY400ISIYg8Y06KL
 2fbBQRTS7uVAxycGijAAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:39udco0Sdnc=:VtMfCRrcjRlMIcVAHsOnix
 cL/t4SBsEm5c1LQX95avUXgo88CypVX9hyS4xwD23kHjhAhOHMaEb9h8KJgGeb+jE0trCHrOm
 WaWINOTrjqf2KAXUPQDLuiPl7ukVNMawNFJC47V003kM5fxzCVarhicSg0NmOtP9WgOsBY2HL
 98kob5dfyGqQe1Jom2fUDIcsjX9K7FlhX7n3gUZyu4OIYe6m191DDApLhkzSf2252m4UR80dv
 kyeBYAK2LsrRWh7aB/l3KhuMON0B9aUDtowMWFLYgbzUK4nnZzEGnYgpqLd6mRl3SAa+TghcO
 0Kt32eAEU4be2Ut2+PpFvNEwBvzciyi7N6aze9OFY6MTzkSe0c+If1KNJ6wnOH9mClXBPPXmy
 zUtj5bqWD2E1TXBBw4Vk+E6EOBsMge0zBAp5T4anlR5iCGmELvJzlZprUYxz+NogXGTy1TaJW
 cKHSPWjrrIY/bSEtBJgecc389JEHV4b7L7qEvBzgN7C3U77r6Ui/mUgqXRSfpbRQnn27IopXw
 +M5p5rxIrRAyi3+lR7yLQeC13YA/1Ci1PVlPnjGX27kZjmgN+T3Jz5pktUqOM+Ln88EJ5FkW3
 /ZD+G45cz00CnRdAyY/cx9JOAXVpqMIb0sbnrfuEzJEHPC/AfpjQWb2FpyifVjWsFM0OW7VLE
 tTG7CB2T3RW0KUe50IWfgV94jvkzhQz974+8Nh2bKvUNX7bovV8pFjPy4MF/DiV20Pzj3PI+t
 RWD7joQqwkBa26xt
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

---

Changes in v2:
- Add Song's acked-by tag.

 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index bc39559c1658..872b38613c6c 100644
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

