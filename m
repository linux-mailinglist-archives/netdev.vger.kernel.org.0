Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4A25BDC2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgICIuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgICIuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 04:50:09 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16555C061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 01:50:08 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u18so2009398wmc.3
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 01:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Al+jXmabFt6iTjs3Kkx8j5ncFOEuzdqj1tZqlKBcdF4=;
        b=HJR5mkja6Gyifjzh0YOK0V4qgdXBNL3qp3jJwb+1DKhoJ9onltiyhkIFrpa6HRjx3R
         Vc7tkMw9WAll3m6rQeY5dYNXJG91CeCisS85wbsRmliD2GTzXn+dcpMBb3nnZFFtebvO
         akLfHaTl+uYJe0SAcLOPd4c3pUzauWCr7c/Vc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Al+jXmabFt6iTjs3Kkx8j5ncFOEuzdqj1tZqlKBcdF4=;
        b=gS0kCMiS0xotBupnPv7ly5+4rHG/zQWJJRudlz0sATQ6wNGteY+XeCX5yC/la2Vvz+
         y4/2erk49tVCt+uR7zxhGLlYqlJ2o+obiGpxs+bgtAUB5bpPVWrtS1Z2lqYeuevOpUE5
         h2HNjVtw+T1NWwB9o74JmOEvtPuJQJmuoizNwxS+zSo0sovbFcoMVU0bJJTX8IjDjonE
         iv0xhHAmnTGaLFl1FcJ+xtd0N6Z6Tl2VnifkIAi0PP0g7mskU6uuoqPJDsbXthFJg6xP
         AZPO4kRcWIkaNyiqOYUvdXxUHdOx5wj+A6+n+WjASCuOC7sxzkhtUQMIGaedBPnHr12S
         qDFg==
X-Gm-Message-State: AOAM5327I1+GRsaF38FrmaQktma5WkZy8+CmGUnKMR08+tyChUX8M72q
        c4b/C47mZv6aGf08ugoKFihwag==
X-Google-Smtp-Source: ABdhPJw5sS9s1NLmXGgGO8ihMdeuqOWfDrs2++miqrmb7KJ12mmteP1MEKBD8iECormo6IoLcMB2fg==
X-Received: by 2002:a7b:cb0e:: with SMTP id u14mr1338295wmj.158.1599123007410;
        Thu, 03 Sep 2020 01:50:07 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id 197sm3327090wme.10.2020.09.03.01.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 01:50:06 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] doc: net: dsa: Fix typo in config code sample
Date:   Thu,  3 Sep 2020 09:49:25 +0100
Message-Id: <20200903084925.124494-1-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the "single port" example code for configuring a DSA switch without
tagging support from userspace the command to bring up the "lan2" link
was typo'd.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 Documentation/networking/dsa/configuration.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
index af029b3ca2ab..11bd5e6108c0 100644
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -180,7 +180,7 @@ The configuration can only be set up via VLAN tagging and bridge setup.
 
   # bring up the slave interfaces
   ip link set lan1 up
-  ip link set lan1 up
+  ip link set lan2 up
   ip link set lan3 up
 
   # create bridge
-- 
2.28.0

