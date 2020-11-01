Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA2E2A1F27
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgKAPhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:37:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgKAPgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604245015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=hwjkYy0oMIlzhgFEst/3xJBrxsRxNCTNm6w0ht7u03Q=;
        b=NrliIV6ZL3P4Iu/TYTd5iQnqh4JnYn1FpHUiPuzKoMNqxEHReXmzjg5dB6xiSsmu3k8lNR
        MkH21MLnVT0PxYIvWNe8eU1oIDZDeCJOa8vup1hrVeKawI+oIrnwnPjNnfPwAINTycBbFz
        P2E1HZw7l9pHLUx9j6NH47IWNIRmbKg=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-dxzir3ygMDOfbRj0WpXWVw-1; Sun, 01 Nov 2020 10:36:53 -0500
X-MC-Unique: dxzir3ygMDOfbRj0WpXWVw-1
Received: by mail-ot1-f70.google.com with SMTP id u8so1947483otg.18
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 07:36:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hwjkYy0oMIlzhgFEst/3xJBrxsRxNCTNm6w0ht7u03Q=;
        b=tB5z61t+WAe1k/UEPRDRifKwfa+g4eVXdsSNa3AeTJ3P07/pgQjP+Bfs7ihjtk50V2
         iMaT9bNlZzDuY2KQWYI6VKc5VwReXMOz1/lTThxOynPRdf1j9W8QPxJ7F93o4LQb6PAV
         sL3jBYOWks9Ndt4HbkjBFVaK+RjfX385uBwcihjY9yQ6+gNWx/JATXrX5WoEQwtNcYEo
         P6UbMg36inUuL52tcPYZiY/QlhP5o1atI4fxNRZCmKCkrczMBWNY7jikQ/pwSL59s7Yd
         foilnIhVZiiYIut0rd6tgof2q7JmRrbe8ouOeufwavX+JXMq3dkja5fKnyRogWVdrvmR
         0xqg==
X-Gm-Message-State: AOAM53017XdfCjWiyMK0LgWZQyaE/jnVpgi/7+p6pUgM1r/U0SQD3G59
        RQmujiutOMw84EkwMqjoP5oarUiSi2eKdLbnBXSTUFwYIIAapRscg0rTc4hllYnw9e9S6lpilZi
        eDZjUZ1C2fXMcolVP
X-Received: by 2002:a4a:b40a:: with SMTP id y10mr8958310oon.71.1604245012757;
        Sun, 01 Nov 2020 07:36:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDmgVMwQdGVfOkJr+SFXDfJRq7GUTFZALzFI65I0ihDwrRqBXQudZ/NYikp8OBelhe3WAlSw==
X-Received: by 2002:a4a:b40a:: with SMTP id y10mr8958295oon.71.1604245012597;
        Sun, 01 Nov 2020 07:36:52 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w25sm2902114otq.58.2020.11.01.07.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:36:52 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, edumazet@google.com, ap420073@gmail.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com, maximmi@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: core: remove unneeded semicolon
Date:   Sun,  1 Nov 2020 07:36:47 -0800
Message-Id: <20201101153647.2292322-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 751e5264fd49..10f5d0c3d0d7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8898,7 +8898,7 @@ static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
 		return dev->netdev_ops->ndo_bpf;
 	default:
 		return NULL;
-	};
+	}
 }
 
 static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
-- 
2.18.1

