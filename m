Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2D4BF647
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiBVKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiBVKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:40:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808B015C186
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:39:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u18so35835991edt.6
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSWl+uOEl63jvuuhy3nVJsLd9KRgIYTBclYyLWwWqvo=;
        b=yFDyIQ7tHhn+3ZRXa2U5vrWF9Hq4Jfhu2i4n+HlctM7YBMOJhEMCpzvEVqzPU1X+uc
         Tkyl6p+M4WVCtYKhbutfa5VG/anzXJ6fe1Wtml4bxI0+O0QryNdDwJOmdPJz4Jpwzmcn
         02QZll8FtrF7xon/HYpBxlthe+Q7UOrROQjGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSWl+uOEl63jvuuhy3nVJsLd9KRgIYTBclYyLWwWqvo=;
        b=4FjIKVWc3tJd5Fame1ET0Abux2lqpDERCqwhMTiWqGLYJ9L1e+x6NGI9W6UzedvFwA
         Agy/aBE4x1Pnadkb6O/qzgu7r+CHLbJwvPnAh3FtxTpyOptJuW1FwA7sYCXeiYoF3NWS
         4pdOSqoWilaaFml9yJTvhDRZFcqK8N+KDM1yMGQG1aK546X0vKv/T8oirC814m9B+4ud
         wN6LLdhcyCJC9CLkAw0A9arIerxIXveKLP6tg2C0jbyBE753KIHuPBrcsMd/OQzG0Q+5
         VAmm/MxxAFZ6BiB5195Rp6eZHcBq+41dlTmJESW6Az04wAgV/0RiyYttghe3vUqX4n54
         6OoA==
X-Gm-Message-State: AOAM530YRcxx8Cn1tMxtS4BAPgzcDsxh3mAM6/2IHY2CJJiwvBt2jk42
        YtjgV0MqpSQuSBIa/lG51MvywA==
X-Google-Smtp-Source: ABdhPJz0SHPZrfQdVmDqqpde10UtSYWp5Acbw5iRJCLDnl4+7cZ15j3lHXZNdBMgiAAhsVV4mmi+WA==
X-Received: by 2002:aa7:d415:0:b0:410:a0fa:dc40 with SMTP id z21-20020aa7d415000000b00410a0fadc40mr25610381edq.46.1645526383048;
        Tue, 22 Feb 2022 02:39:43 -0800 (PST)
Received: from altair.lan (7.e.a.a.9.9.f.b.0.5.5.2.a.2.1.a.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:a12a:2550:bf99:aae7])
        by smtp.googlemail.com with ESMTPSA id p4sm6144203ejm.47.2022.02.22.02.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 02:39:42 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 1/2] bpf: remove Lorenz Bauer from L7 BPF maintainers
Date:   Tue, 22 Feb 2022 10:39:24 +0000
Message-Id: <20220222103925.25802-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222103925.25802-1-lmb@cloudflare.com>
References: <20220222103925.25802-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm leaving my position at Cloudflare and therefore won't have the
necessary time and insight to maintain the sockmap code. It's in
more capable hands with Jakub anyways.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65f5043ae48d..9d27fe05f23e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10762,7 +10762,6 @@ L7 BPF FRAMEWORK
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
 M:	Jakub Sitnicki <jakub@cloudflare.com>
-M:	Lorenz Bauer <lmb@cloudflare.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-- 
2.32.0

