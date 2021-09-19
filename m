Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5208E410BA9
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhISM6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:58:17 -0400
Received: from mout.perfora.net ([74.208.4.196]:38849 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhISM6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:58:06 -0400
Received: from localhost.localdomain ([81.221.236.183]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MeTLU-1n0BFb0iWK-00aRCp;
 Sun, 19 Sep 2021 14:56:07 +0200
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
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/9] ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf
Date:   Sun, 19 Sep 2021 14:55:33 +0200
Message-Id: <20210919125536.117743-7-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210919125536.117743-1-marcel@ziswiler.com>
References: <20210919125536.117743-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+VBnRis98zcdV6WVmH3U6Ds8PFwpf7Oa04080dUQcU2SoolRPbK
 SBs4+ojGeBqo4XnJfm0B5x/x3KKktm1s7e8X8Q5q/3wT2A1pCMWDb4iuy3nWz1jwWzFyFCm
 4jXNqisBRjhplwLzBJLzpjL72fQP+Q8HS4N1aX2aekh1bGJiMe36txRvbKimZ2TYueuj5nO
 QXLlcj0A9F6/PKBjwg9jg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:v1wr9QEbVnU=:tquITxXuvT4ruWgyYvyhnX
 l4JWoVUSBRleA96u8Am+Rpso/bnbh/10jkvEL7P5p9y4px/UhoOoT24DnzXM+Sm7+eLeFffDS
 2jxTEmf6qyWMvdIPC2qoa9a1LBpJ6YhYFW/0qZfcSSnicDYT4/AYvGg/FTgTuv97uJn3xZ88b
 jr0qb1PqBdAYUNTNibWPySxsIck3EGYBbg6F2Yui85ZMh+uWRZm5DM7raCvU0j39diIjwHvLd
 anaMoxVF0SEtNG6P26OO/h5EwNGPAKo61Midw1oVfe9jXTu0i6jfuFOAubE8sdg+wmDAXTBXx
 N7RdqJGbvbh1vXOwgLwgumSJggRnhECQ4BLBwl8TcJyOSJAfUJQ8HQ03qWoRgzlxpRBihAHvU
 aOqqOJsel/z3RWHWtEsGSahe3Iiz0quXr29nGzYWGGZu6wTCVZavIVPwBEyUkU4dzYq+oSvJs
 mWBbAUxW43Wi0aHMQ5YxPyXqEUaYesAw1uJXCXxdFdGsLhgoxxHV6GpPpa8od9bNhqr1BZDhs
 vkDwGdzoz9MTqNkHtvne8+Fx9HiMQQrTEdN/v0IqZW3RY+WboTxVTNEz3+rmSllmRJYvLa4CI
 +nAElaSFrfVKYTCjUWn07aTnchEGWbxiA0ZsCTZVuo3wuRviiAsLv08KtiyLw4PvM4VkfYiFW
 U4l7kMxYQm5zLYkXSDT1T/BtnBNV6VEDVedjn2bqZopmN8omwg7r9i9wQD6SGz0ISPefuWue8
 mzTamRoRRd3akTCUm1FI8GI9VNlC4Jp1ha5qdw==
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

