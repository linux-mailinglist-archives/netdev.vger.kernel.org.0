Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB93B353A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhFXSJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbhFXSJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:09:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25B5C061768
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y2-20020a0569020522b0290553ecd1c09bso493374ybs.10
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oPZQMlPX45bmQkVAQxeorKCNLcsRF79uERdmVvKJY2w=;
        b=sKjGiKp7Dedeh0lL2aON5qMDI1UDZMaH9a+04kgwGYIk8Op5qmB2+3ttCLdygOxUX1
         n3isO1fJ5q2rtAwKJddqFacYmAB+rcHDJkvWOXl/Zu8MYgUHeFIjz3cReWlT47+58gwO
         I0/VZaB3lpf2D7ib/HTur9iww5jKt50BTuWT6ufe7ha3+7R7ZIwlaerMcq3v3G/4XaMt
         NUxK9zSFrFx/bzm71oOHGPrwUzu7sj8weUYBS4ZjqlbxltJ9LhNxGDd4mddSib52D/QQ
         c0Tl0tpZ8FWoYBK6/JLDn9ZGggMjsnjqXbOo5Uw619pbOkkZ1Jfof2dYu0WtxyujuA8C
         YwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oPZQMlPX45bmQkVAQxeorKCNLcsRF79uERdmVvKJY2w=;
        b=bBU5a7yDkuGPsp76RELTmw7LUNLxdP8ZQxVP8k+xbxJ8NtWSpIpSlI0QrK34yQt47P
         r0485xHo/yDGws4wNw3U8slPBrgiV88Vk04kErF584j5m/v/8DsrFf0DZTORAUKodaHC
         fTZV//7P2uWqJCh4zsWLEzTPh+euYfdxcvNBuP04lD1maY9ReCx6XC2FeHbdkvdP4K9j
         q0iNQTn8UoL+Re1Se0b/fPSEQukbQkfeTn2XSJmtwowa/O2ujnj/okIejCs6FWOzVGOj
         /i0wuoM2VdTxzmfsQGiRfJsp8oZsIR8bid+BOrRzLLv90jBEhujAnfT2ixpstL8uroD1
         3Zgg==
X-Gm-Message-State: AOAM532iVn/14i2PprgLVX1EAYuQ1joKAHa8gL7NjfbR6r1L0hcsCHSC
        uVU28PKWMixXXVR/35KJPebA21g=
X-Google-Smtp-Source: ABdhPJzLg+BV99Cy8vdTtAZUbkxn/cEK9aINk8C5XM7COPfp17FqZHozsZrH9q3xa2kHHlYo27+utjg=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:344:: with SMTP id 65mr6725067ybd.223.1624558051980;
 Thu, 24 Jun 2021 11:07:31 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:17 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-2-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 01/16] gve: Update GVE documentation to describe DQO
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQO is a new descriptor format for our next generation virtual NIC.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 .../device_drivers/ethernet/google/gve.rst    | 53 +++++++++++++++++--
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/google/gve.rst b/Documentation/networking/device_drivers/ethernet/google/gve.rst
index 793693cef6e3..6d73ee78f3d7 100644
--- a/Documentation/networking/device_drivers/ethernet/google/gve.rst
+++ b/Documentation/networking/device_drivers/ethernet/google/gve.rst
@@ -47,13 +47,24 @@ The driver interacts with the device in the following ways:
  - Transmit and Receive Queues
     - See description below
 
+Descriptor Formats
+------------------
+GVE supports two descriptor formats: GQI and DQO. These two formats have
+entirely different descriptors, which will be described below.
+
 Registers
 ---------
-All registers are MMIO and big endian.
+All registers are MMIO.
 
 The registers are used for initializing and configuring the device as well as
 querying device status in response to management interrupts.
 
+Endianness
+----------
+- Admin Queue messages and registers are all Big Endian.
+- GQI descriptors and datapath registers are Big Endian.
+- DQO descriptors and datapath registers are Little Endian.
+
 Admin Queue (AQ)
 ----------------
 The Admin Queue is a PAGE_SIZE memory block, treated as an array of AQ
@@ -97,10 +108,10 @@ the queues associated with that interrupt.
 The handler for these irqs schedule the napi for that block to run
 and poll the queues.
 
-Traffic Queues
---------------
-gVNIC's queues are composed of a descriptor ring and a buffer and are
-assigned to a notification block.
+GQI Traffic Queues
+------------------
+GQI queues are composed of a descriptor ring and a buffer and are assigned to a
+notification block.
 
 The descriptor rings are power-of-two-sized ring buffers consisting of
 fixed-size descriptors. They advance their head pointer using a __be32
@@ -121,3 +132,35 @@ Receive
 The buffers for receive rings are put into a data ring that is the same
 length as the descriptor ring and the head and tail pointers advance over
 the rings together.
+
+DQO Traffic Queues
+------------------
+- Every TX and RX queue is assigned a notification block.
+
+- TX and RX buffers queues, which send descriptors to the device, use MMIO
+  doorbells to notify the device of new descriptors.
+
+- RX and TX completion queues, which receive descriptors from the device, use a
+  "generation bit" to know when a descriptor was populated by the device. The
+  driver initializes all bits with the "current generation". The device will
+  populate received descriptors with the "next generation" which is inverted
+  from the current generation. When the ring wraps, the current/next generation
+  are swapped.
+
+- It's the driver's responsibility to ensure that the RX and TX completion
+  queues are not overrun. This can be accomplished by limiting the number of
+  descriptors posted to HW.
+
+- TX packets have a 16 bit completion_tag and RX buffers have a 16 bit
+  buffer_id. These will be returned on the TX completion and RX queues
+  respectively to let the driver know which packet/buffer was completed.
+
+Transmit
+~~~~~~~~
+A packet's buffers are DMA mapped for the device to access before transmission.
+After the packet was successfully transmitted, the buffers are unmapped.
+
+Receive
+~~~~~~~
+The driver posts fixed sized buffers to HW on the RX buffer queue. The packet
+received on the associated RX queue may span multiple descriptors.
-- 
2.32.0.288.g62a8d224e6-goog

