Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66F52F5C08
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbhANIG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbhANIGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 03:06:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAA6823A55;
        Thu, 14 Jan 2021 08:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610611500;
        bh=j3vuD+4dfRwkLcutbaOqNgukR9x6zrYbX+EHYnGNnww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgDHGsDyf+shTEJTgRukn+ZVPF3cld8ySmHXr7zdf/CUufXC3giv2ceR9WHLPO8Hv
         Ogr8EL/f0SMxDsHYUX/yC+m5T3rIYffEZ8I8pZWJqyRwIySjk6ARkdMGCq9E0zEO4g
         h6oMywmK0MKoGH/mFuxS2WLtM+TMcewPdnAmAt5eIWTHgRZ7A40GWTZoYIxLWZqAbM
         g5wIg62yagTnJKaCil/zU7HbBiVbzBeDVeLMTqL/J3N8ldp3DSxTJtwuvAS5FGWrkx
         jAQA0fBRjn9H0nTBE01EnebSughIetQTZWMZFS7IoQB1mhtN+CjqU6O+zo7Mnayhfw
         uBk774MF8eESA==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kzxco-00EQ6w-CP; Thu, 14 Jan 2021 09:04:58 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 13/16] net: cfg80211: fix a kerneldoc markup
Date:   Thu, 14 Jan 2021 09:04:49 +0100
Message-Id: <c7ed4bc4d9e992ead16d3d2df246f3b56dbfb1fb.1610610937.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610610937.git.mchehab+huawei@kernel.org>
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function has a different name between their prototype
and its kernel-doc markup:
	../include/net/cfg80211.h:1766: warning: expecting prototype for struct cfg80211_sar_chan_ranges. Prototype was for struct cfg80211_sar_freq_ranges instead

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1b3954afcda4..0d6f7ec86061 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1756,7 +1756,7 @@ struct cfg80211_sar_specs {
 
 
 /**
- * struct cfg80211_sar_chan_ranges - sar frequency ranges
+ * struct cfg80211_sar_freq_ranges - sar frequency ranges
  * @start_freq:  start range edge frequency
  * @end_freq:    end range edge frequency
  */
-- 
2.29.2

