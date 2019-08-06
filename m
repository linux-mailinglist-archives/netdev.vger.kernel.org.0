Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BB2831D3
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfHFMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:50:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37767 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHFMup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:50:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so76318169wme.2
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8yW7mVu+nN03VbqETwhpsoLUtIU4YcLbfhs55o7BvE=;
        b=RTZRwX5lhpwBk5ffpnQxAAYx7/cLanVfmlliMxc8iNALHbRdTPbkXa73FiQngVF4k2
         gSR0nOfzERuCwqrzYPvSe6lQofqNqPqmAIDQYitxE/mLl6BCuiy1cQSaNQfPw+V/7ShZ
         tnjlpMi5kgAstEAkSvRTFWs3Te4PCbUIiafni+sBHmgX7jOygkvQuhor9CBfI3jXaA+N
         qYJFwoWghWxkSlGmDwY4Ooltorgm5bfc65AOpvepNg1wS1RCvbIZRmCj0LVKqLMy03cg
         NPYjcOmyId0MlWnqhIp2J1V6qUTGUTpSHrJDxbxu4lRlPJ82xwQBpdT2BHMDT5IF/ItJ
         fEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8yW7mVu+nN03VbqETwhpsoLUtIU4YcLbfhs55o7BvE=;
        b=P1lXKdXxjRI7NV42fmsuUepNIhTgoCDh7BrDBnqz71Z9wfPU0qRpNIiAc0wLAzXsjH
         qC+St+KuA2hq5JzDzPpajPQ6MDgcrWawCFce06Q1RZY5cm4ya2cM2J/1EPymY4gWGNjO
         M6q4jEGzgt+Ft+cdGP75wjHRdVBvWa814hxCbMJGmRnvmAy1NqypnMshK/kydXKBoOuC
         XP/E1mEVN/x2HRUAmRMW/9b3gLH422/JBN2oz3v89yYSMXt29OLb++s8KcaImUqqbT8a
         PYdZF17whq9apNp63UffwWaQbXGxapqJMP2E/7Ql5o00UfrZK2Uf9SyElQREo6/Ll5W4
         EMSA==
X-Gm-Message-State: APjAAAV7XP4Mh488k+tYiSGTAifznAAB7nRgBJQUtZJ5noahzZdNif5m
        wNz9tg6JKcgk3QgoFU1KkJu/4Q==
X-Google-Smtp-Source: APXvYqyO9qfySQufHv8FTPVAmHGN0v/i1YcTHeQd2dt7QxoS3vNu24XyzJhi5stC39e658qAYY58Sg==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr4611089wma.23.1565095843565;
        Tue, 06 Aug 2019 05:50:43 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id e3sm109049221wrs.37.2019.08.06.05.50.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 05:50:43 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] dt-bindings: net: meson-dwmac: convert to yaml
Date:   Tue,  6 Aug 2019 14:50:39 +0200
Message-Id: <20190806125041.16105-1-narmstrong@baylibre.com>
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

Neil Armstrong (2):
  dt-bindings: net: snps,dwmac: update reg minItems maxItems
  dt-bindings: net: meson-dwmac: convert to yaml

 .../bindings/net/amlogic,meson-dwmac.yaml     | 113 ++++++++++++++++++
 .../devicetree/bindings/net/meson-dwmac.txt   |  71 -----------
 .../devicetree/bindings/net/snps,dwmac.yaml   |   8 +-
 3 files changed, 120 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt

-- 
2.22.0

