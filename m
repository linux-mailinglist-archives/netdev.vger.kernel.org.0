Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB13B93F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391077AbfFJQUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:20:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40332 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388996AbfFJQUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:20:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so9813926wre.7
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5oZmnQdwxpYNvu6VjOyd6f4dE42sO3ZYKcE7PCqK42Q=;
        b=jr/MXLcUWe9TgQAvAE3GPawqFDqwLNHlsWoLYoqG5MsDjHTXVF++gaLFmnXlfolYo/
         MHj0ybCZuy3xNBvYHvhrkunRKS8WveRfV32sH4mM0KRx8AQrng1INF3F1g0YUwvTESOO
         XwhqIAn/eBkwWh+Jz2rSkViyQ3321KJVDwjxFZq2f5AE9alXUqjtKv89NMKIHN1z7PaV
         ZFTUsK+w4MHw9J5/LeWS3vsREpfp7IRWsLjoRmBZmV9JTfmfg1KTMh+U8/eQ801ehTi0
         Wk4yebTGSZWnVmFWSCDO9QO+Q6ALZAIWIH/gQ+bHzGsjar8snLuH62fl65iRy4+ssUT+
         TiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5oZmnQdwxpYNvu6VjOyd6f4dE42sO3ZYKcE7PCqK42Q=;
        b=ZvkDgEy7Qz8m/zXw2oVyAQ92pBGc2B3tY9NnaN6uOHGlCg3b/HT4rB/G8Lu3/EtrJm
         0tjSa9o16vxVabJd39rmTo7ZmfSehyMrY7aUugSorUsBEaU2td21+9fCqeJ2Yx3sQt4c
         Zqx9zsQO/PiKDuMY2es/SpvXrCG4qO/w/icg7ZzD39rUXSnSQR8AuKYFCMfQvfQuWS7f
         SYLKtOr+wb5qLneLfhbrq9sb9pSrON75x0slLRYapSIsQjd55Q5yFQ2BiLotqOfE8BVS
         fZiH+VQtRMi6fl8ybgMn0GxBUAvxYP00qlExoWL+0xJzWtIm6eNt30AhLJee7sx7Ipu3
         uItQ==
X-Gm-Message-State: APjAAAUt5zUdoXl8MQQj6lx02acMgoLV9gvalUQ2W0qOloASZ4sPsZPi
        DegwLYxqteZM9jUcmSwmdxenA15k
X-Google-Smtp-Source: APXvYqxYEWMBHB0vlumBoYmvTKeZ2Y2eVB9DG3/kYfMFZg/vAShUi3jTGpvm1FN37ovReMvm+hO/PQ==
X-Received: by 2002:a5d:5152:: with SMTP id u18mr12724623wrt.319.1560183639665;
        Mon, 10 Jun 2019 09:20:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id w23sm10887521wmc.38.2019.06.10.09.20.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:20:39 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH next 0/5] r8169: improve handling of chip-specific
 configuration
Message-ID: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Date:   Mon, 10 Jun 2019 18:20:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves and simplifies handling of chip-specific
configuration.

Heiner Kallweit (5):
  r8169: improve setting interrupt mask
  r8169: rename CPCMD_QUIRK_MASK and apply it on all chip versions
  r8169: remove callback hw_start from struct rtl_cfg_info
  r8169: remove member coalesce_info from struct rtl_cfg_info
  r8169: remove struct rtl_cfg_info

 drivers/net/ethernet/realtek/r8169_main.c | 220 +++++++++-------------
 1 file changed, 88 insertions(+), 132 deletions(-)

-- 
2.21.0

