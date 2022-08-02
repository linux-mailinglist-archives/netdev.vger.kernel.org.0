Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769AB58767B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 06:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiHBExr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 00:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiHBExp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 00:53:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B892873B;
        Mon,  1 Aug 2022 21:53:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t22so4661118pjy.1;
        Mon, 01 Aug 2022 21:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=+KpNao5DG7AgBe+XvT6M4EMyYgz3pagE9PCUtC/M5Qs=;
        b=p/rl1dPUeQ2vYN5Dhcil7pLpG1hqHac7bLGJpzTs90nEs2OGv2s/9FtL19vlUmt9oM
         XVIl7uV+SyCMvJ+CBjAHZD4IjXYGkbKees9UVyr/IOq1g3eynIbqYvmmeMDiLEu+6wj5
         U7JcYfXB+pp+i06JTiqaKJZBnHkHm5NnbrhQtVTRDfNKKnOoYjNRZZZ8zQktz7eysk+/
         6JijXrq5VvJMbXA4F1DCsVjT/+tqbkw2le44wWKoLppBFNQreW3lmlZDi7i0fNmwZj2d
         1SbigSHkeoots49CuF8pn7MU4xdGaDhBE15Gx5iqKSJebF5M6M6RNB3N3JYHXG4kGBPD
         3fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=+KpNao5DG7AgBe+XvT6M4EMyYgz3pagE9PCUtC/M5Qs=;
        b=X6OYrHoGIOJl+hhnWhgEBpkwlOzmy6J/ykvQe/QkkKiKMLu2Jg1QvM/78+DaFdcCkj
         aq9iwnqLXy0B6Sjzo7qJm6wMV2nzr3UI+7Lo+WZg+km+Bve6qFNykadvYc/J5qrX3OAp
         lJXDfIkejGy3ZVfFP7K5d5S7QJ/i0BsTL5XpFpafrwoqy8Po6NWzwmuVT7IsKSrbwT2B
         +/+7V+xykSgPdyjmIF6muLAPufxApb80WIQ1YXH2R+DsSjTkoLSeyfEcshjWzmHlAVLT
         x3CBlPNKPHUHsUPNwP64aXV9ciXfLearjmKW+7fBRPh3OPq1JIBu37HSjMcsCKhDntLL
         xSyg==
X-Gm-Message-State: ACgBeo2jXep3beGd//bdQ0iLrIoowuKuf9naj9zNuDxElGwwUdzRjwkv
        6gHf3ldW1ei0qRs2BxQVIbc=
X-Google-Smtp-Source: AA6agR7tU5h+hx79npWg1wA4HCycS2NujBy2/9g+YfJDHOS4B1pfIuXPNViqQihXlb/VWY06zsck+w==
X-Received: by 2002:a17:90b:1e11:b0:1f4:ee94:6236 with SMTP id pg17-20020a17090b1e1100b001f4ee946236mr12181849pjb.63.1659416024243;
        Mon, 01 Aug 2022 21:53:44 -0700 (PDT)
Received: from localhost.localdomain ([103.184.239.49])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d50500b0016be24e3668sm10619133plg.291.2022.08.01.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 21:53:43 -0700 (PDT)
From:   Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     mailmesebin00@gmail.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] qtnfmac: remove braces around single statement blocks
Date:   Tue,  2 Aug 2022 10:22:39 +0530
Message-Id: <20220802045305.235684-1-mailmesebin00@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove braces around single statement blocks in order to improve
readability. Also, an extra blank line was removed. Both warnings are
reported by checkpatch.pl

Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 1593e810b3ca..8e478118a1ca 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -721,9 +721,8 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		return -EFAULT;
 	}
 
-	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
-	}
 
 	ret = qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret)
@@ -750,7 +749,6 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_channel *chan;
 	int ret;
 
-
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
-- 
2.34.1

