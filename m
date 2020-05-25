Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C541E103E
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390915AbgEYOQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYOQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:16:35 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E15DC061A0E;
        Mon, 25 May 2020 07:16:35 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id se13so20588610ejb.9;
        Mon, 25 May 2020 07:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHIeyXCEdhdMGK12nWCYZ9xefPnw5Lo1RQSBlbER/YM=;
        b=K6WWGpLwgExv9IO41O85thbCuq8eW1hirUJE/YUkVkTuSn1sTYp3spMDg4izOrhwZi
         3KnOTOMtfmAkiDkhGvJO7DQYKulpSoIJUaq6dXGN6rB3nNYkdaHwf57noUH4SqQI7lA3
         9alb6OwDiCV91tujuGn6A6F5lP+fe9fE4zQLl0XIDO+Nmqj2jWcTreZL2m9M4cki5VUH
         KOYt5KMDjxpnAc8Wf/+A0FnUFjA1sYX4pxsxgYkt8ptj/VAdI8y1RJMMZx8wvMB5D0FP
         ELG0u7yPboZYIYKW/2kNpEuPGTj155xEGJJOQoEinLyL2imV2g0nrkUWAHxl8wVEajKk
         IHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xHIeyXCEdhdMGK12nWCYZ9xefPnw5Lo1RQSBlbER/YM=;
        b=gjl74yg5OSxC38EXQ4IT6Z81AyMWcePCild9ufrkcKYZ7OXhsBPettVFznKvpGJ4ag
         W8o29V8MrAlLC+RW5KSiHiXjaES+G8BO0+s2QKgQplQ+flbhEGlFjxlvEetRsdojfHbp
         HP4elAmmzt/Bfi163CpfmCnJdo+MWA68xM+Y84urV2DFsVFVB78J5l56PMqfCqpMRggj
         z0O2ERQjDZr40eTvM6ejBg2qkw7R+Qo2YQFAgDw8wRFP+/J34oBR+8WuFZlAOCQSGFDY
         BX0VEQJzKUBWQni3Y1wX1dnMVDX4raO0PlKd2JJP8cyZo7t+5PLXX7jXPmCimsC0Dny6
         Qxhw==
X-Gm-Message-State: AOAM5321+hjiI9IDCuf9EGpwhZK7kHHfxiEPALueYbNdRPYYBJgaCGrX
        96oNQfnGGcEvI5AWngFTryQ=
X-Google-Smtp-Source: ABdhPJxPAmrlPfUcuV32dFCub6lX8zEuTbbVoowp6QVPmu3C9tC4+ZcElIscqZs+mylxg8N1qC9lIw==
X-Received: by 2002:a17:906:e2d2:: with SMTP id gr18mr18447851ejb.312.1590416193745;
        Mon, 25 May 2020 07:16:33 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2dfa:6900:4b6:3b49:50f6:6c03])
        by smtp.gmail.com with ESMTPSA id g20sm15835339ejx.85.2020.05.25.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 07:16:33 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        maciej.fijalkowski@intel.com, bjorn.topel@intel.com,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust entry in XDP SOCKETS to actual file name
Date:   Mon, 25 May 2020 16:15:53 +0200
Message-Id: <20200525141553.7035-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API") added a
new header file include/net/xsk_buff_pool.h, but commit 28bee21dc04b
("MAINTAINERS, xsk: Update AF_XDP section after moves/adds") added a file
entry referring to include/net/xsk_buffer_pool.h.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches  F:  include/net/xsk_buffer_pool.h

Adjust the entry in XDP SOCKETS to the actual file name.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Björn, please pick this minor non-urgent patch.

applies to next-20200525 on top of the commits mentioned above

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a442b48f24b..895c5202fe9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18667,7 +18667,7 @@ L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
 F:	include/net/xdp_sock*
-F:	include/net/xsk_buffer_pool.h
+F:	include/net/xsk_buff_pool.h
 F:	include/uapi/linux/if_xdp.h
 F:	net/xdp/
 F:	samples/bpf/xdpsock*
-- 
2.17.1

