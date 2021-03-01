Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE3327E53
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 13:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhCAM3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 07:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbhCAM3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 07:29:10 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED18AC061756;
        Mon,  1 Mar 2021 04:28:29 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d11so9760072plo.8;
        Mon, 01 Mar 2021 04:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHD+dmI20QNVD+k93HgaG/ZSc57gPdyWhsIQt888bU0=;
        b=QJe6otU7oFnzfVYfABFV+zT6K06uP2ouY1FwkhDAs5fQMTlX7zESkdd42368+uS1+4
         mtGFqiqx2WvwaGDq5RzpIRY4m/cMk0PVqPaOlSJJNqy6QZlimSUgtqbU4bGuJKmbEPy1
         SFsZLkTtYQXo2tMo1tkI03ODfqR9bheAguaWTjk8kegf7nSzeQfvZnMd735ZPpla6APW
         ep/CcIo7DwOzHvbSKkw8RWHcyOoADegjU0SlyB1Ih6sXO6fi9fM76yGCW35+nxYkNzK9
         GWIu7f+9XVREmMYy2vceexTD2zy97Fz8HNqyxWqxexeobxzftX3mE2WaoR2Z9m8yg40B
         /oQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHD+dmI20QNVD+k93HgaG/ZSc57gPdyWhsIQt888bU0=;
        b=hQF+8oAD2AQ7s7W7hICdNGWDeZCmvFkRMWmMWbQYpv30zdoD9gzFoZGFW3kzokIkoT
         YaXPlpfTuCNrgLG97SEi26DHb6mfYogJa9v2o0L4LiNQg0SP5uuTECcfooTi9pOM36qM
         oO+fcpOkfYp2dXnq+pUrcIg4zmKPp8veGg5wtzT4d8nwhR55SBqAzO//ZuzHk7TrEd+U
         jbXN2ef4w4HJIVrl2dkDAXPsO14KnOoOq081e67EnT+3xnaaXt3oF/ZLbYAD4MoonSFS
         6a9uzFe1Jj7Kl/QvpV4pRUEiC8MLX4Xbc/+fBHCWiSnj2zcehcD9xD1D0GoJgEBEyUL4
         ydyQ==
X-Gm-Message-State: AOAM530ZmemdmGXAoS0vGwcZmRN17enqn4jG8aVISCK/QY0SAzqY81lL
        z2cxuC3OzgfWh/geieAaDL4=
X-Google-Smtp-Source: ABdhPJzEQ8vlTy7OvFbOoISMzQcbDLc2PAFRsaKgCo/GhaYQXKaVwcVjQJr8Ni3FbCn5P+ogokdJEQ==
X-Received: by 2002:a17:902:b08b:b029:e4:deb:69a9 with SMTP id p11-20020a170902b08bb02900e40deb69a9mr14919133plr.35.1614601709598;
        Mon, 01 Mar 2021 04:28:29 -0800 (PST)
Received: from masabert (oki-109-236-4-100.jptransit.net. [109.236.4.100])
        by smtp.gmail.com with ESMTPSA id a23sm17813748pfl.29.2021.03.01.04.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 04:28:29 -0800 (PST)
Received: by masabert (Postfix, from userid 1000)
        id 57870236050B; Mon,  1 Mar 2021 21:28:27 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] docs: networking: bonding.rst Fix a typo in bonding.rst
Date:   Mon,  1 Mar 2021 21:28:23 +0900
Message-Id: <20210301122823.1447948-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a spelling typo in bonding.rst.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/bonding.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 5f690f0ad0e4..62f2aab8eaec 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -1988,7 +1988,7 @@ netif_carrier.
 If use_carrier is 0, then the MII monitor will first query the
 device's (via ioctl) MII registers and check the link state.  If that
 request fails (not just that it returns carrier down), then the MII
-monitor will make an ethtool ETHOOL_GLINK request to attempt to obtain
+monitor will make an ethtool ETHTOOL_GLINK request to attempt to obtain
 the same information.  If both methods fail (i.e., the driver either
 does not support or had some error in processing both the MII register
 and ethtool requests), then the MII monitor will assume the link is
-- 
2.25.0

