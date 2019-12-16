Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E21120608
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLPMnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:43:25 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50400 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727599AbfLPMnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:43:25 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so6566036wmb.0;
        Mon, 16 Dec 2019 04:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qr2ZAlkjX9hK9BD8ch3tnUVNPovTQcCLq7rKgec9jZI=;
        b=DFOGEvKSljXP+xUoZlMilinfyWz1/V0mrK0zMC4Ybvs+eOUhtBZgEv3ny8f7ye6qC3
         j2ovNRmw/NJVxtU8yyZe1mNterCuF6WUYjBihdCCAfNWpX4i8lBvFGzqrfImYO6SIif+
         31z7kI7pbfpsS3DyLjl7/hPMJNOnITtxDiEL+ETP7myTtarx9KQVmN2/gvGT8nHf589w
         vh6P6taoWMUUr84NPVyST+10UcxAaLTljW22eLvoWDZ20h4aHFZ1pCsRT+3kpKfxH/Ra
         FXU3gE2N4EurQSIMKhFTE3u5q7DbOBd9rl34ObYXr63DQrQIDNfUfEuVkNBEcFlnZgZr
         Oukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qr2ZAlkjX9hK9BD8ch3tnUVNPovTQcCLq7rKgec9jZI=;
        b=Ys69xvxRbAOQfg1IWW+dOToPlfewD58BBQIdVixp/RrCTyTYIW6QHmMJVQyPc/HB6G
         S7fGDwBo3s9/tlPBSYKKD5XqrCVwTduS8q4wwIuLLsvL3+iB7Uy6cVDx8Qr24m5WkXc9
         CrpWcCLw9gAu1893FSrYWLN/sJ+rhm3usfLa9JOZWzCWpfiJwWyK6PX1pOiz7XhvRap0
         X/mbzqFUBBFpaZhD1xAg6MlphA7Cs3kchpPgtSoV6B0dKBDFeXuRktvJxoknYTrqPGmQ
         ejXnGMcnoZzbjiMnyNpHnuE2HYlzDI11B6qmNohjsdAsmt98MRdyj+TtMk18dkhLSIVO
         cGDg==
X-Gm-Message-State: APjAAAUdOt8TuyMYMPnpYU2F537xl628jzv2koPaMaFzllQOIkLr/qvU
        ecM9XGSvqKUjLA6BpXfCSg==
X-Google-Smtp-Source: APXvYqw9olDC6f/LpWJY4r+0PjsxH4SSOEyGDyRZEgEkwex24rlbEYe72uxvFjymCRcC11l/WCdghA==
X-Received: by 2002:a1c:3141:: with SMTP id x62mr29335434wmx.18.1576500202839;
        Mon, 16 Dec 2019 04:43:22 -0800 (PST)
Received: from ninjahub.lan (host-92-15-174-53.as43234.net. [92.15.174.53])
        by smtp.googlemail.com with ESMTPSA id t12sm20537323wrs.96.2019.12.16.04.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 04:43:22 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     bokun.feng@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [RESEND PATCH] kernel: bpf: add releases() annotation
Date:   Mon, 16 Dec 2019 12:42:39 +0000
Message-Id: <20191216124239.19180-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sparse annotation to remove issue detected by sparse tool.
warning: context imbalance in __bpf_prog_exit - unexpected unlock

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 kernel/bpf/trampoline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7e89f1f49d77..fb43b7a57e38 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -213,6 +213,7 @@ u64 notrace __bpf_prog_enter(void)
 }
 
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
+	__releases(RCU)
 {
 	struct bpf_prog_stats *stats;
 
-- 
2.23.0

