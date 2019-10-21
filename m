Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1602CDEF70
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfJUO0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:26:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51958 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfJUO0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:26:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id q70so6394440wme.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H208i0+yKYmtb28ZmYPDkQXJ8JyoCpxMxqkklQMOj+M=;
        b=C9qqbPw0Rp6k3rs0Ku/dDl8vLf8KNaVz7H88er3f0jh6tEWccvIeUUGAvASzuU0FN6
         g7Rfr8i2O7n0bAZUbYYBFfoLgdtlUwbBlzay9I5UhNMdut37wft46NrW/dtpo0AU2Co8
         Pnoe8tN6lgAZS/Vn+EGujrl8FclN5tm+bjioO8mAm+xCDlOkc5rWYQD289K5EDs3d81L
         7Stud+8ZNs/MTiJDTiLV1pcYEDVR5yspxJpFNwMhy0lAcHO+GRWVajYStz/8uzDHuHpj
         PoyZkSj4o7v+v6nJ/NUHQZy1taEHk4uwzK48udd70XhELGpXvXX8foGBK61/m3UfBOQB
         82pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H208i0+yKYmtb28ZmYPDkQXJ8JyoCpxMxqkklQMOj+M=;
        b=l4YFaLdnAY0KdbI0SFBtNfmWoLFja9b7Q2y1VtNfCRiNT+BCX3UrJiFU5dkApbSxAE
         R/H/erJ1bHxCbo6Pz6fnWdT0OxgM9lu8HcQvOpn9yJChHrf2uDm/cqnLkdXMKNEMhM5C
         p33g6yvAdIIL+eTHU+mro6Qv5uEsJ/OP1hjdwqPJHteblSCoH+6Vk30hp9O9ivQw3Bz7
         bu6hvnyfjsjPwEnW6eV3cBXAAERvsVSQ4LdSjfSezPtMUjADnOkqbOXRnPtwupfapHQb
         OTu8MSttGC1QakcyOPCl5fiwL5aThhKOqLwGnOvjpno3Ilgq6/5NyXlX/c99i2GeE0AY
         /5jw==
X-Gm-Message-State: APjAAAXshQHFKcEUvnf9hdOnmpyMyPk0/4UU7+YC0dHC88r2jDSAGKFU
        WzvW+Sf5fgGvKZQGdX2mPLik6rWSz9A=
X-Google-Smtp-Source: APXvYqyylduAI98xA8fYqK9pFpj4WEX8H/4Ye/KFY/gZpzuVBoQ0RTMyVSQOVm7h8ylo49nV8vo/6w==
X-Received: by 2002:a7b:cc8c:: with SMTP id p12mr18980247wma.167.1571667976555;
        Mon, 21 Oct 2019 07:26:16 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id u68sm18839537wmu.12.2019.10.21.07.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 07:26:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next v3 2/3] devlink: replace spaces in dpipe field names
Date:   Mon, 21 Oct 2019 16:26:12 +0200
Message-Id: <20191021142613.26657-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021142613.26657-1-jiri@resnulli.us>
References: <20191021142613.26657-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

To be aligned with upcoming formatting restrictions, replace spaces
in dpipe filed names to underscores.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- new patch
---
 net/core/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..45b6a9a964f6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -33,7 +33,7 @@
 
 static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
 	{
-		.name = "destination mac",
+		.name = "destination_mac",
 		.id = DEVLINK_DPIPE_FIELD_ETHERNET_DST_MAC,
 		.bitwidth = 48,
 	},
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(devlink_dpipe_header_ethernet);
 
 static struct devlink_dpipe_field devlink_dpipe_fields_ipv4[] = {
 	{
-		.name = "destination ip",
+		.name = "destination_ip",
 		.id = DEVLINK_DPIPE_FIELD_IPV4_DST_IP,
 		.bitwidth = 32,
 	},
@@ -67,7 +67,7 @@ EXPORT_SYMBOL(devlink_dpipe_header_ipv4);
 
 static struct devlink_dpipe_field devlink_dpipe_fields_ipv6[] = {
 	{
-		.name = "destination ip",
+		.name = "destination_ip",
 		.id = DEVLINK_DPIPE_FIELD_IPV6_DST_IP,
 		.bitwidth = 128,
 	},
-- 
2.21.0

