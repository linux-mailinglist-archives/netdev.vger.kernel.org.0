Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BF92A68D
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfEYSmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:42:38 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:37642 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfEYSmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:42:38 -0400
Received: by mail-wr1-f46.google.com with SMTP id e15so13004068wrs.4
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9FHoGWKnhXV1Xj9GIBtVqwRjJF5D8+QirRgzz7WyGEA=;
        b=u9p5tCKitQQ+3N3B9SsX82eOLACsRepZdL13lZNGwRE78enQ5vcGSEti1meeC5Jr8U
         zME6Wf/EMkKOvHjoLRUKCnt99nQI9Dku52lYYYhwF7mwkHe/MK4InhpqEU2Xh7/FxatM
         wa1BfNbI8yQdUZBGyehVgTLpTUGoAF6P7bhpI8dIHuQBCpHa00fYMAMvWTvjY/yoe0xZ
         +jUvTRehQcR8nQxOgMf0iBdOsLyUxHvR72fwpIyHWwg+E09FQgg6lwcHTMVRzgAQ+k5O
         xO/SWGCB5Icd8tJMyv7SPndDX3m2pHsx0/FUlq2Vu7EUPflSSabNkT1AtANpZjHctzZC
         XZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9FHoGWKnhXV1Xj9GIBtVqwRjJF5D8+QirRgzz7WyGEA=;
        b=WMbyd8gf3mQnEe74SGKy87X17iRKo1guZOiVaVVNVPo/iQUIjHSnjc7AyXxlnVVfAw
         u/EXjSpvUq8FCTUl0a2Q8cIRQaXqsCe+vRcDhsrbEFMbHwUH96ubqmMI4JygUPDm/0c/
         mia3DmaXv37jw2PKOzPpJUnFwpDHg3da/4etW8Ar6GWDoi6q2BJd/WAOim7TpnrwAEZV
         WNK7hN0N+DNfzqmt5SwbcoP7BOKNiJRFMU7yW3InmKUev3thXUVu/nkoWlgR3SGBoYAC
         TWh33VD40mmslmLb3uUqluACt0fuGW299tPJGEpZOUoicSNxzicGViFEv7StTWMXFWXv
         qJ9w==
X-Gm-Message-State: APjAAAXHgtXDOoMgeEmaE3w26qyO5csYCo7Ii+bY3GddWm1qsWu4PhEG
        w8CvrEAEyYHQcSEkRsfmMbCyGl4P
X-Google-Smtp-Source: APXvYqxCoXAQdl04Oi8skR9A0zSyq0PPHZGL4RgLBBFJBnuzUJ0tnvXjipFt+9PVtsACZu1dw8l3KA==
X-Received: by 2002:adf:ce90:: with SMTP id r16mr17237524wrn.156.1558809756664;
        Sat, 25 May 2019 11:42:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id n3sm4025187wrt.44.2019.05.25.11.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:42:35 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: small improvements
Message-ID: <b959316e-562f-c2a8-af20-78e27ba2c8e3@gmail.com>
Date:   Sat, 25 May 2019 20:42:30 +0200
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

Series with small improvements.

Heiner Kallweit (3):
  r8169: remove rtl_hw_init_8168ep
  r8169: remove unneeded return statement in rtl_hw_init_8168g
  r8169: change type of member mac_version in rtl8169_private

 drivers/net/ethernet/realtek/r8169.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

-- 
2.21.0

