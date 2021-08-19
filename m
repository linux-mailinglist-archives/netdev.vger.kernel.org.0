Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3390F3F22CC
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhHSWLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:11:19 -0400
Received: from mout.perfora.net ([74.208.4.197]:42293 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236811AbhHSWK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:10:59 -0400
Received: from toolbox.cardiotech.int ([81.221.236.183]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Lb4Gd-1mwosX3M9x-00ke5m;
 Fri, 20 Aug 2021 00:09:41 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Fabio Estevam <festevam@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Marek Vasut <marex@denx.de>,
        Martin KaFai Lau <kafai@fb.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 6/9] ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf
Date:   Fri, 20 Aug 2021 00:09:07 +0200
Message-Id: <20210819220910.586819-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819220910.586819-1-marcel@ziswiler.com>
References: <20210819220910.586819-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ShyQ8uLhgyULjUKVlmeT3C9qX+UeB8G3E0gUgAdHEk5Na9ZHHYp
 1imKvB5tP2wml0qsBaXLRLXqvnFZEVj//ErS4+XQbDb+qscLChuZ3G0sRyBjYG2yKJRVjbb
 VAFVp4m4080xvup26lgXnEzIkfVtRRLW2YRuyTi1tWvtGyJQgq13cd5BUc3oKvB080Y/Yxu
 2hbB756UmUX2tnAgj/DhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V4sqZyu9e84=:bspV/ZLPo+2mOtwY0p9gb1
 XQaSxkBb/yzdBxPa12loIoNDwP0ppAg9A707qHb5/PawaoIGMjJpnRdkG7+V3qMiIawiv6Aju
 gEMP7gaTTeLo/TgX6sjXLIGwM0+Jh36tEF/uAclREqTCo0OpMSdHnXxBKnRBDPOGgkOFA88IQ
 BehTQWaTFQ+jiHIXLTZfbqPkjs8y5TiXxKPpGUz8LUPKW+ngXcaI+xgapXfrixwcl7xISm2fq
 50LgXgCue7IfN13VeOwF50UC0zfmNzP4poW1QKXOuIBi0F7MWSQqYzMjkj9QKa5Ca/LbUaD08
 cH78usVMnp0RWNEe1gp9cP8Objii6/qN430mfDCvMJRtncQ8+FpgEXL5UUYqK6wAWGYHYnIMu
 tUpeLG+PqTkLfvu6pa5An87oxmTf5cxoc0q5PxWPi7Xy087ShfR0UhLSL9kU32d40IgDWxsIf
 fdqyIofuPteKoZG175DxEFJTNJvXJ6Mv7WklSQflcMcKmv/0MFfiYZhVjpNzZlA7Ny96FxQ8K
 gmkyVzgwsO2pgAbu1gD9RfEFLeuoxTgZdXDrm6xvj8Pp7045kmaTUHdyOyJE7ROfCehuYdgXM
 N+YZiq6urYWYai2YmVxmG1VZ6w1PAL46EherdxcEhdYPXm6dl14uJ9WAMD42s5eeRPuQ/cMzc
 YHFeEn8/d4krIsm1SdDP1OTTH4l7Xas+zZUYGTWaSdyCTcKzGHeJWe50TlTEK1pOEftY2rJBr
 eKZF77culVdYYYcQ3mZsF+R5QlSZ3U4zpB+GEi3oDK1ma3G1UvzYJRuHXqaX1u/ejbHEzeW54
 ibrUxZn56AvYySCNJc8n/bMran2Bqkj6Ds6ap7CM1IcTD0iBCRARkFjwkUhL3U8WIDb//0G
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

Enable CONFIG_BPF_SYSCALL and CONFIG_CGROUP_BPF to allow for systemd
interoperability. This avoids the following failure on boot:

[   10.615914] systemd[1]: system-getty.slice: unit configures an IP
 firewall, but the local system does not support BPF/cgroup firewalling.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
---

(no changes since v1)

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

