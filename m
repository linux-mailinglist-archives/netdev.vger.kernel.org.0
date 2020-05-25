Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73A01E171A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgEYV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgEYV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:26:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB93C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:26:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so21754838ejb.3
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5aGUCpfOQgqdswpS8J9Z0Dh+ojiHGHxzaRBOBqahy8=;
        b=TfL7yJvkEkC0QZxKEjex7cSsGAqmJt8zxcrPtq299kWH9e5Q6bTgKE+LvqX13KwSsh
         ezjqxcTL3vGVOk0+4BdEqBhIk92PF0sN0RPGBz8gNjVSX5+bKwN1Kz2NMOOQyQreKGaX
         dHiB8kmn5O3H40D9BmXLcLRtDrcHzRobJJOY/XhaMFItSngYD/ZR3vTA6I1KmLxhkIvU
         Y7wC0wZ/iGOuLW/zU/VKqa5TpR5JK538Li4dKq4uc5Alaj09I9qoMItXmBw9Kv+B3Gcq
         LbgkNPSEtRY+QLQcTlnC/jlduUbhZUvUia63tspHuFU7JXWfR1zzOD4GVtAqSrA3b60m
         5oBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+5aGUCpfOQgqdswpS8J9Z0Dh+ojiHGHxzaRBOBqahy8=;
        b=iZYYW4bAfhTWogHxmi/5zSoYjwyR511ZSg/bhk1paC7UrOjHOaSoFv/Hjkr4g7Q/ek
         lsPqTwjeAFvlIwEZHjwVeq9PBMmzdmrgU/VYlJ7kq0HxAVeG2bgSKIkSI6j0UIOK0CS+
         dMqUui66yKkXl3dr4EpmVufz+nZ4PLzrN8lmNNTy6avaxYzRqcdweaXPLICkaXT4Wv9w
         Nny2NZevkdmHN5wZzKdrVG3v2zq25GjS/TLES+Ue0QnhlKMN4a0rdXuRym+CeuYBnmbI
         xg3tT/EeqhzU1gP8CZ4nzGXDFIrm6eRMQK5zg96QHW1iHLucETYTbrKkKgJRwtUEJCQ6
         PpGg==
X-Gm-Message-State: AOAM53103PZd5D2PQgquwjAVkKmGhLSj3NHuSHSa7UJQUxUJxgpLO05I
        kNzMjSzowN/4nmdXymGin6w=
X-Google-Smtp-Source: ABdhPJyUMzpn1A0ChaquwNu5rDU+e82G1r7EVBPw74732HlJJuCEk82Nm+fE7andwIkcbhovcujpsA==
X-Received: by 2002:a17:906:1199:: with SMTP id n25mr21571460eja.14.1590441959552;
        Mon, 25 May 2020 14:25:59 -0700 (PDT)
Received: from localhost.localdomain ([151.56.81.222])
        by smtp.gmail.com with ESMTPSA id lf23sm16041900ejb.46.2020.05.25.14.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 14:25:59 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: add Telit LE910C1-EUX composition
Date:   Mon, 25 May 2020 23:25:37 +0200
Message-Id: <20200525212537.2227-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Telit LE910C1-EUX composition

0x1031: tty, tty, tty, rmnet
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hi Bjørn,

following the output of lsusb:

Bus 003 Device 007: ID 1bc7:1031 Telit Wireless Solutions 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1bc7 Telit Wireless Solutions
  idProduct          0x1031 
  bcdDevice            0.00
  iManufacturer           3 Telit
  iProduct                2 LE910C1-EUX
  iSerial                 4 7e234fe0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          122
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          1 Telit Configuration
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    254 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Thanks
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 4bb8552a00d3..4a2c7355be63 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1324,6 +1324,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
-- 
2.17.1

