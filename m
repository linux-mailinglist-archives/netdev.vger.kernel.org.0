Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE1B249737
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHSH13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgHSH0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:26:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7EEC06134D
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so1117103wme.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RkOjJ69pRTSz/Fg8WRhIEqNj+FDSDFt6r37nJYyUwx8=;
        b=E7i+hPgWDGeE0uSAdDfCAVUuhE+SKaulwFYSTh37d8JeSQd3u2Cq/RfEDGpA3UyWS6
         t0owPciisQQYwXmfaran/Aa0SRE3aTMdC5mQ/e1Lk/WXvwckIlnG5Gi+baoykg2LKZ0x
         KOBzaVPxVEmLUfNTniCAMckBq7T/VpkECTLwcbTtAOkIl64Sn0ffNqzLdYYd/uBS6t3q
         QN1JyZS9//8rGMvTunx6EdnlJ5uT5FrnvbbXYY7M/0GbWORPlApgrqS1dsaTLvt8U4le
         ufW74XFI1sqJmnlfoqIa0tpZb2QnIYbp91SzLEevHTYFONKvup6SD9XO9+DS3zfWDhHG
         gRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RkOjJ69pRTSz/Fg8WRhIEqNj+FDSDFt6r37nJYyUwx8=;
        b=JfhqUcIPLTgPcc5XXeKST0LdwoJFMuT/jaZAQyxiU+I/C8AJeQEw1KrQWPRvpcgKnz
         o5ALW3t3i2NkkKbOKof9b/1qVcMT4Pk2DoZb+5SS29d+kAQ0fz7LPzCmOVx+XTgbJa6n
         iOIsXFBoiuclMxc+MQa3Y4O9kEckIHdfzcAjUs5vH6UuiqWK4eRQsfXFX/s7GATGfcoz
         dSDTra0LKzuWsKhjleWzC/jVwOkP8FaMS0GiWOwghD7OPh8i6JHjeElkTPXahsmzw15v
         EwskI66RwFnxhiVywoZxhyKpp/9w9/srrV4VQUa5lLjMYlsWv4FyawHlNWBxvZgx6OdU
         hyww==
X-Gm-Message-State: AOAM53186idRMZaRmUiOtzWO2Hj1vsnoTwhGjGu0X1vWap/6m/+sC3q7
        8wPn6B0QtBEnl0qecK7feiIXDQ==
X-Google-Smtp-Source: ABdhPJxWnJ4rFuXa3H0fQxiqSyqn8xc8VRKNlceC+LocVAPn1vSeY0f4D2YWcEVeXiOh12M0YFh5/Q==
X-Received: by 2002:a05:600c:c3:: with SMTP id u3mr773879wmm.1.1597821879174;
        Wed, 19 Aug 2020 00:24:39 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:38 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 27/28] wireless: marvell: libertas_tf: if_usb: Fix function documentation formatting errors
