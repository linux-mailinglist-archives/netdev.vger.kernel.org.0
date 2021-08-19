Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3375D3F1B52
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhHSOLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:11:16 -0400
Received: from mout.perfora.net ([74.208.4.194]:57571 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240489AbhHSOLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:11:14 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2021 10:11:13 EDT
Received: from toolbox.cardiotech.int ([81.221.236.183]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M6kDq-1n264R1Gdg-00wX9n;
 Thu, 19 Aug 2021 16:04:15 +0200
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
Subject: [PATCH v1 6/7] ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf
Date:   Thu, 19 Aug 2021 16:03:44 +0200
Message-Id: <20210819140345.357167-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819140345.357167-1-marcel@ziswiler.com>
References: <20210819140345.357167-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:jkNqgrohetNBYgv3YHMwa589M1q6hTRTI9TMxdWdZx0KANkAArd
 JHMAsugBRMf19sTR2EtPg+/lO80WLc+VsJtIhnNt2/JDOMZp9NkYFgzpfPKPrhaNQvXVDYl
 KjrF5fDi/7krncnn6yz1jqh8xYHkkwKu4ji+Vrvy5fsgIcFZPUhjTYbZHcbFIQm1YCvt2V4
 3FvxQ4TSCyJOKLlnuacGQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fGM0ZKL5+eg=:N4rzlXJLbGDUhVRUl+rN4O
 HA02iYuqXPsWYlzW/g2B9MrMYHdOCDTaWXWTqOGQW/OY+nvodCbcglGZOVCW1nC7FRbxGZAj0
 QBzV6qrQ43RvA+l8z2dINP7y1bBIlgpSblcHT1LIF25MAdBmc/w2zyNHIzW01VlhWrjZGBfsR
 7i7sr6HBL7uOTizndZr+00WTIE2gNavDhF8wQ5yrix1mIV0W1JT0tViekr9w6H2sd1ztPP1DU
 ggL0kb5dKnT+BN5gfJZEznMKkY7nI0EW+FJgEsA09/nxtcY0P+gXIwaU9B5WUX6IWlzJJsByq
 ZW9U9k9QnVVacouRQM6vCmRJO8KUWfQWLOvfUAjNldufYRKuI49h5JUF2qDS1THsqaj/NzM3S
 8XlbjQgpH22fsRdVvc2uJN+ygKnyUxL347gb2SEyU/dOH5Oue9axIAswRGzJ4sjdBuCBkcHzH
 /pvR7Zfu81XvkPtAGj+WoheJ08Y2WbQ+/MlX1oBye28++Bx9ozJygpoemHDmoHJ8YER+Og6I9
 Ve1ZLc4zlBpGPufVIbKbYoBI46hXmN0CZsbrtfCt+0kOLB3KCIbYQtQx9Cpch5RHW+Bt2ZLfK
 Hj88LqA0EqlrEpUgK7IeRvDW3qMZKbvK5ziReNQiSsbXZZKcl9mIioiMoq3DiwztC7MJyZ3C1
 OX1/zk3LWOLpxwf7V/wzs9D8uR39K/OOMUiEM6ur0C/Lpoc2oLFJ8d1maSU7gMC2SeiDVIJah
 4wBcDNGooqN+cw4GegPK3qTPNpjKwrNh0QmCuR1k1y75YbRPsoio3QfcLdoBYATBurTYvOKyG
 ohKgzAHDSgV5lCUNWIxSZvSm++KdI3EbBPxTWDB3OHra8cp3ImXysVbWExUwkCZ5S9hqiNq
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

