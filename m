Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDDF2A1F52
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgKAP4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:56:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726790AbgKAP4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:56:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604246168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ZXci3YM/F8Wd+u3JPKVFSvYgy6OEpsVzxJrs9tBW4zM=;
        b=Q9THev5+KlWYCyl6hrqBYC/bZ4n7gmR6ZBUBBew4lZLsliqAxEP73o4vOxpI3kM0wdL11y
        MtLRuJHRkR0NhJSuJUffWqI86prgu8CYJfOYs9rxLTua0U6aEudY4mVZzNbiqWPLA5QeS5
        lUOq9gMAbP2ommG/AMIScNp29/dytp4=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-4SiRHooHMoWUCa9B7tH_jw-1; Sun, 01 Nov 2020 10:56:06 -0500
X-MC-Unique: 4SiRHooHMoWUCa9B7tH_jw-1
Received: by mail-ot1-f70.google.com with SMTP id n13so335368otk.22
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 07:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZXci3YM/F8Wd+u3JPKVFSvYgy6OEpsVzxJrs9tBW4zM=;
        b=jyyfuioeNOK9DAYxIATcRFMYDpTqM8o6wRGkSRJD3YT59pNWHdtA9YiH6vyxV4fiZ2
         LjN5XPLKvck3cnDe6fIovLo9gyeRQkY3FQuvHd2uRNFlwsnABnSbqVAaBtN3KLQV6KH3
         dSH4H0UOPv/L0U0UIRnRyJRzlCXM18zEXmbdtJhTzOearF4J1U/nf/dtiltWysmVCZUf
         yoBnr1PpHM+yJFfaueRm2PrkcFGw6h3cTxR6HSTOS8hTK0kepqqmm2oECAesmJ3Q2uqC
         EKjw6P3PI0CwEpRk2GCnudk6BsSPC0hHKrNZeSDR6Jnl269L4NUcBXsa9tt44xM5evUK
         woXQ==
X-Gm-Message-State: AOAM532rPgY/CQI6w2hp+iB/IBWhwXMudDheYsWYdqZfhuHjKkw7ZbZh
        JPsYToMCTIVcsnkZUkgbVOqSgwNSxkw9x4wFBmE1DMBLMsicEJenqtmi4M7koCT9TdgkcJDlv64
        dqsArKCHo1IbKSOcK
X-Received: by 2002:a4a:d0a4:: with SMTP id t4mr9050766oor.21.1604246166186;
        Sun, 01 Nov 2020 07:56:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqTyouyXFh9eMtC2RS9ihzYL2T2XikVGqev7YH/kWoRhgAsIdVJn1Ec7TvrZOLF+bRwRfVEA==
X-Received: by 2002:a4a:d0a4:: with SMTP id t4mr9050752oor.21.1604246166023;
        Sun, 01 Nov 2020 07:56:06 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id e47sm1044928ote.50.2020.11.01.07.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:56:05 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, magnus.karlsson@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ethtool: remove unneeded semicolon
Date:   Sun,  1 Nov 2020 07:56:01 -0800
Message-Id: <20201101155601.2294374-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ec2cd7aab5ad..771688e1b0da 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2433,7 +2433,7 @@ static int noinline_for_stack ethtool_set_per_queue(struct net_device *dev,
 		return ethtool_set_per_queue_coalesce(dev, useraddr, &per_queue_opt);
 	default:
 		return -EOPNOTSUPP;
-	};
+	}
 }
 
 static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
-- 
2.18.1

