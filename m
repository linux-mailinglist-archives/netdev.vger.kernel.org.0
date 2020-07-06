Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721342161E6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGFXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgGFXKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:10:17 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCEFC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:10:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id a12so41215281ion.13
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZvIX6vLMbdnQ9xi6X13Q9UES2Dc+IRz4gOtA11omag=;
        b=Cjf8h2QDNDmu6NNDaeQqVXA0UYoFCg5Rnh/FqMDFA/mJbYX8C91CKnmrMizibrHZ+r
         cVrXBaQJIdLTRfiaR9ojksO3cW8C1k5Fx6yK+92XEPYmJtqfPGi2IY/HLhqG4/2rWpN7
         40Rken9P0iVRYtrZi0N5lDn3FJk2S7rLqjx2oWQY0hkFGmbIx7RuWKiOsxBeXQ+0QZgT
         /0KpV5/2QBE5urHl98sv4+Bet4VJIqzgbiQ42BvSkkxdxrXUYJPQdKp/h8fmp8f1Aa9K
         GNzGOr8lNiNfJYjI+XuiiBCxBtumK585s1LvxeozZXFPop1HXNhG/man06ppLnxvjZMn
         s5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZvIX6vLMbdnQ9xi6X13Q9UES2Dc+IRz4gOtA11omag=;
        b=bcFOWYRNjNkrJBjpiJp6d/hcJSoI/6Yu5VXqQnuemYr+obb0lxVpTkkFPg8iq/gMyo
         SA/+VOTOO3BGhtGwtfmKrxLJfWKzaflLudzmLBhF+CQSCdpnNc/bChgY7duE1T9Z5XSD
         IbzkgkNG2bajAF2b3eu9Q2U7B/Gp7DDh1cHEfcmN+3dqSVElTBFPRsJN5TRK9zRlVHXN
         BwlmIm02Xl8OeMAkTw/rMaTqD8m+g8UMQScK6KV8m8+lGXW8nHLxYagGVhAcyQMl02JV
         ESWGi/mi3xrAjK6sbdNFObntFx20H2/7uY4vxWkDRw28pReaGMg62XDKXfUmlC+25hHZ
         vhNg==
X-Gm-Message-State: AOAM532vt+c+6xNQzwcyg6SEOpRRVPFdemUFQgIEf2OUutqEV9vm0ymn
        PTcUKZK5Evo+nFlkGrGHYve2FA==
X-Google-Smtp-Source: ABdhPJz6LtqwPL5bx8536ytEkrXiPsbQqXR9ZnW0ignIJoIs6ZqbuUzjoFFSv5pHVH/Z2zl7gwO5pg==
X-Received: by 2002:a5e:da06:: with SMTP id x6mr27921238ioj.196.1594077016696;
        Mon, 06 Jul 2020 16:10:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w16sm11523029iom.27.2020.07.06.16.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 16:10:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] net: ipa: include declarations in "ipa_gsi.c"
Date:   Mon,  6 Jul 2020 18:10:10 -0500
Message-Id: <20200706231010.1233505-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706231010.1233505-1-elder@linaro.org>
References: <20200706231010.1233505-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include "ipa_gsi.h" in "ipa_gsi.c", so the public functions are
defined before they are used in "ipa_gsi.c".  This addresses some
warnings that are reported with a "W=1" build.

Fixes: c3f398b141a8 ("soc: qcom: ipa: IPA interface to GSI")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_gsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/ipa_gsi.c b/drivers/net/ipa/ipa_gsi.c
index dc4a5c2196ae..d323adb03383 100644
--- a/drivers/net/ipa/ipa_gsi.c
+++ b/drivers/net/ipa/ipa_gsi.c
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 
+#include "ipa_gsi.h"
 #include "gsi_trans.h"
 #include "ipa.h"
 #include "ipa_endpoint.h"
-- 
2.25.1

