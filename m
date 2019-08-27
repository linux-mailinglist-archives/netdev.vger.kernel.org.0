Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75C89F282
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfH0Sk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:40:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbfH0Sk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:40:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so161461wmg.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vZemlPKqHbVIG6h7wH8/vLUeg9zBuEHCqhXPPuRJxgw=;
        b=nktQiW9l0KcKNfH5cPcxkCGBlG046XDSkD9Ooo2EmkuJj/zCwSsKmpdKNFHPBVZN/3
         eDRvFpZwR8XHet0ZuDf+etZqB69w0R2dPfQXgdNoGCAzxYXiKoynhjZ+rbMdSlYyqYn9
         xgm5lhIcHA8uwHRkt14MVjzoz1UO4k28D2BTFPgPmKYxvbDngZztNMfpcWTa1evpcKmP
         v82jvdJd3GJHhtinJdpW/GljhegaR+tVNEOYHAomND5gEq5TsuRlilrTLgTbvnP2WJIa
         FZZGpoknG78CahVH+9mzRJ/uRIADOlDetBes1NKDZGyow2DF39pz4Fa/1AphrScNOkqL
         SdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vZemlPKqHbVIG6h7wH8/vLUeg9zBuEHCqhXPPuRJxgw=;
        b=VtJb4dmOojvtG3z9yafYFq+scR2xihK+kfQp0XN9R+9hrx9GY2JGs/0APGjMGBIXQF
         q9nXepvE35aniYvxmQS/77ljziduFoWvw/EnX0CxoQZzoccq5dR0CoiUn5ixBgrDFZut
         fu6aWNUM09z6UC7/VKw8qQPCCmQPhLD0EIQcfOF392QOwuYMZrf86FVKJ4PkJkzAh1ci
         RTfMTp8bFrrRvGgsJs1HvqU/82CdNeZMc/6l3+dJcchL4jL0tSZMnl6MGVz5ych02h0w
         CYY7+ETUTwkuVnxdJGijBrKgIRceV/K7VGM1BCiGIC0GuBrGFt39EX9yNviP5tCvOKAM
         PBsA==
X-Gm-Message-State: APjAAAW4KnN4z0cpfz+x9J4FC1rOtlSx953402EVlkzijEDYwsiyC4iX
        Vb1rBqJxAwyIbUToYbHjCWA=
X-Google-Smtp-Source: APXvYqxrgaZd5Ua/J9LoTZMqVyYeN9sWS6l61v9DFGDrLLpfNJ6Um+q0pWqFBESAl2M0h9MXet6evw==
X-Received: by 2002:a1c:7606:: with SMTP id r6mr456386wmc.78.1566931226592;
        Tue, 27 Aug 2019 11:40:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id v6sm468764wma.24.2019.08.27.11.40.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:40:26 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: add support for RTL8125
Message-ID: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Date:   Tue, 27 Aug 2019 20:40:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the 2.5Gbps chip RTl8125. It can be found
on PCIe network cards, and on an increasing number of consumer gaming
mainboards. Series is partially based on the r8125 vendor driver.
Tested with a Delock 89531 PCIe card against a Netgear GS110MX
Multi-Gig switch.
Firmware isn't strictly needed, but on some systems there may be
compatibility issues w/o firmware. Firmware has been submitted to
linux-firmware.

Heiner Kallweit (4):
  r8169: prepare for adding RTL8125 support
  r8169: add support for RTL8125
  r8169: add RTL8125 PHY initialization
  r8169: add support for EEE on RTL8125

 drivers/net/ethernet/realtek/Kconfig      |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c | 464 ++++++++++++++++++++--
 2 files changed, 443 insertions(+), 30 deletions(-)

-- 
2.23.0

