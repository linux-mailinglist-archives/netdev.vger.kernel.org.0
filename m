Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08ECF1392C1
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgAMN5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:57:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55246 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgAMN5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:57:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so9755785wmj.4
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 05:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mM4KPo3nqeIlVIf5fJtUdxW+d1VvaKbfN6aq80ESK30=;
        b=fYiPeIZx968KOscCXeSZGArG+8F9AyToaTi0NlthTv6JVsEQaeN3fXqu4emp73vn4B
         WVMI6g0MQLQL8O10NHVbdLIwuE7WkDXRcP+bhQEeUlJAjyu763L0tSgRf2LAS9F5Ydl/
         aNZ/vduK1Fqo8y9FQUecy/NgNW0n1YlvczM7hwDl+K7J94EDGh69wz71kHIUvqejB9jC
         7WdmjAVmp+xC3ATDi9HJ2tTtPTHDnS18RJHh1ZagKC8xvbzShgqJan8CKrIdTtHqUaY0
         gNdsYOTYl6yCQRkPzFJQhmrWZW83RPgWgC4TEWKdhwTUIYeadB1mKV+4lSjzYB4FEH8O
         ZqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mM4KPo3nqeIlVIf5fJtUdxW+d1VvaKbfN6aq80ESK30=;
        b=nU/oY59gr/j/q0FOVkaa+NTNHi1f8+hTtN1UcTHonvnyHOYd4yK+SQIsN0cAI15ta+
         tEur5zsY+/Je0zb2DtoI7d0BHxh9T/8rFkxJtb6GL/aZ6LnhOnvzC8rbyygK6tEV8Hcg
         xOvtTCM/3jjJmfYAxhceCVQEeeLw8TZbqjp1vhy2xngqFqrLR0zeG0YSA5SBP3HVG1h1
         ExKK2ZW47E9I3E1gSz5GIMZE2Gyj0yWGW94F8fEPjwMNLaVutYRmCDjPnQpgo5JflPAn
         ffmDkHB6E/hfUSvjILOJq/cl8E5LrLOj1LU5eaiZvdZVLbOX8I3cyctprpSMyfW0P6Ix
         pTEQ==
X-Gm-Message-State: APjAAAX6rx40+OfCKfRydlnMtWkSs4dv3ZV6pNTVJFPcwbWYTVZw5QJu
        j//k7THA6XArrGef7Wdtk3usyMaW
X-Google-Smtp-Source: APXvYqyCYGuyxmABkCUHjcwZNf/ZTVUXjVeMxI7K2tm47T+LQj+2POiorKk37zrdOWUSMoMnEpMt3Q==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr20428600wmi.35.1578923862503;
        Mon, 13 Jan 2020 05:57:42 -0800 (PST)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id w20sm14267669wmk.34.2020.01.13.05.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 05:57:42 -0800 (PST)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, bjorn@mork.no
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH net] qmi_wwan: Add support for Quectel RM500Q
Date:   Mon, 13 Jan 2020 14:57:40 +0100
Message-Id: <20200113135740.31600-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RM500Q is a 5G module from Quectel, supporting both standalone and
non-standalone modes. The normal Quectel quirks apply (DTR and dynamic
interface numbers).

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 4196c0e32740..9485c8d1de8a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1062,6 +1062,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
-- 
2.20.1

