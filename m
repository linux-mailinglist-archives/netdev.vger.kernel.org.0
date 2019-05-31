Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40453073A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfEaDyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:35 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45358 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfEaDyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:16 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so6998868ioc.12
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AD2v4+YBh23vSrSakkquxEV0xAfLkc+oDW+gsObgm4g=;
        b=v1Im+dSykIZ/o17BF2dZBN6qKUORfLiTIwGOO21jMWRdRFVgvCgye8wMMCE2pTy9mO
         dzHZGVmPOV+yUJSAChQU8I1hW74bryP1A8PNhrYJyXRDQHkatWnUORM7hhHV//8JIVqq
         1vJu4XMk1QmOluxXtFqS/p16+wp7r+E82bnLZNBw5zk9lMr988zMbe44q+gzQgxsqULY
         hUWB3Asp1j5ktucxfoyRCUrr6xbSwwX1rUURVIB0V5NIosbfr7BARxFvkJb9TYnCkFMa
         Tm3ZpQq7ApNQPFkYHvQ+uWJjGJDXjch4E2gN7wC/sYMAOaJZVC3PpOeVFaLRpsxkfm3B
         J//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AD2v4+YBh23vSrSakkquxEV0xAfLkc+oDW+gsObgm4g=;
        b=MbxqVZm4Ay1EpSQWeyYyWsR1KgQQK44zDnc23VhQpQsRQJrKdrBhkmUWoouY1cL3+O
         eJe0vNY2mtGXLmtTo6Od+QqE3J/yVA0RfKSNEUJf20n+GQHZz/rS/l4nzMc7OMEsc/5O
         SPp5EpZNKpOx0I87KugufkKor2pwUg235UnobtA3pCQYYboc8isXLNw9wjBPFrz0W+Rh
         VbxPTfu4GVi2fFRRnUKHtKhYaRmN9Pm+wO+96/760f/rltFlarfCLuGJ03NwQ9hsA5NR
         lbYyYqYVRDOdfVocAF3Wx/MxpJyacXtviBWkLCapTzWTgBShQo+y6TVHyY8Fle0tjMUv
         LvNA==
X-Gm-Message-State: APjAAAVlhoirKwA/EY2JFDT57uD9ttCbnS9qCjG5WJhjkZZgGfOL9qFY
        bTbvtLysdA8kaTmtlj68lEbY4xl7j28=
X-Google-Smtp-Source: APXvYqycI8C7GJZADcTmt8i31xiUOJTKNoLAX+58tPg2SEvn+jL2s46fJt29gnMhTlelRCo9iy5FmA==
X-Received: by 2002:a05:6602:50:: with SMTP id z16mr5477434ioz.302.1559274855582;
        Thu, 30 May 2019 20:54:15 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 15/17] MAINTAINERS: add entry for the Qualcomm IPA driver
Date:   Thu, 30 May 2019 22:53:46 -0500
Message-Id: <20190531035348.7194-16-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an entry in the MAINTAINERS file for the Qualcomm IPA driver

Signed-off-by: Alex Elder <elder@linaro.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 429c6c624861..a2dece647641 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12872,6 +12872,12 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/qcom/
 
+QCOM IPA DRIVER
+M:	Alex Elder <elder@kernel.org>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ipa/
+
 QEMU MACHINE EMULATOR AND VIRTUALIZER SUPPORT
 M:	Gabriel Somlo <somlo@cmu.edu>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-- 
2.20.1

