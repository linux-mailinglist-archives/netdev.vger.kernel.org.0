Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DD91E9413
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgE3Vwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Vwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:52:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A764C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:52:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so7167359wmh.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EgcGYW46G8m5It3IOHPx1TouGcF+iBFwxJsBjFlvFhk=;
        b=Pr1f62lO2NM5CGaoSzdFxhlvwAPg6YFyiDg6e4QXdi+5VFRF4hNlWDEcu3lc0bGQ0k
         B06e7TcFjTJqj21ZGycS1a5l5V7/d2mWMDMzSvbU1h+f71kXUHhC5vu6dQRgClgY16BK
         vvxxMexjuYnPEWtcQPTHSvQGU4GnkIzTvz3Squ8WAdg4jm+1anJWZWikxtcIgZRFtgoH
         IOID2W+7xHoZQhXrmlnLjpsC0dwiW6apduWoYHZhciO7KgiOZ+2GgW48HOk7p0BHSaGP
         r6HgnieuwryfdaS9qg+4slN29eu3tC4Fwzyh6UJiMeT+6+R3sSjUM1SYGWj0XtTlh31r
         k/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EgcGYW46G8m5It3IOHPx1TouGcF+iBFwxJsBjFlvFhk=;
        b=U3NUWRtL/aGgEM7ssm3O0iNcUC90Dcz87IIvuD0lb+px2Lf/ek62BSI3PSV+yY7rsH
         A4G1ePnHlKEUa+5xuuNSYB9Z66T0T+hm2tV9WO/xC9XhKUFWu0ubW5Y0jRIRZ3Q/1tRS
         YnYayhFaBl2EgmgSdFjHnZqr+E0FotaXPJcX9lBN7w9LXsC9kYOcMAuU1FM6UyoTHKiC
         3+U7g58JteL5L2g4zsGRxqCdPgHG+c1DkhbBzKygCPrnDyg+jQ2qeHSdpfaEW/+cxgcP
         UoIrRL+s2rH6FT+jrR4omrckQhVXjDEbYzCBheSMsKKHOOtlcCXC8AOeR54xCfQjjWiL
         rc/Q==
X-Gm-Message-State: AOAM530dgtKOu/XpPyRiyTsA4DnFte2s+U6j1y2sdkGhXxjFD0KwIh0a
        ZUiebWc92sSgYEBQ3n4scdG2acqv
X-Google-Smtp-Source: ABdhPJwdV01mddDeVwZN4GgXbS+u5yA7R9QVHg1So5B4uzU7AzUs0H4odR5OQc5P7xSMDRGtfaw6tA==
X-Received: by 2002:a1c:5683:: with SMTP id k125mr15332809wmb.55.1590875557608;
        Sat, 30 May 2020 14:52:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id r5sm15984466wrq.0.2020.05.30.14.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 14:52:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/6] r8169: again few improvements
Message-ID: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Date:   Sat, 30 May 2020 23:52:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Again a series with few r8169 improvements.

Heiner Kallweit (6):
  r8169: change driver data type
  r8169: enable WAKE_PHY as only WoL source when runtime-suspending
  r8169: don't reset tx ring indexes in rtl8169_tx_clear
  r8169: move some calls to rtl8169_hw_reset
  r8169: make rtl8169_down central chip quiesce function
  r8169: improve handling power management ops

 drivers/net/ethernet/realtek/r8169_main.c | 199 +++++++++-------------
 1 file changed, 82 insertions(+), 117 deletions(-)

-- 
2.26.2

