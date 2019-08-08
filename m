Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6A86104
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbfHHLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:41:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35505 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfHHLlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:41:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so2096692wmg.0
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 04:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HHZUJ/kC4+XNcT4LL4C7KX5s6fjk5K09PuaOqbqrKc=;
        b=IdHbq1cn4+E0gUTJJAdRnqEkQVbQS6psbbd6zXVjbYzw6El1hUgNzrEWKlOExOSFsz
         xolAPGae7o81CsFfmA7IuwFMWYMkSfJAl7tzq+/of24KGeRIAlwy7ZRfiU2uR1n2lBJh
         ICMBXmOuO2sP+GdnOjpYAnwPZYMy/7XxnAPP+jDYYtCbWY0Fbig4IlnHPmr/UDbptHn6
         oSrB9h3vODvqjGO9/eQE30V8tDw+OiANa0r2r5oFTBSf3ucCl6J/3hNUKK2vcJraP/F4
         BZlsdZ5XwxOZS7osYx19txK2zfIqyX6X2+SjN1x9OmsFPzHY+twjKT/3trmv0czErqZE
         i5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HHZUJ/kC4+XNcT4LL4C7KX5s6fjk5K09PuaOqbqrKc=;
        b=rPtUH9FV+zGJqFzW/pCPOsqJ16QNjJH3gxBoCkt9wKohGMMZrYhtvTwpCF+dkJQsMO
         SdSwxKgRsW9YDowd7Wx67qNi8CJMf7yOB28EoWrPzWFWEYxodIifhscFZA2VadtOJqwo
         6/aDf6EzlcIUsWfC9YkyYgrdwhElH0a4PwAlnxGBkdSyKVQ5riNAHV4cnStE6UsFtC+H
         JraIFDYGHQSM+ZJu91ucvbD0k578xw57O9uRfBTn6FDAiWirJtnSaTr5KQBl2/t6Hs8L
         XkH0bmRRht5oBr9xhlNMc0nhih7huo/6duUKRTXwjL7mnDxGphsMX+JxMShMbS67fWxA
         V2Zg==
X-Gm-Message-State: APjAAAWXxXb9gHUhxPtHlUZ+bkOd/E2tyfSYbQif1lrMZS6tL8s+GokY
        /4eYyqzUtp7qmq/Z0/FrcyzdZBu3FxbX9w==
X-Google-Smtp-Source: APXvYqwibGOM8K1pRgtj+TiYesCzz87uQYft5rr6EmKdE8o3sgzgIcNqyt60WACqvwb14/m4Cp50AQ==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr3973057wmj.155.1565264463130;
        Thu, 08 Aug 2019 04:41:03 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id f12sm104555882wrg.5.2019.08.08.04.41.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 04:41:02 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] dt-bindings: net: meson-dwmac: convert to yaml
Date:   Thu,  8 Aug 2019 13:40:59 +0200
Message-Id: <20190808114101.29982-1-narmstrong@baylibre.com>
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

