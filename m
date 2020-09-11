Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCF826591B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgIKGHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgIKGHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 02:07:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF1C061573;
        Thu, 10 Sep 2020 23:07:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so1193628pjb.0;
        Thu, 10 Sep 2020 23:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ICuUjpgRR8OCCPVQqNRYxX2OGwz3zcrbN36QMtJa61g=;
        b=GS+kYg8uR36YAHr7o0VqO3QDwo3czk9b8fZ7ukBPfusDYqheAtOJfE8xVrqMpnP5l2
         BzweIQ2kk3kQBraS/McI/VmL8iXVB2E/p9rvg01liAPQEuaq7PvKJBoiFMyrie+VP5z8
         3xd7VDA9Unyi03Q5Li1B41SQI2IeMcmyIzxPEepWq9FmG7NqQ8sl7Bvr0i10eIge7+xx
         89y8ShZESmNFTXlujsb72C1QvYTegSHe/owwVi070Jv8vP8l3pfAwpnMY8VIYIVCXtyg
         6MxYzpMLDpl9P/JTAgYEHa7z8g9v/UKt14HuO2tlkMa1k2RcWBAacq5gyP1bDVJbdFLp
         YQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ICuUjpgRR8OCCPVQqNRYxX2OGwz3zcrbN36QMtJa61g=;
        b=n9iQ0EqhocUa7tGbdqhlJ+xsXTA/5+9vPc40cVzTWGOu7USGIF6w35PeeKdzsgFIJq
         rtIiY8DNM5GknrMUgkzAYBf5JzBk/b+/EPLXZO1sReKvGYtgzQeUw08AIWEzR7KTPBkp
         0xwcAFz0+dBDr+cdKztmQOAOCtu3UA62zMShZWnYaXKT7vxrk4Ms72wB9GAQy6zlqumI
         edWJvbL+idxHKVd5zsRFxOKysq3T5JFjuZd+wWVoc9PjwtSKhKgmjU2QJwJtkarKjP1D
         VGh3p4P2+f6tWvb9dvCqhZ3+d+14pX7bNLhYyy12uGHxZ3hv9R+jFuAsKxZ+ZP+CkaOZ
         ++/Q==
X-Gm-Message-State: AOAM531EE5UbTx8wYh4Ua2LnkJG1kRlzfAL/ug9a+BhiFw2JLWimQx01
        CEBro7yy27jw2ABn+Oyp96Y=
X-Google-Smtp-Source: ABdhPJw43us4wEtQTNcghlOEJktE0HLOzRpWB5hBY/TwO76lu1uXMwi+73H4zh6br+Ex5ligKxgk8w==
X-Received: by 2002:a17:90b:796:: with SMTP id l22mr781145pjz.199.1599804451347;
        Thu, 10 Sep 2020 23:07:31 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:54b8:5e43:7f25:9207])
        by smtp.gmail.com with ESMTPSA id c202sm1016792pfc.15.2020.09.10.23.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 23:07:30 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net/socket.c: Remove an unused header file <linux/if_frad.h>
Date:   Thu, 10 Sep 2020 23:07:20 -0700
Message-Id: <20200911060720.81033-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This header file is not actually used in this file. Let's remove it.

Information about this header file:

This header file comes from the "Frame Relay" module at
  drivers/net/wan/dlci.c

The "Frame Relay" module is used by only one hardware driver, at:
  drivers/net/wan/sdla.c

Note that the "Frame Relay" module is different from and unrelated to the
"HDLC Frame Relay" module at:
  drivers/net/wan/hdlc_fr.c

I think maybe we can deprecate the "Frame Relay" module because we already
have the (newer) "HDLC Frame Relay" module.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/socket.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 82262e1922f9..161dd2775e13 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -64,7 +64,6 @@
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <linux/if_bridge.h>
-#include <linux/if_frad.h>
 #include <linux/if_vlan.h>
 #include <linux/ptp_classify.h>
 #include <linux/init.h>
-- 
2.25.1

