Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB14B21C1
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbiBKJYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:24:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348595AbiBKJYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:24:40 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03381109B;
        Fri, 11 Feb 2022 01:24:37 -0800 (PST)
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M7ZR3-1oCV3C3YYh-00xJjX;
 Fri, 11 Feb 2022 10:24:06 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Song Liu <songliubraving@fb.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Adam Ford <aford173@gmail.com>,
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
Subject: [PATCH v6 06/12] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Fri, 11 Feb 2022 10:23:16 +0100
Message-Id: <20220211092322.287487-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220211092322.287487-1-marcel@ziswiler.com>
References: <20220211092322.287487-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:rf0hT0aeHyLIdu2loRx1Zy/Fdh/cjuPMmxMTcXBYZ2EmTPwGFfz
 tyrlZLoxD7OYvX/ct1Z3LsVE0ZXI4eUav9jH7hq55G8ouOcefAA1FtpzYPlUBcrc6YsA0M+
 P6BPQH5zz8UTVpXp6mvkuBI5temNeqzofaby8EXsoHM/lGWz5cN8C2C7pGfR9cBTeBdgJ/v
 fc0nPXmlG9NosgKCSgp6w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zrql6Y5KADM=:aTsM38AVLTMnEHGDXL5Kt7
 ms9ORCvceNmgrjSAO41QoE3DQO6UnVu+tVC5HCDFQzominrpjUN+BLKhSCTAle78ikUpGIIsj
 n95Tlm82pWsefN0QkMluYZKteSjAnPuixPFlHas1kPqGOTehncV3CYPxBLw+YOH0RvdBciQbT
 ikVSNLlpdi0STQ6bMIpWeUtuGZC2G7RmWumovOOIhxYGcgFFkuo7goKqQCfZGhOnVunjk8qFS
 WL6/2otNIz44uL43Som8sEWAcdED7Kj+SlR404rqAjQwi9MEWX2X6qZW1azerM4NUe9clT7xn
 jRSs3c7P3Bb7X5Y3Mc6GKXJgK8xMNN8qxwwhxIOtKo1bUG0ezrbAv6Om5IBTDjhtisz6rCDUH
 oTHatkSgMOAnCqndtXVcUN4T4g+7i3lwo/Q6K+ggNbi5qOvuVJtO+lz59fMqQKpbluvTD/chg
 wkQ9+X0S5HAA9+uqOspO3rQEIun9SwB/qLhKRbk0biymF+3q7DiNIk6w+VROQEO2QpwfnPTfE
 0YdtemLYEdxY4vMxDkec3/NdIA8VPdTo86mzrmH5WI28/9CW4rLGfWt8yF9GcG/cDhv0kpcPK
 t6JWVVQjejM3AprUD2EKhO9TPtmplqzOJME7+ll3cPg1D4fFoZCWJrebRbdfLqDUfTkaZHE6K
 +lnwuQ5iFZdi0q6kWQ7JiI6Ug6iONb6rgl7k9mmjG4jOSmxYfyhXwYCzh8HX2VkRYIdPeJHx+
 F4PoYmR+CJokuKFk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

