Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB28549FD81
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349924AbiA1QCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:02:21 -0500
Received: from mout.perfora.net ([74.208.4.196]:59719 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349922AbiA1QCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 11:02:14 -0500
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Mapv2-1myhhP094k-00KN5f;
 Fri, 28 Jan 2022 17:01:41 +0100
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
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>, Will Deacon <will@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 06/12] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Fri, 28 Jan 2022 17:00:54 +0100
Message-Id: <20220128160100.1228537-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220128160100.1228537-1-marcel@ziswiler.com>
References: <20220128160100.1228537-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lCyq7oT7xqkY7LNjfnI4x8Dtx3qyHtYLHe/llVnaOPQ9aTb3oFD
 k7Njrij81UMQ8unFiEyyQKZykXjSl+cCV7nM95h9lS1tJ6S76ux7awBi3bnfUFtUKxEDBvL
 zDGFPa1AQPGeq55JtT1LsPBB9AunhQQbXyZDTiUT0LrKXvVkD+fAjQWe3CQpwDF1DCqY8OD
 9aR4ciQASawMpCUUoOqwg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gog9tXXFDu0=:E+27g7MTVjhtkr46XDmsWf
 PMNNDnpFawiYo9JM/d11URftIcgVdVK6sIS2K6Md4ANQmdvMWZ977ePg4cGOMDFpkYDYTHU6F
 ZbOTrAFp4drUONmikUZJaHptR791HiPbWBpSFzXyUMdKwi+EblXpvv/oGMoWoTUnmTETCq4SY
 Sa0d4jLefO74IDzDoVPBluI07hYy0bqpxUw4DBHcvLzuovMvsCe9qK6g4toM86IZ7qEWXjyER
 JXYxlYeybrPTuwssSDEp8BKbEbSZoZQ7eDS3cnf4bgqhRcE60FQ5vIssmjE1mMEw5wDQawnHp
 mgTnPaNIszfeyad7vMB1IxtzKRAXTUuuZE+p4ASDWK5iCd2r3nkxCMLFZIcOaKFqX09naeFSz
 ndGGB7a9Yx+0A0p+efa0+mxoI/d+0IY/1v4jN1aKvpQWKgRln3Bfvn/jcUVXfo9Go/j4396ps
 infDFx9PUv+al4PUvHTO1RWhPwrcMvUMaluNjFpqLirz0zBKbf+f5Na+S5PySUBHFCJjoTa40
 apN0ydTQLy9ChrwyGJNGv4vKeFG8fieQqhi3Sf0bbvme4gHVC1Whr4Cw7Cg9RQEmb/J7aL9cs
 MZBU8F20zznozQ3cEMabZYws+zHd/7pw1Ay5P5jOPh0UfLH1zGNUEzTdTRjzN2vNU5iA4/NFS
 NueGGBlP1ZZsEIUGq6sjpoZLbjvjY7ZgjE+umSmN08oQIywqMRw8hRAp/ehMK+Ve98hs=
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

