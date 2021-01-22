Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9661A3007CE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbhAVPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbhAVPsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:14 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC76FC061788;
        Fri, 22 Jan 2021 07:47:33 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id i17so7056588ljn.1;
        Fri, 22 Jan 2021 07:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=maHLJw8k83sCOfC+LMzg4m1i0HKxmeUozPV59RTWziI=;
        b=g2a9nzRdIAt2uoCWlQjEXDzAHRkU3ZryqTSyL52cuVLaXJbmlANv6kF4q00G4oAZZt
         2r/1M/R7lBtR0c6BsTrV3ivVsLbAzi+t2vJbgbLWIDwIBOrsVjtamUSKKHwGraZTLgU0
         w+3HtliPaMC4mph6rbNkqFzcp9FzePY1w4CwREhCXKtuoEXn2veMRo6hffRCULXAmJuM
         DUORGN75UlwkVp9POsXQp04kYSTZrAC3xtE65VXcM2GAj8+kL/BfAIfEW5l/Yq21WC/Y
         OkkP9llIEPHn2IyusU8qz798OKcKyk0j0F6e67sSY1OKeF5R49G2s/eiYC+t2gIVNb7N
         h6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=maHLJw8k83sCOfC+LMzg4m1i0HKxmeUozPV59RTWziI=;
        b=nGZI3sSj6RoanUzbKHY/N+QYEEmd0IqMgH9BA7xAdcnFlQC/u775PeN3V05yBY2k4G
         26lRwIiermwBiUjYtNLmdgxutWUNYDlUCKLaJwDGcsGIlhb6mVNPIkw5LkfB2c/CBbJU
         J39hr0se199NcHdccskyJbge/gGAfF741uilqNWHwuf9lpQVFgn8fggxIiKuFt/6aqJi
         9Aj302Gf1RRtSpJUTuEF9QaK6/rDsEGV/KhG0vnVt0EoEU4zQcn4grMF4fd7so9m6nf3
         xqC8zng9Y5Rhv74+oK0lO73bLiZlBJkV/reuCQSPtYJ6hvXUpZ4Loooew4xh/pnvaS5s
         LMVA==
X-Gm-Message-State: AOAM5330fM3xtmHcsDqLXlIp6x2w6XaMFqs+4t1lpa/2uK0dp8b4JP5j
        Oe/lIzu8xA5e2mHN7/dYhZw=
X-Google-Smtp-Source: ABdhPJzDxdWNSG93twA7d2+tUI7e/Cs/mpF0eHiaeLTgO2npLveAk3gl248qC+I/lPRt74fdIpZfEw==
X-Received: by 2002:a2e:b52c:: with SMTP id z12mr1105988ljm.250.1611330452562;
        Fri, 22 Jan 2021 07:47:32 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:32 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 02/12] selftests/bpf: remove unused enums
Date:   Fri, 22 Jan 2021 16:47:15 +0100
Message-Id: <20210122154725.22140-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The enums undef and bidi are not used. Remove them.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 61f595b6f200..0e9f9b7e61c2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -92,8 +92,6 @@ struct flow_vector {
 	enum fvector {
 		tx,
 		rx,
-		bidi,
-		undef,
 	} vector;
 };
 
-- 
2.27.0

