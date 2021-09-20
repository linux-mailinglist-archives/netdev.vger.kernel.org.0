Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76C41178D
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbhITOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:52:29 -0400
Received: from mout.perfora.net ([74.208.4.196]:54421 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241028AbhITOwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 10:52:12 -0400
Received: from toolbox.cardiotech.int ([81.221.236.183]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1Mjjrb-1n8q2D1Ot1-00lCrF;
 Mon, 20 Sep 2021 16:50:10 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 6/9] ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf
Date:   Mon, 20 Sep 2021 16:49:35 +0200
Message-Id: <20210920144938.314588-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210920144938.314588-1-marcel@ziswiler.com>
References: <20210920144938.314588-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:2X/SNXi3Lmk1Ia0b42n9eWIMa40a0ZupsaW5tY7CHbXXHbe9eAF
 v/DBKmFy02usMjtk/gojrg8Ca+ReMNg/FZFr03O1lJXU2Kf5U0c+mS7cdiHzErEWGuJ/izz
 jxZEc2CWt5bTcehJamguMU+3YR4fV3L3BpPWWD1sIc+82dx4AtUc+Z1GX2BLqlFeiAxGFRs
 Nku6I6DqsT3ArLvxAuwaw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x+gGuuTIlMY=:8+TA1j6FYwJXvc+iFXc1fe
 viLxkkSVK6LDO46ypj5VT+h8IeRXfAvxSKeQlQxgeSD73oeGP0uzJtH7Boe8eugdcH4W27vb3
 3LriU7IWTnuiYkxPPjDkda8Nh/DiTQSBr20ggclD05Vrf2Y/22QaikpiQtBnnOCpndl5V5l9V
 j6WFA2YMaMXepfl4lNn+s4pYR1qQ0iPkli+F4pLTdMh8jYJfQJActxaD250gKAsDocvF9yfgs
 c8Qy4mezCN1noBGjJmCJVCXxJ8O91oWHhEV8lz2vHQXnxVDpJEDDkr44ks/yD5zL73sFQHHlA
 n9DihAV/KPgtQeihRLFhldvBbX57C6NwxKQ8mrnxNjoZhUzntlX/uI+2KITT/FpREjdK4uMyP
 4CklpCCMcg9p1MTQtspq/fkcN1S8plZtK/MxlzCWvKpHWEVAcRTFmU6Vytkir47ELVTJtvCBe
 pk97U0QIFe7Um5tlq5Hd5neZ/kTNCUrFPWbuRjPGbuGZ0/69EqkNQhxzMzNPIlOgaoo/CMutO
 9V3Tl0+VOW3huVXMRZNIFNIrX5bwDQ8b2mly8JmnVH9hzsf1sbJyAxCXCcqfTv+ZWG+RQm/zV
 fafscOJzZFiIBPTQAfSTznmCbOjivW+Oc1bxQaUERVNCIEaKqQTu64gcMwEGbj7Gmz6sj8vsz
 8GG9cj1n8OH1Wg+fC4QNlrwlAzwRDdSpBeOei2NTBUqbO7agGxIdMbxh5yyaW9bktRFqcwHHt
 Il+Tfmic7Qd4gSXQWqQsAnAoeP7Yp4otqoyeHQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

Enable CONFIG_BPF_SYSCALL and CONFIG_CGROUP_BPF to allow for systemd
interoperability. This avoids the following failure on boot:

[   10.615914] systemd[1]: system-getty.slice: unit configures an IP
 firewall, but the local system does not support BPF/cgroup firewalling.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>

---

(no changes since v3)

Changes in v3:
- Add Fabio's reviewed-by. Thanks!

 arch/arm/configs/imx_v6_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index c0008b7faf2ce..3e58c76763563 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -2,11 +2,13 @@ CONFIG_KERNEL_LZO=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BPF_SYSCALL=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
+CONFIG_CGROUP_BPF=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
-- 
2.26.2

