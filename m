Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC7A4AEF59
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiBIKgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 05:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiBIKgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 05:36:00 -0500
X-Greylist: delayed 662 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 02:24:43 PST
Received: from mout.perfora.net (mout.perfora.net [74.208.4.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179C5E04FF2E;
        Wed,  9 Feb 2022 02:24:42 -0800 (PST)
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1N3ryu-1oHIft0ig4-00zopa;
 Wed, 09 Feb 2022 11:01:41 +0100
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
Subject: [PATCH v5 06/12] arm64: defconfig: enable bpf/cgroup firewalling
Date:   Wed,  9 Feb 2022 11:00:49 +0100
Message-Id: <20220209100055.181389-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209100055.181389-1-marcel@ziswiler.com>
References: <20220209100055.181389-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Kw+BhOFTEuUQKmEHH4xL/6JksYEjaYP6yvF8rvBT0drqrWrhZUL
 +NOKeIXqZ9z0rR2/UQ69oL6ixxBvNn27jaF96mlpJjypAdRe6lwS6/HjJB2Be0xpUPb3/MR
 Z34gXF5/BT8bO6rRAL+ITnNnjcmp73lFlrrVNDLlmu83Hlqy1ooP2f+8tNHlcnxEpyDv1v2
 0ivfnJbbEi8wcY4ceQMWw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JR6ZoSCiM40=:frPillA8bAa+3F+EN/IdtP
 TBa70/SrOF0QJ5MROOkMr5nbD00xIov93nBUBHEhEQ0MSdYdMpUjVlmOHeqmCPQVdJKCh3tCI
 HYAu1FGZaWrv1/X0C+llreft9p1wFNj/d3HravTRqrQM0QXx/fF22xbq2QQIo0rim4SoLfUSx
 wezZb0o3Aqntqb2N94AgwYfYP6Z+74/kTRjmYDzReROhxz7oM7G63OhD6JwfhvrEUvEtVymt3
 /v59kklK7do1PH3O1+h9cCici6kEK1Z+M8dmdZICOsEGThbCAK7pPwgpnR7wcgatLU5vDhwb2
 kiCMVimaJvAcdihTTlpjAYs544Szq5Y6UhpeNA3ODXDh4pDNI1Ui57iZeDrf/y0UhZ+chDNZo
 NH0u9NHlPhfmDJ3WS0rZQlNFsYuitUwUWVaU+x51+lPvyDx/KqQM1MDKjc6VMAYLddflPkcvo
 8SUpEg45k8zTSNsON9hRoeDLq+7IzT46KmCwmUFobNv4kKwrQVit7DHPLxEc5sX7PGrHgMBUb
 XfRnAe+okSO4w3No2Ugh/C33QCYuldsSvg5kW4OqgTnJnuz9s5WosoS3TZrrxmoyVGJ4D5fdx
 yuR4ve6yDDJJcQG/qBZR0l2rnpPX00Vg8+ArZo5VeD24vwJ6GsVxEUjUhVOfZr/2uYfWUL03d
 DRWjGOCHe0JQBIoqzN4fmPwykBHix3M9Uu66ltNXajfFLVqNt5c9sDmoLkQvOAwGBTO39igRR
 rUlnchakmjOUdOD4srYQsRW+S2lDYFCUY3+0HNGFiAjguwqk75KQEnIWP4vTsmQsIl3lxy8zC
 4IxURdvXr2fLq4aFy5lkwSHj9R6Aw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