Date:   Wed, 19 Aug 2020 08:24:01 +0100
Message-Id: <20200819072402.3085022-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/marvell/libertas_tf/if_usb.c:56: warning: Function parameter or member 'urb' not described in 'if_usb_write_bulk_callback'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:73: warning: Function parameter or member 'cardp' not described in 'if_usb_free'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:146: warning: Function parameter or member 'intf' not described in 'if_usb_probe'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:146: warning: Function parameter or member 'id' not described in 'if_usb_probe'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:244: warning: Function parameter or member 'intf' not described in 'if_usb_disconnect'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:272: warning: Function parameter or member 'cardp' not described in 'if_usb_send_fw_pkt'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:372: warning: Function parameter or member 'cardp' not described in 'usb_tx_block'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:372: warning: Function parameter or member 'payload' not described in 'usb_tx_block'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:372: warning: Function parameter or member 'nb' not described in 'usb_tx_block'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:372: warning: Function parameter or member 'data' not described in 'usb_tx_block'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:625: warning: Function parameter or member 'urb' not described in 'if_usb_receive'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:714: warning: Function parameter or member 'priv' not described in 'if_usb_host_to_card'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:714: warning: Function parameter or member 'type' not described in 'if_usb_host_to_card'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:714: warning: Function parameter or member 'payload' not described in 'if_usb_host_to_card'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:714: warning: Function parameter or member 'nb' not described in 'if_usb_host_to_card'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:742: warning: Function parameter or member 'cardp' not described in 'if_usb_issue_boot_command'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:742: warning: Function parameter or member 'ivalue' not described in 'if_usb_issue_boot_command'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:766: warning: Function parameter or member 'data' not described in 'check_fwfile_format'
 drivers/net/wireless/marvell/libertas_tf/if_usb.c:766: warning: Function parameter or member 'totlen' not described in 'check_fwfile_format'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/marvell/libertas_tf/if_usb.c | 37 ++++++++++---------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index bedc092150884..a92916dc81a96 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -50,7 +50,7 @@ static int if_usb_reset_device(struct lbtf_private *priv);
 /**
  *  if_usb_wrike_bulk_callback -  call back to handle URB status
  *
- *  @param urb		pointer to urb structure
+ *  @urb:		pointer to urb structure
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
@@ -67,7 +67,7 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 /**
  *  if_usb_free - free tx/rx urb, skb and rx buffer
  *
- *  @param cardp	pointer if_usb_card
+ *  @cardp:	pointer if_usb_card
  */
 static void if_usb_free(struct if_usb_card *cardp)
 {
@@ -136,8 +136,8 @@ static const struct lbtf_ops if_usb_ops = {
 /**
  *  if_usb_probe - sets the configuration values
  *
- *  @ifnum	interface number
- *  @id		pointer to usb_device_id
+ *  @intf:	USB interface structure
+ *  @id:	pointer to usb_device_id
  *
  *  Returns: 0 on success, error code on failure
  */
@@ -238,7 +238,7 @@ lbtf_deb_leave(LBTF_DEB_MAIN);
 /**
  *  if_usb_disconnect -  free resource and cleanup
  *
- *  @intf	USB interface structure
+ *  @intf:	USB interface structure
  */
 static void if_usb_disconnect(struct usb_interface *intf)
 {
@@ -264,7 +264,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 /**
  *  if_usb_send_fw_pkt -  This function downloads the FW
  *
- *  @priv	pointer to struct lbtf_private
+ *  @cardp:	pointer if_usb_card
  *
  *  Returns: 0
  */
@@ -360,10 +360,10 @@ static int if_usb_reset_device(struct lbtf_private *priv)
 /**
  *  usb_tx_block - transfer data to the device
  *
- *  @priv	pointer to struct lbtf_private
- *  @payload	pointer to payload data
- *  @nb		data length
- *  @data	non-zero for data, zero for commands
+ *  @cardp:	pointer if_usb_card
+ *  @payload:	pointer to payload data
+ *  @nb:	data length
+ *  @data:	non-zero for data, zero for commands
  *
  *  Returns: 0 on success, nonzero otherwise.
  */
@@ -619,7 +619,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 /**
  *  if_usb_receive - read data received from the device.
  *
- *  @urb		pointer to struct urb
+ *  @urb:		pointer to struct urb
  */
 static void if_usb_receive(struct urb *urb)
 {
@@ -702,10 +702,10 @@ static void if_usb_receive(struct urb *urb)
 /**
  *  if_usb_host_to_card -  Download data to the device
  *
- *  @priv		pointer to struct lbtf_private structure
- *  @type		type of data
- *  @buf		pointer to data buffer
- *  @len		number of bytes
+ *  @priv:		pointer to struct lbtf_private structure
+ *  @type:		type of data
+ *  @payload:		pointer to payload buffer
+ *  @nb:		number of bytes
  *
  *  Returns: 0 on success, nonzero otherwise
  */
@@ -734,7 +734,8 @@ static int if_usb_host_to_card(struct lbtf_private *priv, uint8_t type,
 /**
  *  if_usb_issue_boot_command - Issue boot command to Boot2.
  *
- *  @ivalue   1 boots from FW by USB-Download, 2 boots from FW in EEPROM.
+ *  @cardp:	pointer if_usb_card
+ *  @ivalue:   1 boots from FW by USB-Download, 2 boots from FW in EEPROM.
  *
  *  Returns: 0
  */
@@ -757,8 +758,8 @@ static int if_usb_issue_boot_command(struct if_usb_card *cardp, int ivalue)
 /**
  *  check_fwfile_format - Check the validity of Boot2/FW image.
  *
- *  @data	pointer to image
- *  @totlen	image length
+ *  @data:	pointer to image
+ *  @totlen:	image length
  *
  *  Returns: 0 if the image is valid, nonzero otherwise.
  */
-- 
2.25.1

