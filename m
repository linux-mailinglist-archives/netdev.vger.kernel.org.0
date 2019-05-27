Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2986F2B6DB
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfE0Nqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:46:31 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39771 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfE0Nqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 09:46:31 -0400
Received: by mail-wr1-f50.google.com with SMTP id e2so8239749wrv.6
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 06:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T+BMa4gsX2SpWHDg4/WOwzhZkAoB1v5cWmwKV6NHcXY=;
        b=TbUpcoEaxaQNRfmwXB5IYi1gLT7Tc9zBU8dLzJyt0i8tLNngRrgCtRvcHGpKwd7ARZ
         FDIaVuSHqjDOLFg/TZiIFvE9X/yN2dWV9Vd0qOQRV2tLMSzsKsYgEWg3WmE/v1ad22Yx
         vPgoELfiDmw9bRNTNNqliE+fL1lojg2lMXjqpzujRu7QdrGf2SwVwOhmdwuMLv3ZWz8F
         lA0LefZkxQQl5irzBK2ehVX0ndAxrkiAisDKIKEqpknyY1JQUVUxmixTL1wUJYe5Fr3J
         TJ895UzXCmaWTLBZ74pnJ2I7rvKt3C2JIV6w/MwLoaCaw1c+UUEZlpKSrnnjh1NvNgzW
         ZwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T+BMa4gsX2SpWHDg4/WOwzhZkAoB1v5cWmwKV6NHcXY=;
        b=oHmdmbuDm26ugsW7uPohof8w0IbkLdP26p0gouvSfNycL3AWsLg2F0D3x4r+Mb8X+f
         XJ+jXMLwPn0/ou8l3R8noKOO6GY/sjLlkfFXT9CImYw2MptqkSnGcxb7hLZvLvn3Issn
         WzfRIIxrFLG7XCi91xyrmjtByDk05Dr6RtDJ4nXxVoA/qqJJ4AV0jiQb/M0GV+4mWozL
         VIQg+BmqOXkVp1kT42Ul9C5oL8kWd9Ak+SGK8ZuVVLDu67QAfV/XwLjZDoAKDE93OP4q
         tl+B+il/qhoL9YdccL+RjnjzwUSnfhAeGiO5/thXp0dTqLWOLfDg559T0f7SUESBGLia
         UNcQ==
X-Gm-Message-State: APjAAAV3sTeq4Id5YHdfeS5oaw4jIQUJy2YPPgClFHxQcCvX+hGYsnDS
        HmlQwZkzNugInEArQjx0aB+RxaZ0j9h7hw==
X-Google-Smtp-Source: APXvYqxzp/JP29DMv8kL+YY1dvcjW0NVluckIAgiIJ4N5qzyrZ9PpUdQqTEssjjJsKvceApH/B81gw==
X-Received: by 2002:a5d:644e:: with SMTP id d14mr52019475wrw.42.1558964789627;
        Mon, 27 May 2019 06:46:29 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id w2sm4611311wru.16.2019.05.27.06.46.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 06:46:29 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 0/2] net: stmmac: dwmac-meson: update with SPDX Licence identifier
Date:   Mon, 27 May 2019 15:46:21 +0200
Message-Id: <20190527134623.5673-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the SPDX Licence identifier for the Amlogic Meson6 and Meson8 dwmac
glue drivers.

Neil Armstrong (2):
  net: stmmac: dwmac-meson: update with SPDX Licence identifier
  net: stmmac: dwmac-meson8b: update with SPDX Licence identifier

 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c   | 8 +-------
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

-- 
2.21.0

