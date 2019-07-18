Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63E86CFF9
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGROig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:38:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37324 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGROig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:38:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so25948647wme.2
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JJvgkaSmjCJtrmNzhzZMuMwrF6MiFraFG+jIt7ToOOM=;
        b=BWQaoHxs1KNZfOL28/JXC62H2rsulGa8CnEr+UoSrvoCMzJnNrS5V/+X8cPs67sgiO
         s9CD0PU3QmRGfNv9stXfuMJB6rgAwabpJ0stB+UnYbftkjFqH6d8iTlAaysf54OlrkgM
         uohfuqUZPVxgGuS0zjdT1JAUCjtqHHwZftG3P+b/9PctF5c8yij34RIBUdL7EDy9O4na
         lFcHlLGa7y/ap62KVYY9nUr5TpQ3IzxFwdNGNIjuAA4XaEhQh2Lv698LI/bdFObZaVbk
         1qWTCQwfRkh70eoU5v/rci/OzkMKUrQ/XCtXgWsCtX8LPR389CZGL/zFSOWM7bB2Mfof
         6AcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JJvgkaSmjCJtrmNzhzZMuMwrF6MiFraFG+jIt7ToOOM=;
        b=ms2f0rv+Jdb5F63noeDYj9iaSr2S5/SXWlBx15aa8RhTfZCr8gjjE3kYVhpYAZXwp6
         d880HsGDOsRuaZTi9YkTXjLzgN4ENfM8oEKJcG08e/3z+Ty4eIBxWptRq3T3kV/8p63J
         dHj2JbMsPcip2hLsAQ5btUPycmiYDdMwEpX9ValoV2Mvjaa66EhAEBkut8n6t/0ErvPr
         EU2TNpw+IpSWkPrrTV6HptBTGONirGry9jBiOQmuO3u0izNCXQpqZcDlijJ4KqIMux95
         M2Sz2H6Y0mXI3vLvXdmhc4PbXkCwljKJ8bf9hZRq2nuKx6w/QNWxl0cGxm6UTHdMw1sU
         xyzw==
X-Gm-Message-State: APjAAAWH8nK+3Bl0kAaO5XoBC6FrYkf3WJDyz2fS7R1ONi9vSdBEkbIQ
        UDLQ814iXE6AaqVzVdbES1BE/AQh+24=
X-Google-Smtp-Source: APXvYqzpcXInRk8WqTXhpR8RjA0fIY3xW8H0E1yF0ePgHZ55pDOtquRo4EUJapiGY1UqJrkEzhWXuA==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr44754448wmj.116.1563460714019;
        Thu, 18 Jul 2019 07:38:34 -0700 (PDT)
Received: from apalos.lan (athedsl-373703.home.otenet.gr. [79.131.11.197])
        by smtp.gmail.com with ESMTPSA id g131sm18477312wmf.37.2019.07.18.07.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 18 Jul 2019 07:38:32 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net
Cc:     ard.biesheuvel@linaro.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] MAINTAINERS: update netsec driver
Date:   Thu, 18 Jul 2019 17:38:30 +0300
Message-Id: <1563460710-28454-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself to maintainers since i provided the XDP and page_pool
implementation

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 211ea3a199bd..64f659d8346c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14789,6 +14789,7 @@ F:	Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
 
 SOCIONEXT (SNI) NETSEC NETWORK DRIVER
 M:	Jassi Brar <jaswinder.singh@linaro.org>
+M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/socionext/netsec.c
-- 
2.20.1

