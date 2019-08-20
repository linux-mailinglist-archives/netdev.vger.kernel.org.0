Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94B95900
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfHTH5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:57:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37406 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHTH5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 03:57:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so11324950wrt.4
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 00:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tchdtmk5F7h2SP8mzdRtJmsq+fYnHuGWtMSSIw89WGE=;
        b=QBVD7UH61GHuPXpXQft/phCUoJkwNJ8e6e3nCTfc/1NqFxhFr4j7SeAnWxYD0GG1eH
         FxbH5XW57kDWs3fnFMongqoQ1DlvaP2HEF+QwPAVQ/lQo5GFUKwp/SVwc4BFQeTPD30K
         o0Miqmc2rj+PSNaKUrMIA2jxslfSsGPhlViWXng4HVm9przmpP98RN6ezcruNCRjDdFs
         FIoIFAwbfyjYsS9y6w/9wA7wyz/s/Rtmx2PuomRK8+nMZRr9Ege32OHBeVjZ7cegbc/z
         vKkrszkEVli6JHEU2P4bj0/hG/Ov8R38U/z0nQYeqal47JFkGa9XWbk9pl/x0gSf+6B/
         IsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tchdtmk5F7h2SP8mzdRtJmsq+fYnHuGWtMSSIw89WGE=;
        b=Nmz3Gxxad8VFjloERM5Ydgjv4m5r97UzmSbNnBpusvjmh5tWc2Wh1Jo68jmWfEv9f0
         bFgHbDhAPBYZovDaX3UjphYSZPufyqU8uR/CcxcDraO4Mu48LfACTlRbpMhPFDiTOulE
         RRvVpxMBk/ttdqoI48KCUvtOcKUL4IYjXwZhLAs5m4zQGpLAldNp9GjBz9BZ68lbVzJg
         pKz9RkCD83WlkKErIVkbbpmQl4A4v7pdHqXX/E1KJCXDT0n+jIZKZQK+42adosLelyKj
         k9ycAqW0Z/8rJHYtXAoDbAjCQYc3/OLQvHNS81/0xxZtnW+IClqN5uFQKsOZHWQ2C9V/
         o4Xw==
X-Gm-Message-State: APjAAAXH2tNELVB4tEi4+1NnfkwfOEwkQLFfistrYBODHUCB5VEDlnuf
        IfSycA7wf69d1mk48RGjVQnyLQ==
X-Google-Smtp-Source: APXvYqz35DSpTf0iX8quJPKfw+8fSiZAcN4YJ2/eier/D7uQL2HGvfnfx43BsLej8/27j+Tkzhst0Q==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr33919384wrn.142.1566287869291;
        Tue, 20 Aug 2019 00:57:49 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id q24sm1506467wmc.3.2019.08.20.00.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 00:57:48 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net, robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 0/2] dt-bindings: net: meson-dwmac: convert to yaml
Date:   Tue, 20 Aug 2019 09:57:40 +0200
Message-Id: <20190820075742.14857-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchsets converts the Amlogic Meson DWMAC glue bindings over to
YAML schemas using the already converted dwmac bindings.

The first patch is needed because the Amlogic glue needs a supplementary
reg cell to access the DWMAC glue registers.

Changes since v3:
- Specified net-next target tree

Changes since v2:
- Added review tags
- Updated allwinner,sun7i-a20-gmac.yaml reg maxItems

Neil Armstrong (2):
  dt-bindings: net: snps,dwmac: update reg minItems maxItems
  dt-bindings: net: meson-dwmac: convert to yaml

 .../net/allwinner,sun7i-a20-gmac.yaml         |   3 +
 .../bindings/net/amlogic,meson-dwmac.yaml     | 113 ++++++++++++++++++
 .../devicetree/bindings/net/meson-dwmac.txt   |  71 -----------
 .../devicetree/bindings/net/snps,dwmac.yaml   |   8 +-
 4 files changed, 123 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt

-- 
2.22.0

