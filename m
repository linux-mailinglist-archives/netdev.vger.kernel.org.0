Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3120F487BD5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiAGSKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:10:12 -0500
Received: from mout.perfora.net ([74.208.4.196]:43929 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240523AbiAGSKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 13:10:11 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2022 13:10:10 EST
Received: from localhost.localdomain ([194.191.235.54]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MnqT8-1mZN8Y43S6-00pHqr;
 Fri, 07 Jan 2022 19:03:57 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 04/14] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Fri,  7 Jan 2022 19:03:04 +0100
Message-Id: <20220107180314.1816515-5-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107180314.1816515-1-marcel@ziswiler.com>
References: <20220107180314.1816515-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:hnmCG4gNJe/WfYxTTdBLiKuTD21o0vH1c0vKJTADHuWy4MsGR2l
 YQBGK1mg00A33MLbiZvQGzNRlncHl83cidX1ZhNCWOlI1n6ZzYPzrsEyYqYWg9VCEBJ+rwE
 xvdW2v+w8JUdUJwFRvQxPDIfCWLEaYrguHyD1QOOOkjYPocsRRZfOyd8wW8sGTzwR8U+H5Z
 PCcpvlARSo+Em6Nh31yGw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z+ZN9Ufiu3I=:OR4f2kn+F0UtsLQqOAitgN
 xnQwyjJAFVker0iSnORT2KGtyT/z7yWKItxB4j3/B4FEx3hTRdACBletV5haLoD9ba/CzWyyD
 hENNrDOSfc6TXLtZ1dVTXEBW8PqhfXeHWXrnDbfheMauK9AzeEUuq+pu5RfGRHSpb3MMuuES2
 AT21Eu/qQVPrLRZBXzFOx2dthNXYoRfCSFVIs26YN6K96bBW7BEYk3NuCwmiJlkmfDFlGewk+
 ONkJNXD61crDGJX+wO93FXipTlG2d5IsMiwt8eb6IsjZc6wF/sHDPRU50xuRW/ueJReuD0g+c
 CjtHnqd+4of7H2QeYq2h+xGXKOy10VtyhUL64RF1DsNe1Qm53og+Yo7Q8RkMucLG0F0DIZJwt
 Hgscd1/PFjSwm6LG6It4RLkwuVagcT97ZWpUuw1CrRnIJgVCmzM6MHHijwyXs9brWWv93T8wY
 RL6QQCL2IKf7VjsRKu+xaOQlh84Om+Bg+e5T0E8KcfLeW2NIsDMNQ6PU12btXFg8B101gILL3
 R4ndXUSYwU3z/aDyY8Ptue8ItbZPi05aY8zWf8o5TOZvX4+4AAdg50VVPEnckia/ZRkFvwWfa
 Abq6wAyDnOpidPp60v8iadWmrrkMRjCBH6QgIXZZe+0gIJCcYhqDw36mMwvOn4tNxziFdg+eo
 iRX0AbV3MoQlHxECt1XCXsPUKdvueq8yc/wN08uzxFCYTk26jBvMy5xjGA6tNkP8M0DhbxuOq
 FLMWhSrYpvfnJWuLlH5qG8bl4512cJ6YkD27QkZmJJNw8B82mAGSp5OjywXERaevpFvqFB1bY
 Aln4kOGl8W+5ojxVvs+FPlqKLxXSg==
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
---

 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 79e4bf9f4c2c..3c8106c5776a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -3,6 +3,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_AUDIT=y
 CONFIG_NO_HZ_IDLE=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BPF_SYSCALL=y
 CONFIG_BPF_JIT=y
 CONFIG_IRQ_TIME_ACCOUNTING=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -18,6 +19,7 @@ CONFIG_CPUSETS=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_PERF=y
+CONFIG_CGROUP_BPF=y
 CONFIG_USER_NS=y
 CONFIG_SCHED_AUTOGROUP=y
 CONFIG_BLK_DEV_INITRD=y
-- 
2.33.1

