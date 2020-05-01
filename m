Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC931C1B87
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgEARUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729025AbgEARUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:20:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7AC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 10:20:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x17so12250168wrt.5
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 10:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TGZZdu+4jqVBp8qgZIYAza9OIwEHIuGjhJhxIzenNQ0=;
        b=Vljtw433uMCPVf6x09Ue6RMszbqd319dVlP/iWK1ljcMdo6Uy2RU0VE8rKiNJ6dJuu
         h7DmCsDSZGXDXRYL4p6O5faeQJvKLihgKscCYK8PeUV+Wz9d0K9hyzQ8/iSVC7cTcNd3
         urOD5wRnNiw8BZqqeNiO897tPivAvcMslYafcXqX3B5+5563UD1riPwj/14CUAjU2OT4
         Ls/LGqMAxFOK86BRHgaDOvjZWSbmwJXgKxkNv07bOrgjqOhKnWIxZQRDhpAUbRdhTu60
         tlUeGB/CDJ6O0AVC2LagKQuaghSqNOLaf+dIf0EQgTdKZQlC1Ik/pgSIm/nNONieGun+
         Vn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TGZZdu+4jqVBp8qgZIYAza9OIwEHIuGjhJhxIzenNQ0=;
        b=f7lQwWQMNBMidZGLXiXMUlS/HTJfDEU6TSEwz4WbW4FTncGaFmc5danhXZWS1I10JG
         nk/S071xTzppGtP/qMi9hds6CwJljR8l0FD2L5yyzJ9K6JkKCvyur0qdap8H1goyj/1V
         VPZ3jdn5IKBwMvIvlNc7qqSrPjb3kcJWVfyL5OZbD74OWiFFC6AutX6+5KcbM9Nnf2R1
         VSpNHz7bXnpz+plh6j8NlAKlqvWKUpQVkdJEQeFg0gpHzKq3CFh9+6YVXxsy5StrK+AL
         2vnTBjVoXu0+R/AGSPPyxmENktPYKrqmFsx273iawh7NDJgeVLtvjVoRFDN4q8wfC3kB
         SbrA==
X-Gm-Message-State: AGi0PuYGKvp1DVj1bLw6JdnPSbnFnJqkUyP+LzV2Egc6yH8+716B/oWN
        WlqEhouXXQZC3CFhVZ+DFjdRcQYt
X-Google-Smtp-Source: APiQypJ1YC4yFQjgIjmDT9A/RKJdeyIAUlo2ZhCdCRmfZZbjizHqK73rNeP3YfMLx1dfaC3eQvstKA==
X-Received: by 2002:adf:df04:: with SMTP id y4mr5123237wrl.413.1588353632004;
        Fri, 01 May 2020 10:20:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:54e4:3086:385e:b03b? (p200300EA8F06EE0054E43086385EB03B.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:54e4:3086:385e:b03b])
        by smtp.googlemail.com with ESMTPSA id e13sm3403527wrw.88.2020.05.01.10.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:20:31 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: improve user message handling
Message-ID: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Date:   Fri, 1 May 2020 19:20:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series improves few aspects of handling messages to users.

Heiner Kallweit (4):
  r8169: remove redundant driver message when entering promiscuous mode
  r8169: simplify counter handling
  r8169: remove "out of memory" error message from rtl_request_firmware
  r8169: switch from netif_xxx message functions to netdev_xxx

 drivers/net/ethernet/realtek/r8169_main.c | 112 +++++++---------------
 1 file changed, 36 insertions(+), 76 deletions(-)

-- 
2.26.2

