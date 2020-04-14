Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B441A85CA
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440309AbgDNQtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440313AbgDNQtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 12:49:15 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1910221D7F;
        Tue, 14 Apr 2020 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586882943;
        bh=JNdzVpz9Z7yg2D0nVFa2uGzWJ8/+Wsh+62E+aydGZzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUCG8jhe86W6kanMzas8ZHncgj+seFcThXs2JKTePr++6of8aHjZRl2WoSnQy8Zt3
         T49S/q3HImd1aMdkf9B+4gU8kiqpaW8+FQkgnohanObJadYJhPYzLMUz+yQrHBiBfD
         mw/wgqoqBheU4SBpIwxEWuTUdsRqfRojQSVwPhGQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jOOk9-0068mp-BS; Tue, 14 Apr 2020 18:49:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 24/33] docs: dt: fix a broken reference for a file converted to json
Date:   Tue, 14 Apr 2020 18:48:50 +0200
Message-Id: <9b1603e254d39c9607bfedefeedaafd2c44aeb19.1586881715.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1586881715.git.mchehab+huawei@kernel.org>
References: <cover.1586881715.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
moved a binding to json and updated the links.

Yet, one link was not changed, due to a merge conflict.

Update this one too.

Fixes: 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
index beca6466d59a..d2202791c1d4 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
@@ -29,7 +29,7 @@ Required properties for compatible string qcom,wcn399x-bt:
 
 Optional properties for compatible string qcom,wcn399x-bt:
 
- - max-speed: see Documentation/devicetree/bindings/serial/slave-device.txt
+ - max-speed: see Documentation/devicetree/bindings/serial/serial.yaml
  - firmware-name: specify the name of nvm firmware to load
  - clocks: clock provided to the controller
 
-- 
2.25.2

