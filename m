Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6514C1A25E5
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgDHPrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgDHPqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 11:46:33 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05490221F6;
        Wed,  8 Apr 2020 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586360792;
        bh=4l77Yn2wW/bRDMs12FfVArUGIzMtsVYGB6DvYUarqs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF6H0x7Ot7lxgI1ISZI/YaviI/NzcKJPIZRwbZ4mM/xbQrZrwEL38pg10zez1SP5E
         xuOIgatlYINtigXbwOO+bL9qeFHD/iYMHVqtlniNhRBnLGE6sEwI9jcuhPBLVXWwWK
         0ZtgiYvnGF9as+3xSzHcfydypiHgf9tO1mkp/qR8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jMCuM-000cCe-6M; Wed, 08 Apr 2020 17:46:30 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 30/35] docs: dt: fix a broken reference for a file converted to json
Date:   Wed,  8 Apr 2020 17:46:22 +0200
Message-Id: <402922bc26fe9b340dff8693bab57142820f1fc7.1586359676.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1586359676.git.mchehab+huawei@kernel.org>
References: <cover.1586359676.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
moved a binding to json and updated the links. Yet, one link
was forgotten.

Update this one too.

Fixes: 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
index badf597c0e58..aad2632c6443 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
@@ -30,7 +30,7 @@ Required properties for compatible string qcom,wcn399x-bt:
 
 Optional properties for compatible string qcom,wcn399x-bt:
 
- - max-speed: see Documentation/devicetree/bindings/serial/slave-device.txt
+ - max-speed: see Documentation/devicetree/bindings/serial/serial.yaml
  - firmware-name: specify the name of nvm firmware to load
  - clocks: clock provided to the controller
 
-- 
2.25.2

