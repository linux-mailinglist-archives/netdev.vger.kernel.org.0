Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73D64818EF
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhL3D3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhL3D3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:29:05 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBC2C061574;
        Wed, 29 Dec 2021 19:29:05 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id m18so20185435qtk.3;
        Wed, 29 Dec 2021 19:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9cYq+sFAaUH0aCXhcS4yUtbxJNyxo3lAJslQcNG+d8=;
        b=a/P8PPXfgXvPR8+Y2sL0hiZl5RbK0O0SnXFh1NPCxDtuhlWO6n9k8IRkccpjxl+dJc
         kH8Xr3+cg15aNYxISEMldGXd9sb3MgSr2UXRR2BRWmAPAmkRY3DUu76Xxbg8vYjTNXPJ
         tjvusHtLdby/MKzBd/J+IM/am6DMrmgnAqFoCZGkcI9cjOVSx1zjqJ2mLs1DBUQpbRgj
         3oCHoTc5TULx2zvA3wFjZeVv4t3U8PE7BNXm8NbB/9n2TbU7jzYO7NGQ1oZOqqFI1FTy
         4BRYfpIPUf/xNWWaZF1B+6hDUCHfEPTHEir2hGNmW6zinhJbrDui/xvIZwz9Xjxn5NCu
         2ZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9cYq+sFAaUH0aCXhcS4yUtbxJNyxo3lAJslQcNG+d8=;
        b=VnqHjc/QvoK2ZhUroo3JhHFCXC77geYGXqSJfixUEReaqp5GaVL61mg1HzDOK0pZgj
         A9AFPZIqhRHvV9yeKUdqGEw6NqI6ISdxI3LOuXbtAji6uhBgPcwV9pQkxAMhHsyQ62GM
         /locqvUhf+6Nc1+biuqZLyDppAUTJlioy4eUi0da5sEf9WI2ZUw+X+dpZFm802UQ1Z4E
         ljo3c+iXFLNYTWc62+NkkCUu/UXjobBhlBsZHtoNCxDzXt2SW+mu+yAHyyIn6ipnVrID
         /78ZqPW/6058QtMPGJC5kPsSxZmESKYs5PK5FobtjIWMqOM0hVnRsZgh8eElox+Jiba9
         a8MA==
X-Gm-Message-State: AOAM531VgizIq8SZfqAndfFpJ+BT3AbuZUOPPPSP43RBt3g9q66UYKFv
        gvR8bVbXSb+PP0pfldAxTfo=
X-Google-Smtp-Source: ABdhPJy4uMnPTS1hDfGdbbNYjNwKiGuSs+n0MPUuobef2snDX4UwkmWyP/Bpn7HsKQgLirfoSwlu/w==
X-Received: by 2002:a05:622a:186:: with SMTP id s6mr25260160qtw.477.1640834944544;
        Wed, 29 Dec 2021 19:29:04 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u10sm20027416qtx.3.2021.12.29.19.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 19:29:03 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     kuba@kernel.org, davem@davemloft.net, corbet@lwn.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, xu xin <xu.xin16@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2] Documentation: fix outdated interpretation of ip_no_pmtu_disc
Date:   Thu, 30 Dec 2021 03:28:56 +0000
Message-Id: <20211230032856.584972-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229121536.06d270e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211229121536.06d270e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

The updating way of pmtu has changed, but documentation is still in the
old way. So this patch updates the interpretation of ip_no_pmtu_disc and
min_pmtu.

See commit 28d35bcdd3925 ("net: ipv4: don't let PMTU updates increase
route MTU")

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 Documentation/networking/ip-sysctl.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c04431144f7a..2572eecc3e86 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -25,7 +25,8 @@ ip_default_ttl - INTEGER
 ip_no_pmtu_disc - INTEGER
 	Disable Path MTU Discovery. If enabled in mode 1 and a
 	fragmentation-required ICMP is received, the PMTU to this
-	destination will be set to min_pmtu (see below). You will need
+	destination will be set to the smallest of the old MTU to
+	this destination and min_pmtu (see below). You will need
 	to raise min_pmtu to the smallest interface MTU on your system
 	manually if you want to avoid locally generated fragments.
 
@@ -49,7 +50,8 @@ ip_no_pmtu_disc - INTEGER
 	Default: FALSE
 
 min_pmtu - INTEGER
-	default 552 - minimum discovered Path MTU
+	default 552 - minimum Path MTU. Unless this is changed mannually,
+	each cached pmtu will never be lower than this setting.
 
 ip_forward_use_pmtu - BOOLEAN
 	By default we don't trust protocol path MTUs while forwarding
-- 
2.25.1

